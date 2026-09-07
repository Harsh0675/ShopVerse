import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

class Auth {
  static Future<bool> login(String email,String password) async {
    final r=await http.post(Uri.parse('${Api.baseUrl}/auth/login'),headers:{'Content-Type':'application/json'},body:jsonEncode({'email':email,'password':password}));
    if(r.statusCode!=200)return false;
    final j=jsonDecode(r.body);final p=await SharedPreferences.getInstance();
    await p.setString('token',j['token']);await p.setString('email',email);return true;
  }
  static Future<bool> register(String name,String email,String password) async {
    final r=await http.post(Uri.parse('${Api.baseUrl}/auth/register'),headers:{'Content-Type':'application/json'},body:jsonEncode({'name':name,'email':email,'password':password}));
    if(r.statusCode!=201)return false;
    final j=jsonDecode(r.body);final p=await SharedPreferences.getInstance();
    await p.setString('token',j['token']);await p.setString('email',email);return true;
  }
  static Future<void> logout() async {(await SharedPreferences.getInstance()).remove('token');}
  static Future<String?> token() async=>(await SharedPreferences.getInstance()).getString('token');
}