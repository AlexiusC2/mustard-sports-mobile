import 'package:flutter/material.dart';
import 'package:mustard_sports/screens/menu.dart';
import 'package:mustard_sports/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Mustard Sports',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE6B800), // Mustard Yellow
            primary: const Color(0xFFE6B800),
            secondary: const Color(0xFFFFC107),
            surface: Colors.white,
            background: const Color(0xFFFFFBE6),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFE6B800),
            foregroundColor: Colors.black87,
            elevation: 2,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6B800),
              foregroundColor: Colors.black87,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const LoginPage()
      ),
    );
  }
}