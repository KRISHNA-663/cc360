import 'dart:ui';
import 'package:flutter/material.dart';
import 'index.dart';
import 'shop.dart';
import 'profilepage.dart';
import 'wheat.dart';
import 'cherry.dart';
import 'lemon.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _selectedIndex = 1;
  String _searchQuery = '';

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShopPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFF055B1D),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Product List',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/grass.jpg', fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search product name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: _filteredProducts()
                      .map((product) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ProductCard(
                      image: product.image,
                      name: product.name,
                      family: product.family,
                      price: product.price,
                      color: const Color(0xFFDCE8D6),
                      onTap: () {
                        if (product.name.contains('Wheat')) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const WheatSeedPage()));
                        } else if (product.name.contains('Cherry')) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const CherrySeedPage()));
                        } else if (product.name.contains('Lemon')) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const LemonSeedPage()));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const ShopPage()));
                        }
                      },
                    ),
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF055B1D),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shop'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  List<Product> _filteredProducts() {
    List<Product> allProducts = [
      Product('assets/cauliflower.jpeg', 'Cauliflower', 'Brassica family', 'Rs 10/Kg'),
      Product('assets/wheat_og.jpeg', 'Wheat', 'Triticum family', 'Rs 10/Kg'),
      Product('assets/cotton.jpeg', 'Cotton', 'Gossypium family', 'Rs 10/Kg'),
      Product('assets/tomato.jpg', 'Tomato', 'Solanaceae family', 'Rs 10/Kg'),
      Product('assets/capsicum.jpg', 'Capsicum', 'Capsicum family', 'Rs 10/Kg'),
      Product('assets/pumpkin.jpg', 'Pumpkin', 'Cucurbitaceae family', 'Rs 10/Kg'),
      Product('assets/banana.jpg', 'Banana', 'Musaceae family', 'Rs 10/Kg'),
      Product('assets/carrot.jpg', 'Carrot', 'Apiaceae family', 'Rs 10/Kg'),
      Product('assets/garlic.jpeg', 'Garlic', 'Amaryllidaceae family', 'Rs 10/Kg'),
      Product('assets/mango.jpeg', 'Mango', 'Anacardiaceae family', 'Rs 10/Kg'),
      Product('assets/onion.jpeg', 'Onion', 'Amaryllidaceae family', 'Rs 10/Kg'),
      Product('assets/mashrooms.jpg', 'Mushrooms', 'Fungi family', 'Rs 10/Kg'),
      Product('assets/beans.jpg', 'Beans', 'Fabaceae family', 'Rs 10/Kg'),
      Product('assets/brinjal.jpg', 'Brinjal', 'Solanaceae family', 'Rs 10/Kg'),
      Product('assets/potato.jpeg', 'Potato', 'Solanaceae family', 'Rs 10/Kg'),
      Product('assets/rice.jpeg', 'Rice', 'Oryza family', 'Rs 10/Kg'),
      Product('assets/Mustard.jpeg', 'Mustard', 'Brassicaceae family', 'Rs 10/Kg'),
      Product('assets/cabbage.jpeg', 'Cabbage', 'Brassicaceae family', 'Rs 10/Kg'),
      Product('assets/apple.jpg', 'Apple', 'Rosaceae family', 'Rs 10/Kg'),
      Product('assets/pomegranate.jpeg', 'Pomegranate', 'Lythraceae family', 'Rs 10/Kg'),
    ];

    return allProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
}

class Product {
  final String image;
  final String name;
  final String family;
  final String price;

  Product(this.image, this.name, this.family, this.price);
}

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String family;
  final String price;
  final Color color;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.image,
    required this.name,
    required this.family,
    required this.price,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
              child: Image.asset(
                image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Image Not Found')),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      family,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
