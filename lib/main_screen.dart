import 'package:flutter/material.dart';
import 'package:wisataku/home_page.dart';
import 'package:wisataku/bookmark_screen.dart';
import '../provider/main/index_nav_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child){
          return switch (value.indexBottomNavBar) {
            0 => HomePage(),
            1 => const BookmarkScreen(),
            2 => Center(
                  child: Text(
                    "Location Page",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
            3 => Center(
                  child: Text(
                    "Profile Page",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
            _ => HomePage(), // fallback
                };
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
              onTap: (index) {
                context.read<IndexNavProvider>().setIndextBottomNavBar = index;
              },
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                  tooltip: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmarks),
                  label: "Bookmarks",
                  tooltip: "Bookmarks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.payment),
                  label: "History",
                  tooltip: "History",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: "Profile",
                  tooltip: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
