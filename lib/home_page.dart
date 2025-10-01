import 'package:flutter/material.dart';
import 'package:wisataku/detail_page.dart';
import 'package:wisataku/destination_card.dart';

class HomePage extends StatelessWidget {
  // Data dummy untuk kategori dan tempat populer
  final List<Map<String, String>> categories = [
    {'name': 'Montain', 'icon': '⛰️'},
    {'name': 'Beach', 'icon': '🏖️'},
    {'name': 'Urban', 'icon': '🏙️'},
    // Tambahkan lebih banyak
  ];

  final List<Map<String, dynamic>> popularDestinations = [
    {
      'name': 'Bromo Tengger Semeru',
      'location': 'Probolingga, East Java',
      'price': 12, // dalam K
      'distance': '14km',
      'image': 'assets/bromo.jpg'
    },
    {
      'name': 'Gunung Andong Magelang',
      'location': 'Magelang, East Java',
      'price': 9,
      'distance': '14km',
      'image': 'assets/andong.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hilangkan tombol kembali
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('9:41', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Waktu
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage('assets/profile.jpg'), // Ganti dengan path gambar profil
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Annie January', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Basic account', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.wifi, size: 18),
          SizedBox(width: 4),
          Icon(Icons.battery_full, size: 22),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Search destination...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Kategori
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Chip(
                      label: Text('${categories[index]['icon']} ${categories[index]['name']}'),
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Popular Near You Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Popular near you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('See more >', style: TextStyle(color: Colors.green))),
              ],
            ),
            const SizedBox(height: 16),

            // Daftar Destinasi Populer
            ...popularDestinations.map((destination) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DestinationCard(destination: destination),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// Widget untuk setiap kartu destinasi
