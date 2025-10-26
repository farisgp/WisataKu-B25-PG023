import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  /// 🔹 Simpan user baru
  static Future<bool> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil daftar user dari SharedPreferences (kalau belum ada, pakai list kosong)
    List<String> users = prefs.getStringList('users') ?? [];

    // Cek apakah email sudah terdaftar
    bool emailExists = users.any((user) {
      final decoded = jsonDecode(user);
      return decoded['email'] == email;
    });

    if (emailExists) {
      return false; // Email sudah ada
    }

    // Simpan user baru
    final newUser = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });

    users.add(newUser);
    await prefs.setStringList('users', users);
    return true;
  }

  /// 🔹 Login user
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];

    for (var user in users) {
      final decoded = jsonDecode(user);
      if (decoded['email'] == email && decoded['password'] == password) {
        // Simpan status login
        await prefs.setString('currentUser', user);
        return true;
      }
    }

    return false;
  }

  /// 🔹 Ambil user yang sedang login
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('currentUser');
    if (user == null) return null;
    return jsonDecode(user);
  }

  /// 🔹 Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }

//   static Future<Map<String, dynamic>?> getCurrentUser() async {
//   final prefs = await SharedPreferences.getInstance();
//   final userString = prefs.getString('currentUser');
//   if (userString == null) return null;
//   return Map<String, dynamic>.from(jsonDecode(userString));
// }

  static Future<bool> updatePassword(String email, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString('users');
    if (usersString == null) return false;

    final List<dynamic> users = jsonDecode(usersString);
    final index = users.indexWhere((u) => u['email'] == email);
    if (index == -1) return false;

    // Update password di list dan current user
    users[index]['password'] = newPassword;
    await prefs.setString('users', jsonEncode(users));

    final currentUser = users[index];
    await prefs.setString('currentUser', jsonEncode(currentUser));
    return true;
  }

}
