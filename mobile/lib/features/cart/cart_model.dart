import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/product.dart';
import '../../catalog.dart';

class CartLine {
  final Product product;
  int quantity;
  CartLine(this.product, this.quantity);
}

class CartModel extends ChangeNotifier {
  final List<CartLine> lines = [];
  CartModel() { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cart');
    if (raw != null) {
      try {
        final ids = Map<String, dynamic>.from(jsonDecode(raw));
        for (final entry in ids.entries) {
          final product = productsById(entry.key);
          if (product != null) {
            lines.add(CartLine(product, (entry.value as num).toInt()));
          }
        }
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode({for (final line in lines) line.product.id: line.quantity}));
  }

  void add(Product product) {
    final index = lines.indexWhere((line) => line.product.id == product.id);
    if (index < 0) {
      lines.add(CartLine(product, 1));
    } else {
      lines[index].quantity++;
    }
    notifyListeners();
    _save();
  }

  void remove(Product product) {
    final index = lines.indexWhere((line) => line.product.id == product.id);
    if (index < 0) return;
    if (lines[index].quantity > 1) {
      lines[index].quantity--;
    } else {
      lines.removeAt(index);
    }
    notifyListeners();
    _save();
  }

  double get total => lines.fold(0, (sum, line) => sum + line.product.price * line.quantity);
  int get count => lines.fold(0, (sum, line) => sum + line.quantity);
}
