import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wisataku/detail_screen.dart';
import 'package:wisataku/data/model/wisataku.dart'; 

class DestinationCard extends StatelessWidget {
  final Wisataku destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final String imagePath = destination.category.isNotEmpty
        ? "https://source.unsplash.com/400x300/?${destination.category}"
        : "https://source.unsplash.com/400x300/?travel";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              destination: {
                'name': destination.place_name,
                'location': destination.city,
                'price': destination.price,
                'distance': '',
                'category': destination.category,
                'image': imagePath,
                // 'lat': destination.lat,
                // 'lng': destination.long,

                'description': destination.description,
                "latlng": LatLng(destination.lat, destination.long),
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.place_name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.city,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        destination.price == 0
                            ? "Free"
                            : "\$${destination.price} / person",
                        style: const TextStyle(color: Colors.green),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(destination.rating.toString()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}