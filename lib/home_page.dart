import 'package:flutter/material.dart';
import 'package:wisataku/destination_card.dart';
import 'package:wisataku/data/model/wisataku.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> categories = [
    {'name': 'All', 'icon': '🌍'},
    {'name': 'Budaya', 'icon': '🏯'},
    {'name': 'Alam', 'icon': '⛰️'},
    {'name': 'Pantai', 'icon': '🏖️'},
  ];

  List<Wisataku> filteredDestinations = WisatakuList;
  String selectedCategory = 'All';

  void _filterDestinations(String query) {
    setState(() {
      filteredDestinations = WisatakuList.where((destination) {
        final name = destination.place_name.toLowerCase();
        final category = destination.category;
        final matchesSearch = name.contains(query.toLowerCase());
        final matchesCategory =
            selectedCategory == 'All' ? true : category == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      _filterDestinations(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Annie January',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Basic account',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
              child: TextField(
                controller: _searchController,
                onChanged: _filterDestinations,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search destination...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected =
                      selectedCategory == categories[index]['name'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        '${categories[index]['icon']} ${categories[index]['name']}',
                      ),
                      selected: isSelected,
                      selectedColor: Colors.green.shade400,
                      backgroundColor: Colors.grey[200],
                      onSelected: (_) =>
                          _selectCategory(categories[index]['name']!),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: filteredDestinations.isEmpty
                  ? const Center(
                      child: Text(
                        "No destinations found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredDestinations.length,
                      itemBuilder: (context, index) {
                        final destination = filteredDestinations[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: DestinationCard(destination: destination),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
