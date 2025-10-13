import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:wisataku/home_page.dart';
import 'package:wisataku/bookmark_screen.dart';
import '../provider/main/index_nav_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomBar = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showBottomBar) {
          setState(() => _showBottomBar = false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showBottomBar) {
          setState(() => _showBottomBar = true);
        }
      }
    });
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return const BookmarkScreen();
      case 2:
        return const Center(
          child: Text(
            "History Page",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      case 3:
        return const Center(
          child: Text(
            "Profile Page",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final indexProvider = context.watch<IndexNavProvider>();
    final currentIndex = indexProvider.indexBottomNavBar;

    return Scaffold(
      extendBody: true,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (_showBottomBar) setState(() => _showBottomBar = false);
          } else if (notification.direction == ScrollDirection.forward) {
            if (!_showBottomBar) setState(() => _showBottomBar = true);
          }
          return false;
        },
        child: _getSelectedPage(currentIndex),
      ),

      // 🔽 Bottom Navigation Bar
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _showBottomBar ? 70 : 0,
        curve: Curves.easeInOut,
        child: Wrap(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
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
                    currentIndex: currentIndex,
                    onTap: (index) {
                      indexProvider.setIndextBottomNavBar = index;
                    },
                    selectedItemColor: Colors.green,
                    unselectedItemColor: Colors.grey,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.bookmarks),
                        label: "Bookmarks",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.payment),
                        label: "History",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        label: "Profile",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
