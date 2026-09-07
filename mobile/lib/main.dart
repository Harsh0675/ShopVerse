import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'catalog.dart';
import 'core/product.dart';
import 'features/cart/cart_model.dart';

void main() => runApp(ChangeNotifierProvider(create: (_) => CartModel(), child: const ShopVerse()));

class ShopVerse extends StatelessWidget {
  const ShopVerse({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ShopVerse',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xff5b4bff)),
    darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xff8b7cff), brightness: Brightness.dark),
    themeMode: ThemeMode.system,
    home: const ShopHome(),
  );
}

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});
  @override State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  String category = 'All';
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) => category == 'All' || p.category == category).toList();
    final pages = [
      _ShopPage(products: filtered, category: category, onCategory: (v) => setState(() => category = v)),
      const _CartPage(), const _OrdersPage(), const _ProfilePage(),
    ];
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _ShopPage extends StatelessWidget {
  final List<Product> products; final String category; final ValueChanged<String> onCategory;
  const _ShopPage({required this.products, required this.category, required this.onCategory});
  @override
  Widget build(BuildContext context) => CustomScrollView(slivers: [
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20,20,20,10), child: Row(children: [
      const Expanded(child: Text('ShopVerse', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900))),
      IconButton(onPressed: () => showSearch(context: context, delegate: _ProductSearch()), icon: const Icon(Icons.search)),
      IconButton(onPressed: () => showModalBottomSheet(context: context, builder: (_) => const _AiSheet()), icon: const Icon(Icons.auto_awesome)),
    ]))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal:20,vertical:8), child: Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(28)),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Smart shopping', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        SizedBox(height: 6), Text('Discover products for your next purchase.'),
      ]),
    ))),
    SliverToBoxAdapter(child: SizedBox(height:58, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:16), children: [
      for (final x in ['All','Electronics','Fashion','Home']) Padding(padding: const EdgeInsets.only(right:8), child: ChoiceChip(label: Text(x), selected: category == x, onSelected: (_) => onCategory(x))),
    ]))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20,8,20,14), child: Text('${products.length} products', style: const TextStyle(fontSize:20,fontWeight:FontWeight.bold)))),
    SliverPadding(padding: const EdgeInsets.symmetric(horizontal:16), sliver: SliverGrid(
      delegate: SliverChildBuilderDelegate((_, i) => _ProductCard(product: products[i]), childCount: products.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, childAspectRatio:.68, crossAxisSpacing:12, mainAxisSpacing:12),
    )),
    const SliverToBoxAdapter(child: SizedBox(height:20)),
  ]);
}

class _ProductSearch extends SearchDelegate<Product?> {
  @override List<Widget>? buildActions(BuildContext context) => [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  @override Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));
  @override Widget buildResults(BuildContext context) => _results(context);
  @override Widget buildSuggestions(BuildContext context) => _results(context);
  Widget _results(BuildContext context) => ListView(children: products.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).map((p) => ListTile(
    leading: const CircleAvatar(child: Icon(Icons.shopping_bag)), title: Text(p.name), subtitle: Text('₹${p.price.toStringAsFixed(0)}'), onTap: () => close(context, p),
  )).toList());
}

class _ProductCard extends StatelessWidget {
  final Product product; const _ProductCard({required this.product});
  @override
  Widget build(BuildContext context) => Card(clipBehavior: Clip.antiAlias, elevation: 0, child: InkWell(
    onTap: () => showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => _ProductSheet(product: product)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Container(width: double.infinity, color: Theme.of(context).colorScheme.surfaceContainerHighest, child: Icon(_icon(product.category), size:70))),
      Padding(padding: const EdgeInsets.fromLTRB(12,9,12,2), child: Text(product.name, maxLines:2, overflow:TextOverflow.ellipsis, style: const TextStyle(fontWeight:FontWeight.w800))),
      Padding(padding: const EdgeInsets.symmetric(horizontal:12), child: Text('★ ${product.rating}')),
      Padding(padding: const EdgeInsets.fromLTRB(12,3,7,7), child: Row(children: [
        Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize:17,fontWeight:FontWeight.w900)), const Spacer(),
        IconButton(onPressed: () => context.read<CartModel>().add(product), icon: const Icon(Icons.add_shopping_cart_rounded)),
      ])),
    ]),
  ));
}

