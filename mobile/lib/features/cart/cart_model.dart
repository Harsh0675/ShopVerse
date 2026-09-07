import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/product.dart';

class CartLine { final Product product; int quantity; CartLine(this.product,this.quantity); }

class CartModel extends ChangeNotifier {
 final List<CartLine> lines=[];
 CartModel(){_load();}
 Future<void> _load() async {
  final p=await SharedPreferences.getInstance(); final raw=p.getString('cart');
  if(raw!=null){try{final ids=Map<String,dynamic>.from(jsonDecode(raw));for(final e in ids.entries){final x=productsById(e.key);if(x!=null)lines.add(CartLine(x,(e.value as num).toInt()));}}catch(_) {}}
  notifyListeners();
 }
 Future<void> _save() async {final p=await SharedPreferences.getInstance();await p.setString('cart',jsonEncode({for(final x in lines)x.product.id:x.quantity}));}
 void add(Product p){final i=lines.indexWhere((x)=>x.product.id==p.id);if(i<0)lines.add(CartLine(p,1));else lines[i].quantity++;notifyListeners();_save();}
 void remove(Product p){final i=lines.indexWhere((x)=>x.product.id==p.id);if(i<0)return;if(lines[i].quantity>1)lines[i].quantity--;else lines.removeAt(i);notifyListeners();_save();}
 double get total=>lines.fold(0,(s,x)=>s+x.product.price*x.quantity);
 int get count=>lines.fold(0,(s,x)=>s+x.quantity);
}
Product? productsById(String id){try{return products.firstWhere((x)=>x.id==id);}catch(_){return null;}}
