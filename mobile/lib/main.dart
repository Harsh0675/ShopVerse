import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/product.dart';
import 'core/auth.dart';
import 'features/cart/cart_model.dart';

const products = <Product>[
 Product(id:'1',name:'Wireless Headphones',category:'Electronics',description:'Immersive wireless audio with all-day battery.',price:2999,rating:4.6,stock:50,imageUrl:''),
 Product(id:'2',name:'Smart Watch',category:'Electronics',description:'Fitness tracking, notifications and a bright display.',price:4499,rating:4.5,stock:35,imageUrl:''),
 Product(id:'3',name:'Everyday Sneakers',category:'Fashion',description:'Lightweight sneakers for daily comfort.',price:2499,rating:4.7,stock:70,imageUrl:''),
 Product(id:'4',name:'Minimal Backpack',category:'Fashion',description:'Durable everyday backpack with smart storage.',price:1899,rating:4.4,stock:45,imageUrl:''),
 Product(id:'5',name:'Desk Lamp',category:'Home',description:'Adjustable lamp for a focused workspace.',price:1299,rating:4.3,stock:80,imageUrl:''),
 Product(id:'6',name:'Coffee Maker',category:'Home',description:'Compact coffee maker for fresh coffee at home.',price:3599,rating:4.6,stock:25,imageUrl:''),
];

void main()=>runApp(ChangeNotifierProvider(create:(_)=>CartModel(),child:const ShopVerse()));

class ShopVerse extends StatelessWidget{
 const ShopVerse({super.key});
 @override Widget build(BuildContext c)=>MaterialApp(
  debugShowCheckedModeBanner:false,title:'ShopVerse',
  theme:ThemeData(useMaterial3:true,colorSchemeSeed:const Color(0xff5b4bff),brightness:Brightness.light),
  darkTheme:ThemeData(useMaterial3:true,colorSchemeSeed:const Color(0xff8b7cff),brightness:Brightness.dark),
  themeMode:ThemeMode.system,home:const AppShell());
}

class AppShell extends StatefulWidget{const AppShell({super.key});@override State<AppShell> createState()=>_AppShellState();}
class _AppShellState extends State<AppShell>{
 int tab=0;
 final pages=const [HomePage(),CartPage(),OrdersPage(),ProfilePage()];
 @override Widget build(BuildContext c)=>Scaffold(body:SafeArea(child:pages[tab]),bottomNavigationBar:NavigationBar(
  selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),
  destinations:const[
   NavigationDestination(icon:Icon(Icons.storefront_outlined),selectedIcon:Icon(Icons.storefront),label:'Shop'),
   NavigationDestination(icon:Icon(Icons.shopping_bag_outlined),selectedIcon:Icon(Icons.shopping_bag),label:'Cart'),
   NavigationDestination(icon:Icon(Icons.receipt_long_outlined),selectedIcon:Icon(Icons.receipt_long),label:'Orders'),
   NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile'),
  ]));
}

class HomePage extends StatefulWidget{const HomePage({super.key});@override State<HomePage> createState()=>_HomePageState();}
class _HomePageState extends State<HomePage>{
 String q='';String cat='All';
 @override Widget build(BuildContext c){
  final list=products.where((p)=>(cat=='All'||p.category==cat)&&(q.isEmpty||p.name.toLowerCase().contains(q.toLowerCase())||p.category.toLowerCase().contains(q.toLowerCase()))).toList();
  return CustomScrollView(slivers:[
   SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(20,18,20,8),child:Row(children:[
    const Expanded(child:Text('ShopVerse',style:TextStyle(fontSize:32,fontWeight:FontWeight.w900))),
    IconButton(onPressed:()=>showSearch(context:context,delegate:ProductSearch()),icon:const Icon(Icons.search)),
    IconButton(onPressed:()=>showModalBottomSheet(context:context,builder:(_)=>const AiAssistantSheet()),icon:const Icon(Icons.auto_awesome)),
   ]))),
   SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.symmetric(horizontal:20,vertical:8),child:Container(
    padding:const EdgeInsets.all(22),decoration:BoxDecoration(borderRadius:BorderRadius.circular(28),color:Theme.of(c).colorScheme.primaryContainer),
    child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
     Text('Smart shopping',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900)),
     SizedBox(height:5),Text('Discover products picked for your next purchase.'),
    ]))),
   SliverToBoxAdapter(child:SizedBox(height:58,child:ListView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:16),children:
    ['All','Electronics','Fashion','Home'].map((x)=>Padding(padding:const EdgeInsets.only(right:8),child:ChoiceChip(label:Text(x),selected:cat==x,onSelected:(_)=>setState(()=>cat=x)))).toList()))),
   SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(20,5,20,14),child:Text('${list.length} products',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)))),
   SliverPadding(padding:const EdgeInsets.symmetric(horizontal:16),sliver:SliverGrid(
    delegate:SliverChildBuilderDelegate((_,i)=>ProductCard(product:list[i]),childCount:list.length),
    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,childAspectRatio:.67,crossAxisSpacing:12,mainAxisSpacing:12))),
   const SliverToBoxAdapter(child:SizedBox(height:20)),
  ]);
 }
}

