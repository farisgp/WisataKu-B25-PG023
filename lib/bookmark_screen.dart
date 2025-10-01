import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data bookmarks
    final List<Map<String, String>> bookmarks = [
      {
        "title": "Mount Bromo",
        "location": "Probolinggo, East Java",
        "image": "https://source.unsplash.com/600x400/?mountain"
      },
      {
        "title": "Raja Ampat",
        "location": "West Papua",
        "image": "https://source.unsplash.com/600x400/?beach,sea"
      },
      {
        "title": "Borobudur Temple",
        "location": "Magelang, Central Java",
        "image": "https://source.unsplash.com/600x400/?temple,borobudur"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookmarks"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: bookmarks.isEmpty
          ? const Center(
              child: Text(
                "No bookmarks yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final item = bookmarks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  child: Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.network(
                          item["image"]!,
                          width: 120,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"]!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item["location"]!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${item["title"]} removed")),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
