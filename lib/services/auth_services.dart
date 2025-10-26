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

    // Ambil daftar user (disimpan sebagai List<String>)
    List<String> users = prefs.getStringList('users') ?? [];

    bool updated = false;

    // Decode tiap user dan cari berdasarkan email
    List<Map<String, dynamic>> userList = users
        .map((u) => Map<String, dynamic>.from(jsonDecode(u)))
        .toList();

    for (var user in userList) {
      if (user['email'] == email) {
        user['password'] = newPassword;
        updated = true;
        break;
      }
    }

    if (!updated) return false;

    // Simpan ulang daftar user ke SharedPreferences
    List<String> updatedUsers =
        userList.map((u) => jsonEncode(u)).toList();
    await prefs.setStringList('users', updatedUsers);

    // Perbarui juga current user
    final currentUser =
        userList.firstWhere((u) => u['email'] == email);
    await prefs.setString('currentUser', jsonEncode(currentUser));

    return true;
  }

}