class ProductSearch extends SearchDelegate<Product?>{
 @override List<Widget>? buildActions(BuildContext c)=>[IconButton(onPressed:()=>query='',icon:const Icon(Icons.clear))];
 @override Widget? buildLeading(BuildContext c)=>IconButton(onPressed:()=>close(c,null),icon:const Icon(Icons.arrow_back));
 @override Widget buildResults(BuildContext c)=>ListView(children:products.where((p)=>p.name.toLowerCase().contains(query.toLowerCase())).map((p)=>ListTile(
  leading:const CircleAvatar(child:Icon(Icons.shopping_bag)),title:Text(p.name),subtitle:Text('₹${p.price.toStringAsFixed(0)}'),onTap:()=>close(c,p))).toList());
 @override Widget buildSuggestions(BuildContext c)=>buildResults(c);
}

class ProductCard extends StatelessWidget{
 final Product product;const ProductCard({super.key,required this.product});
 @override Widget build(BuildContext c)=>Card(clipBehavior:Clip.antiAlias,elevation:0,child:InkWell(
  onTap:()=>showModalBottomSheet(context:c,isScrollControlled:true,showDragHandle:true,builder:(_)=>ProductSheet(product:product)),
  child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   Expanded(child:Container(width:double.infinity,color:Theme.of(c).colorScheme.surfaceContainerHighest,child:Icon(_icon(product.category),size:70))),
   Padding(padding:const EdgeInsets.fromLTRB(12,9,12,2),child:Text(product.name,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w800))),
   Padding(padding:const EdgeInsets.symmetric(horizontal:12),child:Row(children:[const Icon(Icons.star_rounded,size:16),Text(' ${product.rating}')])) ,
   Padding(padding:const EdgeInsets.fromLTRB(12,3,7,7),child:Row(children:[
    Text('₹${product.price.toStringAsFixed(0)}',style:const TextStyle(fontSize:17,fontWeight:FontWeight.w900)),const Spacer(),
    IconButton(onPressed:()=>c.read<CartModel>().add(product),icon:const Icon(Icons.add_shopping_cart_rounded))
   ]))
  ])));
}
IconData _icon(String c)=>switch(c){'Electronics'=>Icons.headphones_rounded,'Fashion'=>Icons.checkroom_rounded,'Home'=>Icons.home_rounded,_=>Icons.shopping_bag_rounded};

class ProductSheet extends StatelessWidget{
 final Product product;const ProductSheet({super.key,required this.product});
 @override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.fromLTRB(24,10,24,30),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
  Container(height:170,width:double.infinity,decoration:BoxDecoration(borderRadius:BorderRadius.circular(24),color:Theme.of(c).colorScheme.surfaceContainerHighest),child:Icon(_icon(product.category),size:90)),
  const SizedBox(height:18),Text(product.name,style:const TextStyle(fontSize:27,fontWeight:FontWeight.w900)),
  Text(product.category),const SizedBox(height:8),Row(children:[Text('₹${product.price.toStringAsFixed(0)}',style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900)),const SizedBox(width:12),Text('★ ${product.rating}')]),
  const SizedBox(height:10),Text(product.description),const SizedBox(height:20),
  SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:(){c.read<CartModel>().add(product);Navigator.pop(c);},icon:const Icon(Icons.shopping_cart),label:const Padding(padding:EdgeInsets.all(13),child:Text('Add to cart'))))
 ]));
}

class CartPage extends StatelessWidget{const CartPage({super.key});@override Widget build(BuildContext c){final m=c.watch<CartModel>();return ListView(padding:const EdgeInsets.all(20),children:[
 const Text('Your Cart',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),const SizedBox(height:12),
 if(m.lines.isEmpty)const Card(child:Padding(padding:EdgeInsets.all(30),child:Center(child:Text('Your cart is empty')))),
 ...m.lines.map((x)=>Card(child:ListTile(leading:CircleAvatar(child:Icon(_icon(x.product.category))),title:Text(x.product.name),subtitle:Text('₹${x.product.price.toStringAsFixed(0)} × ${x.quantity}'),trailing:Row(mainAxisSize:MainAxisSize.min,children:[
  IconButton(onPressed:()=>m.remove(x.product),icon:const Icon(Icons.remove_circle_outline)),Text('${x.quantity}'),IconButton(onPressed:()=>m.add(x.product),icon:const Icon(Icons.add_circle_outline))
 ])))),
 if(m.lines.isNotEmpty)Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(children:[
  Row(children:[const Text('Total',style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)),const Spacer(),Text('₹${m.total.toStringAsFixed(0)}',style:const TextStyle(fontWeight:FontWeight.w900,fontSize:22))]),
  const SizedBox(height:12),SizedBox(width:double.infinity,child:FilledButton(onPressed:()=>showModalBottomSheet(context:c,isScrollControlled:true,builder:(_)=>const CheckoutSheet()),child:const Text('Secure checkout')))
 ])))
];}}

