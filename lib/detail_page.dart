import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Map<String, String> trip;

  const DetailPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    // contoh koordinat Bromo
    const double lat = -7.9425;
    const double lng = 112.9530;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Image.network(
                trip["image"]!,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip["title"]!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${trip["location"]} • ${trip["distance"]}",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Chip(
                          label: const Text("Max 12 Group Size"),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: const Text("4 Day Trip Duration"),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Description",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Bromo Tengger Semeru National Park, located in East Java, "
                      "features active volcanoes, rugged landscapes, and the iconic Mount Bromo. "
                      "It's a popular destination for hiking, sunrise views, and stunning volcanic scenery.",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // ===== Map Section (Card) =====
                    const Text(
                      "Location",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // Gambar dari assets (selalu tampil)
                          Image.asset(
                            "assets/map_demo.png",
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          ListTile(
                            leading: const Icon(Icons.map),
                            title: Text(trip["location"] ?? "Unknown"),
                            trailing: TextButton(
                              onPressed: () async {
                                final Uri url = Uri.parse(
                                  "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: const Text("Open on Maps"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
          // Booking Button
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {},
              child: const Text("Booking"),
            ),
          ),
          // Back Button
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
