import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mustard_sports/widgets/left_drawer.dart';
import 'package:mustard_sports/screens/menu.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  String _description = "";
  String _thumbnail = "";
  String _category = "lainnya"; // Nilai default untuk dropdown (sesuai daftar baru)
  bool _isFeatured = false; // Nilai default untuk switch
  // Daftar kategori: value (internal) dan label (tampilan)
  final List<MapEntry<String, String>> _categories = [
    MapEntry('jersey', 'Jersey'),
    MapEntry('sepatu', 'Sepatu'),
    MapEntry('celana', 'Celana'),
    MapEntry('joggers', 'Joggers'),
    MapEntry('kaus kaki', 'Kaus Kaki'),
    MapEntry('bola', 'Bola'),
    MapEntry('lainnya', 'Lainnya'),
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBE6),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_shopping_cart, color: Colors.black87),
            const SizedBox(width: 8),
            const Text(
              'Add New Product',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE6B800),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      // Tambahkan drawer yang sama di sini
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Bungkus dengan SingleChildScrollView agar bisa di-scroll
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Product Name",
                      labelText: "Product Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _name = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty!";
                      }
                      return null;
                    },
                  ),
                ),

                // Input Price
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Price",
                      labelText: "Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _price = int.tryParse(value!) ?? 0;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Price cannot be empty!";
                      }
                      if (int.tryParse(value) == null) {
                        return "Price must be a number!";
                      }
                      if (int.parse(value) <= 0) {
                        return "Price must be greater than zero!";
                      }
                      return null;
                    },
                  ),
                ),

                // Input Description
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Description",
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _description = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Description cannot be empty!";
                      }
                      return null;
                    },
                  ),
                ),

                // Input Thumbnail (Opsional, tanpa validator)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Thumbnail URL (Optional)",
                      labelText: "Thumbnail URL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _thumbnail = value!;
                      });
                    },
                    // Tidak ada validator, jadi boleh kosong
                  ),
                ),

                // Input Category (Dropdown)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    initialValue: _category,
                    items: _categories
                        .map((entry) => DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                  ),
                ),

                // Input Is Featured (Switch)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SwitchListTile(
                    title: const Text("Mark as Featured Product"),
                    value: _isFeatured,
                    onChanged: (bool value) {
                      setState(() {
                        _isFeatured = value;
                      });
                    },
                  ),
                ),

                // Tombol Save
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6B800),
                        foregroundColor: Colors.black87,
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Replace the URL with your app's URL
                          // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                          // If you using chrome,  use URL http://localhost:8000
                          
                          try {
                            print('Sending data: name=$_name, price=$_price, category=$_category');
                            final response = await request.postJson(
                              "http://localhost:8000/create-flutter/",
                              jsonEncode({
                                "name": _name,
                                "price": _price,
                                "description": _description,
                                "thumbnail": _thumbnail,
                                "category": _category,
                                "is_featured": _isFeatured,
                              }),
                            );
                            print('Response received: $response');
                            if (context.mounted) {
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Product successfully saved!"),
                                ));
                                // Reset form
                                _formKey.currentState!.reset();
                                setState(() {
                                  _name = "";
                                  _price = 0;
                                  _description = "";
                                  _thumbnail = "";
                                  _category = "lainnya";
                                  _isFeatured = false;
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                        colorScheme: Theme.of(context).colorScheme,
                                      )),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Failed: ${response['message'] ?? 'Unknown error'}"),
                                ));
                              }
                            }
                          } catch (e) {
                            print('Error caught: $e');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Error: $e"),
                              ));
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}