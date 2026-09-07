CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TABLE IF NOT EXISTS users (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 email TEXT UNIQUE NOT NULL,
 password_hash TEXT NOT NULL,
 name TEXT NOT NULL DEFAULT '',
 role TEXT NOT NULL DEFAULT 'customer',
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS products (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 name TEXT NOT NULL,
 category TEXT NOT NULL,
 description TEXT NOT NULL DEFAULT '',
 price NUMERIC(12,2) NOT NULL CHECK(price>=0),
 image_url TEXT NOT NULL DEFAULT '',
 stock INT NOT NULL DEFAULT 0 CHECK(stock>=0),
 rating NUMERIC(2,1) NOT NULL DEFAULT 0,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS orders (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 user_id UUID NOT NULL REFERENCES users(id),
 total NUMERIC(12,2) NOT NULL CHECK(total>=0),
 address TEXT NOT NULL,
 status TEXT NOT NULL DEFAULT 'pending',
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS order_items (
 id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
 order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
 product_id UUID NOT NULL REFERENCES products(id),
 quantity INT NOT NULL CHECK(quantity>0),
 unit_price NUMERIC(12,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS products_category_idx ON products(category);
CREATE INDEX IF NOT EXISTS orders_user_idx ON orders(user_id);

CREATE TABLE IF NOT EXISTS coupons (
 code TEXT PRIMARY KEY,
 discount_percent NUMERIC(5,2) NOT NULL CHECK(discount_percent>=0 AND discount_percent<=100),
 max_discount NUMERIC(12,2),
 expires_at TIMESTAMPTZ,
 active BOOLEAN NOT NULL DEFAULT true
);
CREATE TABLE IF NOT EXISTS idempotency_keys (
 user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 key TEXT NOT NULL,
 order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 PRIMARY KEY(user_id,key)
);
