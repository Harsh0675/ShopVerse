require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');
const { version } = require('../package.json');

const app = express();
app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
app.use(express.json({limit:'1mb'}));
app.disable('x-powered-by');
app.use((req,res,next)=>{
  res.setHeader('X-Content-Type-Options','nosniff');
  res.setHeader('X-Frame-Options','DENY');
  res.setHeader('Referrer-Policy','no-referrer');
  next();
});
const rate = new Map();
app.use('/api/',(req,res,next)=>{
  const key=req.ip||'unknown', now=Date.now(), x=rate.get(key)||{t:now,n:0};
  if(now-x.t>60000){x.t=now;x.n=0}
  x.n++;
  rate.set(key,x);
  if(x.n>120)return res.status(429).json({error:'Too many requests'});
  next();
});
const pool = new Pool({ connectionString: process.env.DATABASE_URL });

const sign = u => jwt.sign({ id:u.id,email:u.email,role:u.role }, process.env.JWT_SECRET || 'dev-secret', {expiresIn:'7d'});

app.get('/api/health', (_,res)=>res.json({ok:true,service:'shopverse-api',version}));

app.get('/api/categories', async (_,res)=>{
  try { const r=await pool.query('SELECT category,COUNT(*)::int AS count FROM products GROUP BY category ORDER BY category'); res.json(r.rows); }
  catch(e){res.status(500).json({error:'Database unavailable'});}
});

app.post('/api/ai/recommend', async (req,res)=>{
  const prompt=String(req.body?.prompt||'').toLowerCase();
  try {
    const r=await pool.query('SELECT id,name,category,description,price,rating FROM products ORDER BY rating DESC, created_at DESC LIMIT 50');
    let rows=r.rows;
    const nums=prompt.match(/\d[\d,]*/g)?.map(x=>Number(x.replace(/,/g,'')))||[];
    const budget=nums.length?Math.max(...nums):Infinity;
    const category=['electronics','fashion','home'].find(x=>prompt.includes(x));
    if(category) rows=rows.filter(x=>x.category.toLowerCase()===category);
    if(Number.isFinite(budget)) rows=rows.filter(x=>Number(x.price)<=budget);
    res.json({type:'catalog-recommendation',answer:rows.length?'Here are products matching your request.':'No exact matches found.',products:rows.slice(0,8)});
  } catch(e){res.status(500).json({error:'Recommendation service unavailable'});}
});

app.get('/api/products', async (req,res)=>{
  try {
    const q = String(req.query.q||'').trim();
    const r = await pool.query(
      `SELECT id,name,category,description,price,image_url,stock,rating
       FROM products WHERE ($1='' OR name ILIKE '%'||$1||'%' OR category ILIKE '%'||$1||'%')
       ORDER BY created_at DESC LIMIT 100`, [q]);
    res.json(r.rows);
  } catch(e){ res.status(500).json({error:'Database unavailable'}); }
});

app.get('/api/products/:id', async (req,res)=>{
  try {
    const r=await pool.query('SELECT * FROM products WHERE id=$1',[req.params.id]);
    if(!r.rowCount) return res.status(404).json({error:'Product not found'});
    res.json(r.rows[0]);
  } catch(e){res.status(500).json({error:'Database unavailable'});}
});

app.post('/api/auth/register', async (req,res)=>{
  const {email,password,name=''}=req.body||{};
  if(!email||!password||password.length<8) return res.status(400).json({error:'Email and password (8+ chars) required'});
  try {
    const hash=await bcrypt.hash(password,12);
    const r=await pool.query('INSERT INTO users(email,password_hash,name) VALUES($1,$2,$3) RETURNING id,email,name,role',[email.toLowerCase(),hash,name]);
    res.status(201).json({user:r.rows[0],token:sign(r.rows[0])});
  } catch(e){res.status(409).json({error:'Account may already exist'});}
});

app.post('/api/auth/login', async (req,res)=>{
  const {email,password}=req.body||{};
  try {
    const r=await pool.query('SELECT * FROM users WHERE email=$1',[String(email||'').toLowerCase()]);
    if(!r.rowCount || !(await bcrypt.compare(password||'',r.rows[0].password_hash))) return res.status(401).json({error:'Invalid credentials'});
    const u=r.rows[0]; res.json({user:{id:u.id,email:u.email,name:u.name,role:u.role},token:sign(u)});
  } catch(e){res.status(500).json({error:'Database unavailable'});}
});

function auth(req,res,next){
  try { const h=req.headers.authorization||''; if(!h.startsWith('Bearer ')) throw 0;
    req.user=jwt.verify(h.slice(7),process.env.JWT_SECRET||'dev-secret'); next();
  } catch { res.status(401).json({error:'Authentication required'}); }
}

