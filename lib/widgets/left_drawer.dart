import 'package:flutter/material.dart';
import 'package:mustard_sports/screens/menu.dart';
import 'package:mustard_sports/screens/productform.dart'; 

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue, // Sesuaikan dengan tema
            ),
            child: Column(
              children: [
                Text(
                  'Mustard Sports',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Your one-stop sports shop!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          // Opsi Halaman Utama
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
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
            leading: const Icon(Icons.add_box_rounded),
            title: const Text('Tambah Produk'),
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
        ],
      ),
    );
  }
}