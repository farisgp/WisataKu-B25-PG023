final List<Map<String, String>> dummyUsers = [
  {
    "email": "admin@wisata.com",
    "password": "admin123",
    "name": "Admin Wisata"
  },
  {
    "email": "user@wisata.com",
    "password": "user123",
    "name": "User Wisata"
  },
];

class AuthService {
  static Map<String, String>? login(String email, String password) {
    try {
      final user = dummyUsers.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  static bool register(String name, String email, String password) {
    final exists = dummyUsers.any((u) => u['email'] == email);
    if (exists) return false;

    dummyUsers.add({
      "name": name,
      "email": email,
      "password": password,
    });
    return true;
  }
}
