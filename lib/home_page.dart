import 'package:flutter/material.dart';
import 'package:wisataku/destination_card.dart';
import 'package:wisataku/data/model/wisataku.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  String? userEmail;
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  final List<Map<String, String>> categories = [
    {'name': 'All', 'icon': '🌍'},
    {'name': 'Budaya', 'icon': '🏯'},
    {'name': 'Taman Hiburan', 'icon': '🎢'},
    {'name': 'Cagar Alam', 'icon': '🌲'},
    {'name': 'Bahari', 'icon': '🏖️'},
    {'name': 'Pusat Perbelanjaan', 'icon': '🛍️'},
    {'name': 'Tempat Ibadah', 'icon': '⛩️'},
  ];

  List<Wisataku> filteredDestinations = WisatakuList;
  String selectedCategory = 'All';

  void _filterDestinations(String query) {
    double? minPrice =
        _minPriceController.text.isEmpty ? null : double.tryParse(_minPriceController.text);
    double? maxPrice =
        _maxPriceController.text.isEmpty ? null : double.tryParse(_maxPriceController.text);

    setState(() {
      filteredDestinations = WisatakuList.where((destination) {
        final name = destination.place_name.toLowerCase();
        final city = destination.city.toLowerCase();
        final category = destination.category;
        final price = destination.price;

        final matchesSearch = city.contains(query.toLowerCase());
        final matchesCategory =
            selectedCategory == 'All' ? true : category == selectedCategory;
        final matchesPrice = (minPrice == null || price >= minPrice) &&
            (maxPrice == null || price <= maxPrice);

        return matchesSearch && matchesCategory && matchesPrice;
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
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('currentUser');
    if (userString != null) {
      final userData = jsonDecode(userString);
      setState(() {
        userName = userData['name'];
        userEmail = userData['email'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName ?? 'Guest User',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      userEmail ?? 'Not logged in',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterDestinations,
                          decoration: const InputDecoration(
                            hintText: "Cari kota wisata...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: Colors.grey),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Harga Min",
                            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onChanged: (_) => _filterDestinations(_searchController.text),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _maxPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Harga Max",
                            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          onChanged: (_) => _filterDestinations(_searchController.text),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedCategory == categories[index]['name'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        '${categories[index]['icon']} ${categories[index]['name']}',
                      ),
                      selected: isSelected,
                      selectedColor: Colors.green.shade400,
                      backgroundColor: Colors.grey[200],
                      onSelected: (_) => _selectCategory(categories[index]['name']!),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                        "Tidak ada destinasi ditemukan",
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
