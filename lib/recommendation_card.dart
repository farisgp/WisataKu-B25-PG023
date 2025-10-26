// Widget kecil untuk rekomendasi card
import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> place;
  final VoidCallback onTap;

  const RecommendationCard({super.key, required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = place['category'] != null
        ? "https://source.unsplash.com/200x150/?${place['category']}"
        : "https://source.unsplash.com/200x150/?travel";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0,2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place['name'] ?? 'Tanpa Nama', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(place['city'] ?? 'Tidak diketahui', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(place['price'] == 0 ? "Free" : "Rp${place['price']}", style: const TextStyle(color: Colors.green, fontSize: 12)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text((place['rating'] ?? 0).toString(), style: const TextStyle(fontSize: 12)),
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
