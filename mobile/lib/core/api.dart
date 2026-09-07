import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'product.dart';

class Api {
  static const baseUrl=AppConfig.apiBaseUrl;
  static Future<List<Product>> products([String q='']) async {
    final r=await http.get(Uri.parse('$baseUrl/products?q=${Uri.encodeQueryComponent(q)}'));
    if(r.statusCode!=200) throw Exception('Failed to load products');
    return (jsonDecode(r.body) as List).map((x)=>Product.fromJson(x)).toList();
  }
  static Future<Map<String,dynamic>> recommend(String prompt) async {
    final r=await http.post(Uri.parse('$baseUrl/ai/recommend'),headers:{'Content-Type':'application/json'},body:jsonEncode({'prompt':prompt}));
    if(r.statusCode!=200) throw Exception('Recommendation failed'); return jsonDecode(r.body);
  }
  static Future<Map<String,dynamic>> validateCoupon(String code) async {
    final r=await http.post(Uri.parse('$baseUrl/coupons/validate'),headers:{'Content-Type':'application/json'},body:jsonEncode({'code':code}));
    if(r.statusCode!=200) throw Exception('Coupon validation failed'); return jsonDecode(r.body);
  }
}
