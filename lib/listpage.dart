import 'dart:ui';
import 'package:flutter/material.dart';
import 'index.dart';
import 'shop.dart';
import 'profilepage.dart';
import 'wheat.dart';
import 'cherry.dart';
import 'lemon.dart';
import 'models/commodity_price.dart';
import 'services/api_services.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _selectedIndex = 1;
  String _searchQuery = '';
  final Future<List<CommodityPrice>> _futurePrices = ApiService.fetchPrices();

  final Map<String, String> _commodityAliases = {
    'Cauliflower': 'Cauliflower',
    'Wheat': 'Wheat',
    'Cotton': 'Cotton',
    'Tomato': 'Tomato',
    'Capsicum': 'Capsicum',
    'Pumpkin': 'Pumpkin',
    'Banana': 'Banana',
    'Carrot': 'Carrot',
    'Garlic': 'Garlic',
    'Mango': 'Mango',
    'Onion': 'Onion',
    'Mushrooms': 'Mushrooms',
    'Beans': 'Beans',
    'Brinjal': 'Brinjal',
    'Potato': 'Potato',
    'Rice': 'Rice',
    'Mustard': 'Mustard',
    'Cabbage': 'Cabbage',
    'Apple': 'Apple',
    'Pomegranate': 'Pomegranate',
    // Add more aliases here if needed
  };

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

  String _getPriceForProduct(List<CommodityPrice> prices, String productName) {
    final alias = _commodityAliases[productName] ?? productName;
    final normalizedName = alias.toLowerCase().trim();

    try {
      final exactMatch = prices.firstWhere(
            (e) => e.name.toLowerCase().trim() == normalizedName,
        orElse: () => throw Exception("No exact match"),
      );
      final adjustedPrice = (double.tryParse(exactMatch.price) ?? 0) / 100;
      return 'Rs ${adjustedPrice.toStringAsFixed(2)}/kg';
    } catch (_) {
      try {
        final partialMatch = prices.firstWhere(
              (e) => e.name.toLowerCase().contains(normalizedName),
        );
        final adjustedPrice = (double.tryParse(partialMatch.price) ?? 0) / 100;
        return 'Rs ${adjustedPrice.toStringAsFixed(2)}/kg';
      } catch (e) {
        return 'Rs 35.00/kg';
      }
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
                child: FutureBuilder<List<CommodityPrice>>(
                  future: _futurePrices,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final prices = snapshot.data ?? [];
                      final products = _filteredProducts(prices);
                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ProductCard(
                              image: product.image,
                              name: product.name,
                              family: product.family,
                              price: product.price,
                              color: const Color(0xFFDCE8D6),
                              onTap: () {
                                if (product.name.contains('Wheat')) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const WheatSeedPage()));
                                } else if (product.name.contains('Cherry')) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const CherrySeedPage()));
                                } else if (product.name.contains('Lemon')) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const LemonSeedPage()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const ShopPage()));
                                }
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }

  List<Product> _filteredProducts(List<CommodityPrice> prices) {
    final allProducts = [
      Product('assets/cauliflower.jpeg', 'Cauliflower', 'Brassica family',
          _getPriceForProduct(prices, 'Cauliflower')),
      Product('assets/wheat_og.jpeg', 'Wheat', 'Triticum family',
          _getPriceForProduct(prices, 'Wheat')),
      Product('assets/cotton.jpeg', 'Cotton', 'Gossypium family',
          _getPriceForProduct(prices, 'Cotton')),
      Product('assets/tomato.jpg', 'Tomato', 'Solanaceae family',
          _getPriceForProduct(prices, 'Tomato')),
      Product('assets/capsicum.jpg', 'Capsicum', 'Capsicum family',
          _getPriceForProduct(prices, 'Capsicum')),
      Product('assets/pumpkin.jpg', 'Pumpkin', 'Cucurbitaceae family',
          _getPriceForProduct(prices, 'Pumpkin')),
      Product('assets/banana.jpg', 'Banana', 'Musaceae family',
          _getPriceForProduct(prices, 'Banana')),
      Product('assets/carrot.jpg', 'Carrot', 'Apiaceae family',
          _getPriceForProduct(prices, 'Carrot')),
      Product('assets/garlic.jpeg', 'Garlic', 'Amaryllidaceae family',
          _getPriceForProduct(prices, 'Garlic')),
      Product('assets/mango.jpeg', 'Mango', 'Anacardiaceae family',
          _getPriceForProduct(prices, 'Mango')),
      Product('assets/onion.jpeg', 'Onion', 'Amaryllidaceae family',
          _getPriceForProduct(prices, 'Onion')),
      Product('assets/mashrooms.jpg', 'Mushrooms', 'Fungi family',
          _getPriceForProduct(prices, 'Mushrooms')),
      Product('assets/beans.jpg', 'Beans', 'Fabaceae family',
          _getPriceForProduct(prices, 'Beans')),
      Product('assets/brinjal.jpg', 'Brinjal', 'Solanaceae family',
          _getPriceForProduct(prices, 'Brinjal')),
      Product('assets/potato.jpeg', 'Potato', 'Solanaceae family',
          _getPriceForProduct(prices, 'Potato')),
      Product('assets/rice.jpeg', 'Rice', 'Oryza family',
          _getPriceForProduct(prices, 'Rice')),
      Product('assets/Mustard.jpeg', 'Mustard', 'Brassicaceae family',
          _getPriceForProduct(prices, 'Mustard')),
      Product('assets/cabbage.jpeg', 'Cabbage', 'Brassica family',
          _getPriceForProduct(prices, 'Cabbage')),
      Product('assets/apple.jpg', 'Apple', 'Rosaceae family',
          _getPriceForProduct(prices, 'Apple')),
      Product('assets/pomegranate.jpeg', 'Pomegranate', 'Lythraceae family',
          _getPriceForProduct(prices, 'Pomegranate')),
    ];

    return allProducts
        .where((product) =>
        product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
    super.key,
    required this.image,
    required this.name,
    required this.family,
    required this.price,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Image.asset(image, height: 80, width: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(family,
                      style:
                      const TextStyle(fontSize: 13, color: Colors.grey)),
                  Text(price,
                      style:
                      const TextStyle(fontSize: 13, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