class CheckoutSheet extends StatelessWidget{const CheckoutSheet({super.key});@override Widget build(BuildContext c){return Padding(padding:EdgeInsets.fromLTRB(24,24,24,24+MediaQuery.of(c).viewInsets.bottom),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
 const Text('Checkout',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900)),const SizedBox(height:15),
 const TextField(decoration:InputDecoration(labelText:'Delivery address',border:OutlineInputBorder())),const SizedBox(height:12),
 const TextField(decoration:InputDecoration(labelText:'Payment method',prefixIcon:Icon(Icons.credit_card),hintText:'Card / UPI / Wallet',border:OutlineInputBorder())),const SizedBox(height:18),
 SizedBox(width:double.infinity,child:FilledButton(onPressed:(){Navigator.pop(c);ScaffoldMessenger.of(c).showSnackBar(const SnackBar(content:Text('Checkout is ready for your payment gateway credentials.')));},child:const Padding(padding:EdgeInsets.all(13),child:Text('Place order'))))
]);}}

class OrdersPage extends StatelessWidget{const OrdersPage({super.key});@override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(20),children:[
 const Text('Orders',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),const SizedBox(height:15),
 Card(child:ListTile(leading:const Icon(Icons.local_shipping_outlined),title:const Text('No orders yet'),subtitle:const Text('Completed purchases will appear here.')))
]);}

class ProfilePage extends StatelessWidget{const ProfilePage({super.key});@override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(20),children:[
 const Text('Profile',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),const SizedBox(height:20),
 const Center(child:CircleAvatar(radius:42,child:Icon(Icons.person,size:44))),const SizedBox(height:22),
 Card(child:Column(children:[
  ListTile(onTap:()=>showModalBottomSheet(context:c,isScrollControlled:true,builder:(_)=>const AuthSheet()),leading:const Icon(Icons.login),title:const Text('Sign in / Create account'),trailing:const Icon(Icons.chevron_right)),
  const ListTile(leading:Icon(Icons.location_on_outlined),title:Text('Addresses'),trailing:Icon(Icons.chevron_right)),
  const ListTile(leading:Icon(Icons.favorite_border),title:Text('Wishlist'),trailing:Icon(Icons.chevron_right)),
  const ListTile(leading:Icon(Icons.settings_outlined),title:Text('Settings'),trailing:Icon(Icons.chevron_right)),
 ]))
]);}

class AiAssistantSheet extends StatelessWidget{const AiAssistantSheet({super.key});@override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
 const Text('AI Shopping Assistant',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900)),const SizedBox(height:8),
 const Text('Ask things like “find headphones under ₹3,000” or “what should I buy for a home office?”'),
 const SizedBox(height:16),TextField(decoration:InputDecoration(hintText:'What are you shopping for?',suffixIcon:Icon(Icons.send),border:OutlineInputBorder(borderRadius:BorderRadius.circular(16)))),
 const SizedBox(height:16),const Text('AI integration endpoint is included as the next backend extension.')
]));}

class AuthSheet extends StatefulWidget{const AuthSheet({super.key});@override State<AuthSheet> createState()=>_AuthSheetState();}
class _AuthSheetState extends State<AuthSheet>{
 final email=TextEditingController(),pass=TextEditingController(),name=TextEditingController();bool reg=false,busy=false;
 @override Widget build(BuildContext c)=>Padding(padding:EdgeInsets.fromLTRB(24,24,24,24+MediaQuery.of(c).viewInsets.bottom),child:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
  Text(reg?'Create account':'Welcome back',style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900)),const SizedBox(height:16),
  if(reg)TextField(controller:name,decoration:const InputDecoration(labelText:'Name',border:OutlineInputBorder())),if(reg)const SizedBox(height:10),
  TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Email',border:OutlineInputBorder())),const SizedBox(height:10),
  TextField(controller:pass,obscureText:true,decoration:const InputDecoration(labelText:'Password (8+ characters)',border:OutlineInputBorder())),const SizedBox(height:16),
  SizedBox(width:double.infinity,child:FilledButton(onPressed:busy?null:()async{setState(()=>busy=true);final ok=reg?await Auth.register(name.text,email.text,pass.text):await Auth.login(email.text,pass.text);if(!mounted)return;setState(()=>busy=false);ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text(ok?'Authenticated successfully':'Authentication failed')));if(ok)Navigator.pop(c);},child:Padding(padding:const EdgeInsets.all(13),child:Text(busy?'Please wait...':reg?'Create account':'Sign in')))),
  TextButton(onPressed:()=>setState(()=>reg=!reg),child:Text(reg?'Already have an account? Sign in':'New here? Create account'))
 ])));
}