app.post('/api/orders',auth,async(req,res)=>{
  const {items,address,total}=req.body||{};
  if(!Array.isArray(items)||!items.length) return res.status(400).json({error:'Items required'});
  if(!address || String(address).length<8) return res.status(400).json({error:'Valid delivery address required'});
  if(!Number.isFinite(Number(total)) || Number(total)<0) return res.status(400).json({error:'Invalid order total'});
  if(items.some(x=>!x.product_id || !Number.isInteger(Number(x.quantity)) || Number(x.quantity)<1 || !Number.isFinite(Number(x.unit_price))))
    return res.status(400).json({error:'Invalid order items'});
  const idem=req.headers['idempotency-key'];
  if(idem){try{const q=await pool.query('SELECT order_id FROM idempotency_keys WHERE user_id=$1 AND key=$2',[req.user.id,String(idem)]);if(q.rowCount){const o=await pool.query('SELECT * FROM orders WHERE id=$1',[q.rows[0].order_id]);return res.status(200).json(o.rows[0]);}}catch(_){} }
  const client=await pool.connect();
  try {
    await client.query('BEGIN');
    const o=await client.query('INSERT INTO orders(user_id,total,address,status) VALUES($1,$2,$3,$4) RETURNING *',[req.user.id,total,address||'', 'pending']);
    if(idem) await client.query('INSERT INTO idempotency_keys(user_id,key,order_id) VALUES($1,$2,$3) ON CONFLICT DO NOTHING',[req.user.id,String(idem),o.rows[0].id]);
    for(const x of items) await client.query('INSERT INTO order_items(order_id,product_id,quantity,unit_price) VALUES($1,$2,$3,$4)',[o.rows[0].id,x.product_id,x.quantity,x.unit_price]);
    await client.query('COMMIT'); res.status(201).json(o.rows[0]);
  } catch(e){await client.query('ROLLBACK');res.status(500).json({error:'Could not create order'});} finally{client.release();}
});

function requireFields(body, fields){
  const missing=fields.filter(k=>body?.[k]===undefined || body?.[k]===null || body?.[k]==='');
  return missing;
}

app.post('/api/payments/create-intent',auth,async(req,res)=>{
  const missing=requireFields(req.body,['amount','currency']);
  if(missing.length)return res.status(400).json({error:`Missing: ${missing.join(', ')}`});
  const amount=Number(req.body.amount), currency=String(req.body.currency).toUpperCase();
  if(!Number.isFinite(amount)||amount<=0||amount>10000000)return res.status(400).json({error:'Invalid amount'});
  res.status(501).json({error:'Payment provider not configured',provider:null,amount,currency});
});

app.post('/api/coupons/validate',async(req,res)=>{
  const code=String(req.body?.code||'').trim().toUpperCase();
  if(!code)return res.status(400).json({valid:false,error:'Coupon code required'});
  try{
    const r=await pool.query('SELECT code,discount_percent,max_discount,expires_at FROM coupons WHERE code=$1 AND active=true',[code]);
    if(!r.rowCount)return res.json({valid:false});
    const x=r.rows[0]; if(x.expires_at && new Date(x.expires_at)<new Date())return res.json({valid:false});
    res.json({valid:true,code:x.code,discountPercent:Number(x.discount_percent),maxDiscount:x.max_discount?Number(x.max_discount):null});
  }catch(e){res.status(500).json({error:'Database unavailable'});}
});

app.get('/api/orders',auth,async(req,res)=>{
  try{
    const r=await pool.query('SELECT id,total,address,status,created_at FROM orders WHERE user_id=$1 ORDER BY created_at DESC',[req.user.id]);
    res.json(r.rows);
  }catch(e){res.status(500).json({error:'Database unavailable'});}
});

app.get('/api/orders/:id',auth,async(req,res)=>{
  try{
    const r=await pool.query('SELECT id,total,address,status,created_at FROM orders WHERE id=$1 AND user_id=$2',[req.params.id,req.user.id]);
    if(!r.rowCount)return res.status(404).json({error:'Order not found'});
    const items=await pool.query('SELECT product_id,quantity,unit_price FROM order_items WHERE order_id=$1',[req.params.id]);
    res.json({...r.rows[0],items:items.rows});
  }catch(e){res.status(500).json({error:'Database unavailable'});}
});

if (require.main === module) {
  app.listen(process.env.PORT||4000,()=>console.log(`ShopVerse API listening on ${process.env.PORT||4000}`));
}

module.exports = app;
