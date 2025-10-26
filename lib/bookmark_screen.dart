import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisataku/data/model/wisataku.dart';
import 'package:wisataku/destination_card.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Wisataku> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  /// Ambil daftar bookmark dari SharedPreferences
  Future<void> _loadBookmarks() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> saved = prefs.getStringList('bookmarks') ?? [];

  setState(() {
    bookmarks = saved.map((e) {
      final data = jsonDecode(e);

      return Wisataku(
        place_id: data['place_id'] ?? 0, // ✅ tambahkan ini
        place_name: data['name'] ?? '',
        city: data['location'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
        rating: (data['rating'] ?? 0).toDouble(),
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        coordinate: data['coordinate'] ??
            "${data['latlng']?['latitude']},${data['latlng']?['longitude']}", // ✅ tambahkan ini
        lat: (data['latlng'] != null)
            ? (data['latlng']['latitude'] ?? 0.0)
            : (data['lat'] ?? 0.0),
        long: (data['latlng'] != null)
            ? (data['latlng']['longitude'] ?? 0.0)
            : (data['long'] ?? 0.0),
      );
    }).toList();
  });
}


  /// Hapus bookmark berdasarkan nama
  Future<void> _removeBookmark(String name) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList('bookmarks') ?? [];

    saved.removeWhere((item) => jsonDecode(item)['name'] == name);
    await prefs.setStringList('bookmarks', saved);

    setState(() {
      bookmarks.removeWhere((b) => b.place_name == name);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name dihapus dari bookmark')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookmarks"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: bookmarks.isEmpty
          ? const Center(
              child: Text(
                "Belum ada bookmark",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final item = bookmarks[index];
                return GestureDetector(
                  onLongPress: () {
                    // Konfirmasi hapus
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Hapus Bookmark"),
                        content: Text(
                            "Apakah kamu yakin ingin menghapus ${item.place_name}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _removeBookmark(item.place_name);
                            },
                            child: const Text("Hapus",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DestinationCard(destination: item),
                  ),
                );
              },
            ),
    );
  }
}
