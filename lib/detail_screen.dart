import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wisataku/recommendation_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> destination;
  const DetailPage({super.key, required this.destination});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> recommendedPlaces = [];
  bool loadingRecommendations = true;
  bool isBookmarked = false; 

  Future<void> _toggleBookmark(Map<String, dynamic> destination) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList('bookmarks') ?? [];

    final jsonData = jsonEncode(destination);

    if (isBookmarked) {
      saved.removeWhere((item) => jsonDecode(item)['name'] == destination['name']);
    } else {
      saved.add(jsonData);
    }

    await prefs.setStringList('bookmarks', saved);

    setState(() {
      isBookmarked = !isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isBookmarked
            ? 'Ditambahkan ke bookmark'
            : 'Dihapus dari bookmark'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  Future<void> _checkIfBookmarked() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> saved = prefs.getStringList('bookmarks') ?? [];
  final currentName = widget.destination['name'];

  final isSaved = saved.any((item) {
    final decoded = jsonDecode(item);
    return decoded['name'] == currentName;
  });

  setState(() {
    isBookmarked = isSaved;
  });
}


  @override
  void initState() {
    super.initState();
    _loadRecommendations();
    _checkIfBookmarked();
  }

  @override
  void didUpdateWidget(covariant DetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destination['name'] != widget.destination['name']) {
      _loadRecommendations();
    }
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      loadingRecommendations = true;
      recommendedPlaces = [];
    });
    final destinationName = widget.destination['name'];
    try {
      final url = Uri.parse(
          'http://192.168.1.7:5000/recommend?name=$destinationName'); // ubah sesuai IP server Flask-mu
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recommendedPlaces =
              List<Map<String, dynamic>>.from(data['recommendations']);
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
    final String description =
        destination["description"] ?? "No description available.";
    final String category = destination["category"] ?? "General";
    final String location = destination["location"] ?? "Unknown City";
    final double price = destination["price"]?.toDouble() ?? 0.0;
    final double rating = destination["rating"]?.toDouble() ?? 0.0;
    final LatLng mapLocation =
        destination['latlng'] ?? _getDefaultLatLng(name);
    final String image = destination["category"].isNotEmpty
        ? "https://source.unsplash.com/400x300/?${destination["category"]}"
        : "https://source.unsplash.com/400x300/?travel";

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
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          // ✅ Tambahkan bar atas dengan tombol back & bookmark
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.yellow : Colors.white,
                      ),
                      onPressed: () => _toggleBookmark(widget.destination),
                    ),
                  ),
                ],
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
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: mapLocation,
                                  initialZoom: 13,
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.none, 
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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

                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    final Uri googleMapsUri = Uri.parse(
                                      'https://www.google.com/maps/search/?api=1&query=${mapLocation.latitude},${mapLocation.longitude}',
                                    );

                                    final bool launched = await launchUrl(
                                      googleMapsUri,
                                      mode: LaunchMode.externalApplication,
                                    );

                                    if (!launched) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Gagal membuka Google Maps'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.map, color: Colors.green, size: 18),
                                          SizedBox(width: 4),
                                          Text(
                                            'Buka di Google Maps',
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                      if (loadingRecommendations)
                        const Center(child: CircularProgressIndicator())
                      else if (recommendedPlaces.isEmpty)
                        const Text("Tidak ada rekomendasi ditemukan.")
                      else
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedPlaces.length,
                            itemBuilder: (context, index) {
                              final place = recommendedPlaces[index];
                              return RecommendationCard(
                                place: place,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        key: ValueKey(place['name']),
                                        destination: {
                                          'name': place['name'],
                                          'location': place['city'],
                                          'price': place['price'],
                                          'rating': place['rating'],
                                          'category': place['category'],
                                          'description': place['description'],
                                          'latlng': LatLng(
                                              place['lat'], place['long']),
                                          'image': place['category'] != null
                                              ? "https://source.unsplash.com/400x300/?${place['category']}"
                                              : "https://source.unsplash.com/400x300/?travel",
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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
