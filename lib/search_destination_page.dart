// import 'package:flutter/material.dart';

// class SearchDestinationWidget extends StatefulWidget {
//   const SearchDestinationWidget({super.key});

//   @override
//   State<SearchDestinationWidget> createState() => _SearchDestinationWidgetState();
// }

// class _SearchDestinationWidgetState extends State<SearchDestinationWidget> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> allDestinations = [
//     "Borobudur Temple",
//     "Prambanan Temple",
//     "Mount Bromo",
//     "Raja Ampat",
//     "Bali Island",
//     "Lake Toba",
//   ];
//   List<String> filteredDestinations = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredDestinations = allDestinations;
//   }

//   void _filterDestinations(String query) {
//     final results = allDestinations
//         .where((destination) =>
//             destination.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     setState(() {
//       filteredDestinations = results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: TextField(
//             controller: _searchController,
//             onChanged: _filterDestinations,
//             decoration: const InputDecoration(
//               icon: Icon(Icons.search, color: Colors.grey),
//               hintText: "Search destination...",
//               border: InputBorder.none,
//             ),
//           ),
//         ),

//         const SizedBox(height: 16),

//         // 📋 Hasil pencarian
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredDestinations.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: const Icon(Icons.location_on_outlined, color: Colors.green),
//                 title: Text(filteredDestinations[index]),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
