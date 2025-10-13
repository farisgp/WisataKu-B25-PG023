import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> destination;

  const DetailPage({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final String imagePath = destination['image'];
    final String name = destination['name'];
    final String location = destination['location'];
    final int price = destination['price'];
    final String distance = destination['distance'];
    final String description = destination['description'] ??
        "Experience the beauty of $name, located in $location. "
        "This destination offers breathtaking views, great atmosphere, and unforgettable experiences.";

    final LatLng mapLocation =
        destination['latlng'] ?? _getDefaultLatLng(name);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
            tag: name,
            child: Image.network(
              imagePath,
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 120, color: Colors.grey),
              ),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(Icons.favorite_border, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 4),
                          Text(location,
                              style: const TextStyle(color: Colors.grey)),
                          const Spacer(),
                          Text(distance,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Description",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87, height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Map Location",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
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
                              onTap: (_, __) => _openMap(context, mapLocation.latitude, mapLocation.longitude),

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
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Price",
                                  style: TextStyle(color: Colors.grey)),
                              Text(
                                "\$$price / person",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Booking successful for $name!"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: const Text(
                              "Book Now",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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

  Future<void> _openMap(BuildContext context, double lat, double lng) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          "Apakah Anda ingin membuka lokasi ini di Google Maps?",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);

              final Uri url = Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=$lat,$lng');

              try {
                final bool launched = await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );

                if (!launched) {
                  debugPrint('❌ Tidak dapat membuka Google Maps.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak dapat membuka Google Maps'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                debugPrint('⚠️ Error membuka peta: $e');
              }
            },
            icon: const Icon(Icons.map, color: Colors.white),
            label: const Text(
              "Buka di Google Maps",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}


}
