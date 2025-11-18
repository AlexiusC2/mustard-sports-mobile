import 'package:flutter/material.dart';
import 'package:mustard_sports/models/product_entry.dart';
import 'package:mustard_sports/widgets/left_drawer.dart';
import 'package:mustard_sports/widgets/product_entry_card.dart';
import 'package:mustard_sports/screens/product_detail.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductEntryListPage extends StatefulWidget {
  final String initialFilter;
  
  const ProductEntryListPage({super.key, this.initialFilter = 'my'});

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  late String _filter;
  
  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }
  
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
      // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
      // If you using chrome,  use URL http://localhost:8000
      
      // This endpoint returns products based on filter
      final url = _filter == 'all' 
          ? 'http://localhost:8000/json/?filter=all'
          : 'http://localhost:8000/json/';
      
      final response = await request.get(url);
      
      // Decode response to json format
      var data = response;
      
      // Convert json data to ProductEntry objects
      List<ProductEntry> listProducts = [];
      for (var d in data) {
        if (d != null) {
          listProducts.add(ProductEntry.fromJson(d));
        }
      }
      return listProducts;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBE6),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2, color: Colors.black87),
            const SizedBox(width: 8),
            const Text('Products', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFFE6B800),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onSelected: (String value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'my',
                child: Row(
                  children: [
                  Icon(
                      Icons.person,
                      color: _filter == 'my' ? const Color(0xFFE6B800) : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'My Products',
                      style: TextStyle(
                        fontWeight: _filter == 'my' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory,
                      color: _filter == 'all' ? const Color(0xFFE6B800) : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'All Products',
                      style: TextStyle(
                        fontWeight: _filter == 'all' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'There are none of your products in mustard sports yet.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => ProductEntryCard(
                product: snapshot.data![index],
                onTap: () {
                  // Navigate to product detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        product: snapshot.data![index],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