class _ProductSheet extends StatelessWidget {
  final Product product; const _ProductSheet({required this.product});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(24,10,24,30), child: Column(mainAxisSize:MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start, children: [
    Container(height:170, width:double.infinity, decoration: BoxDecoration(borderRadius:BorderRadius.circular(24), color:Theme.of(context).colorScheme.surfaceContainerHighest), child:Icon(_icon(product.category),size:90)),
    const SizedBox(height:18), Text(product.name, style: const TextStyle(fontSize:27,fontWeight:FontWeight.w900)), Text(product.category),
    const SizedBox(height:8), Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize:24,fontWeight:FontWeight.w900)),
    const SizedBox(height:10), Text(product.description), const SizedBox(height:20),
    SizedBox(width:double.infinity, child: FilledButton.icon(onPressed: () { context.read<CartModel>().add(product); Navigator.pop(context); }, icon: const Icon(Icons.shopping_cart), label: const Padding(padding:EdgeInsets.all(13), child:Text('Add to cart')))),
  ]));
}

class _CartPage extends StatelessWidget {
  const _CartPage();
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Your Cart', style: TextStyle(fontSize:30,fontWeight:FontWeight.w900)), const SizedBox(height:12),
      if (cart.lines.isEmpty) const Card(child: Padding(padding:EdgeInsets.all(30), child:Center(child:Text('Your cart is empty')))),
      ...cart.lines.map((line) => Card(child:ListTile(
        leading: CircleAvatar(child:Icon(_icon(line.product.category))), title:Text(line.product.name), subtitle:Text('₹${line.product.price.toStringAsFixed(0)} × ${line.quantity}'),
        trailing: Row(mainAxisSize:MainAxisSize.min, children: [IconButton(onPressed:()=>cart.remove(line.product), icon:const Icon(Icons.remove_circle_outline)), Text('${line.quantity}'), IconButton(onPressed:()=>cart.add(line.product), icon:const Icon(Icons.add_circle_outline))]),
      ))),
      if (cart.lines.isNotEmpty) Card(child:Padding(padding:const EdgeInsets.all(18), child:Column(children: [
        Row(children: [const Text('Total', style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)), const Spacer(), Text('₹${cart.total.toStringAsFixed(0)}', style:const TextStyle(fontWeight:FontWeight.w900,fontSize:22))]),
        const SizedBox(height:12), SizedBox(width:double.infinity, child:FilledButton(onPressed:()=>showModalBottomSheet(context:context,isScrollControlled:true,builder:(_)=>const _CheckoutSheet()), child:const Text('Secure checkout'))),
      ]))),
    ];
  }
}

class _CheckoutSheet extends StatelessWidget {
  const _CheckoutSheet();
  @override
  Widget build(BuildContext context) => Padding(padding:EdgeInsets.fromLTRB(24,24,24,24+MediaQuery.of(context).viewInsets.bottom), child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
    const Text('Checkout',style:TextStyle(fontSize:28,fontWeight:FontWeight.w900)), const SizedBox(height:15),
    const TextField(decoration:InputDecoration(labelText:'Delivery address',border:OutlineInputBorder())), const SizedBox(height:12),
    const TextField(decoration:InputDecoration(labelText:'Payment method',hintText:'Card / UPI / Wallet',border:OutlineInputBorder())), const SizedBox(height:18),
    SizedBox(width:double.infinity,child:FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('Place order'))),
  ]));
}

class _OrdersPage extends StatelessWidget { const _OrdersPage(); @override Widget build(BuildContext context) => const Center(child:Text('No orders yet')); }
class _ProfilePage extends StatelessWidget { const _ProfilePage(); @override Widget build(BuildContext context) => ListView(padding:const EdgeInsets.all(20),children:const [
  Text('Profile',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)), SizedBox(height:20), Center(child:CircleAvatar(radius:42,child:Icon(Icons.person,size:44))), SizedBox(height:22),
  Card(child:Column(children:[ListTile(leading:Icon(Icons.login),title:Text('Sign in / Create account'),trailing:Icon(Icons.chevron_right)),ListTile(leading:Icon(Icons.location_on_outlined),title:Text('Addresses'),trailing:Icon(Icons.chevron_right)),ListTile(leading:Icon(Icons.favorite_border),title:Text('Wishlist'),trailing:Icon(Icons.chevron_right)),ListTile(leading:Icon(Icons.settings_outlined),title:Text('Settings'),trailing:Icon(Icons.chevron_right))]))
]); }
class _AiSheet extends StatelessWidget { const _AiSheet(); @override Widget build(BuildContext context) => const Padding(padding:EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text('AI Shopping Assistant',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900)),SizedBox(height:8),Text('Ask for product recommendations, comparisons, or budget-friendly options.'),SizedBox(height:16),TextField(decoration:InputDecoration(hintText:'What are you shopping for?',border:OutlineInputBorder()))])); }

IconData _icon(String category) => switch (category) {'Electronics'=>Icons.headphones_rounded,'Fashion'=>Icons.checkroom_rounded,'Home'=>Icons.home_rounded,_=>Icons.shopping_bag_rounded};
