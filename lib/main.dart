import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisataku/main_screen.dart';
import 'package:wisataku/onboarding_page.dart';
import 'package:wisataku/provider/main/index_nav_provider.dart';
import 'package:wisataku/static/navigation_route.dart';
import 'package:wisataku/login_page.dart';
// import 'package:wisataku/home_page.dart'; // nanti bisa ditambahkan
// import 'package:wisataku/detail_page.dart'; // nanti bisa ditambahkan

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IndexNavProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WisataKu",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      initialRoute: NavigationRoute.onboardingRoute.name,
      routes: {
        NavigationRoute.onboardingRoute.name: (context) => const OnboardingPage(),
        NavigationRoute.loginRoute.name: (context) => const LoginPage(),
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
      },
    );
  }
}
