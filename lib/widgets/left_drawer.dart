import 'package:flutter/material.dart';
import 'package:mustard_sports/screens/menu.dart';
import 'package:mustard_sports/screens/productform.dart';
import 'package:mustard_sports/screens/product_entry_list.dart'; 

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFFBE6),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE6B800), Color(0xFFFFC107)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_soccer, size: 48, color: Colors.black87),
                const SizedBox(height: 10),
                const Text(
                  'Mustard Sports',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Your one-stop sports shop!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Opsi Halaman Utama
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Color(0xFFE6B800)),
            title: const Text('Halaman Utama', style: TextStyle(fontWeight: FontWeight.w500)),
            onTap: () {
              // Navigasi ke Halaman Utama
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    colorScheme: Theme.of(context).colorScheme,
                  ),
                ),
              );
            },
          ),
          // Opsi Tambah Produk
          ListTile(
            leading: const Icon(Icons.add_shopping_cart, color: Color(0xFFE6B800)),
            title: const Text('Tambah Produk', style: TextStyle(fontWeight: FontWeight.w500)),
            onTap: () {
              // Navigasi ke Halaman Form
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductFormPage(),
                ),
              );
            },
          ),
          // Opsi Daftar Produk
          ListTile(
            leading: const Icon(Icons.inventory_2, color: Color(0xFFE6B800)),
            title: const Text('Daftar Produk', style: TextStyle(fontWeight: FontWeight.w500)),
            onTap: () {
              // Navigasi ke Halaman Product List (default to 'my' filter)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductEntryListPage(initialFilter: 'my'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}