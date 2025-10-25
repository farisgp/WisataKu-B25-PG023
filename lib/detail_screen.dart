import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> destination;
  const DetailPage({super.key, required this.destination});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> recommendedNames = [];
  bool loadingRecommendations = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final destinationName = widget.destination['name'];
    try {
      final url = Uri.parse('http://localhost:5000/recommend?name=$destinationName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recommendedNames = List<String>.from(data['recommendations']);
          loadingRecommendations = false;
        });
      } else {
        print("❌ Gagal memuat rekomendasi: ${response.body}");
        setState(() => loadingRecommendations = false);
      }
    } catch (e) {
      print("⚠️ Error saat memuat rekomendasi: $e");
      setState(() => loadingRecommendations = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;
    final String name = destination["name"] ?? "Unknown";
    final String description = destination["description"] ?? "No description available.";
    final String category = destination["category"] ?? "General";
    final String location = destination["location"] ?? "Unknown City";
    final double price = destination["price"]?.toDouble() ?? 0.0;
    final double rating = destination["rating"]?.toDouble() ?? 0.0;
    final LatLng mapLocation = destination['latlng'] ?? _getDefaultLatLng(name);
    final String image =
        destination["image"] ?? "https://source.unsplash.com/400x300/?$category";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
            tag: name,
            child: Image.network(
              image,
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 4),
                          Text(location,
                              style: const TextStyle(color: Colors.grey)),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              Text(rating.toStringAsFixed(1)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text("Deskripsi",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(description,
                          style: const TextStyle(fontSize: 14, height: 1.5)),
                      const SizedBox(height: 24),
                      const Text("Lokasi di Peta",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: mapLocation,
                              initialZoom: 13,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.wisataku',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: mapLocation,
                                    width: 80,
                                    height: 80,
                                    child: const Icon(Icons.location_on,
                                        color: Colors.red, size: 40),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Harga",
                                  style: TextStyle(color: Colors.grey)),
                              Text("Rp${price.toStringAsFixed(0)} / orang",
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
                            ),
                            onPressed: () {},
                            child: const Text("Pesan Sekarang",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text("Wisata Serupa",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),

                      // === Bagian rekomendasi dari Flask ===
                      if (loadingRecommendations)
                        const Center(child: CircularProgressIndicator())
                      else if (recommendedNames.isEmpty)
                        const Text("Tidak ada rekomendasi ditemukan.")
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: recommendedNames
                              .map(
                                (name) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Text("• $name",
                                      style: const TextStyle(fontSize: 16)),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  LatLng _getDefaultLatLng(String name) {
    switch (name.toLowerCase()) {
      case 'bromo tengger semeru':
        return LatLng(-7.9425, 112.9530);
      case 'gunung andong magelang':
        return LatLng(-7.3888, 110.3319);
      case 'raja ampat':
        return LatLng(-0.2346, 130.5079);
      default:
        return LatLng(-6.2000, 106.8166);
    }
  }
}
