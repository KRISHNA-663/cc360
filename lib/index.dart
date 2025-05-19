import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_services.dart'; // Your API service file
import 'models/commodity_price.dart';
import 'listpage.dart';
import 'shop.dart';
import 'profilepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _userName = '';
  bool _isLoading = true;

  // Initialize _futurePrices immediately to avoid LateInitializationError
  late Future<List<CommodityPrice>> _futurePrices = ApiService.fetchPrices();

  @override
  void initState() {
    super.initState();
    fetchUserName();
    // _futurePrices is already initialized above
  }

  Future<void> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _userName = data['name'] ?? 'User';
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ListPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }

  // ✔️ Improved version for better matching
  String _getPriceForProduct(List<CommodityPrice> prices, String productName) {
    try {
      final commodity = prices.firstWhere(
            (element) =>
            element.name.toLowerCase().contains(productName.toLowerCase()),
      );
      return 'Rs ${commodity.price}/kg';
    } catch (e) {
      return 'Price N/A';
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isLoading ? 'Loading...' : 'Welcome, $_userName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '🌱 Find the best products for your needs',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ListPage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('assets/grass_border.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      child: const Text(
                        'Get My Product',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopPage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('assets/grass_border.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shopping_cart, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'Shop',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: const [
                      Icon(Icons.category_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Available Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<CommodityPrice>>(
                    future: _futurePrices,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available'));
                      } else {
                        final prices = snapshot.data!;
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          children: [
                            ProductCard(name: 'Cauliflower', price: _getPriceForProduct(prices, 'Cauliflower'), imagePath: 'assets/cauliflower.jpeg'),
                            ProductCard(name: 'Wheat', price: _getPriceForProduct(prices, 'wheat'), imagePath: 'assets/wheat_og.jpeg'),
                            ProductCard(name: 'Cotton', price: _getPriceForProduct(prices, 'cotton'), imagePath: 'assets/cotton.jpeg'),
                            ProductCard(name: 'Tomato', price: _getPriceForProduct(prices, 'Tomato'), imagePath: 'assets/tomato.jpg'),
                            ProductCard(name: 'Capsicum', price: _getPriceForProduct(prices, 'Capsicum'), imagePath: 'assets/capsicum.jpg'),
                            ProductCard(name: 'Pumpkin', price: _getPriceForProduct(prices, 'Pumpkin'), imagePath: 'assets/pumpkin.jpg'),
                            ProductCard(name: 'Banana', price: _getPriceForProduct(prices, 'Banana'), imagePath: 'assets/banana.jpg'),
                            ProductCard(name: 'Carrot', price: _getPriceForProduct(prices, 'Carrot'), imagePath: 'assets/carrot.jpg'),
                            ProductCard(name: 'Garlic', price: _getPriceForProduct(prices, 'Garlic'), imagePath: 'assets/garlic.jpeg'),
                            ProductCard(name: 'Mango', price: _getPriceForProduct(prices, 'Mango'), imagePath: 'assets/mango.jpeg'),
                            ProductCard(name: 'Onion', price: _getPriceForProduct(prices, 'Onion'), imagePath: 'assets/onion.jpeg'),
                            ProductCard(name: 'Mushrooms', price: _getPriceForProduct(prices, 'Mushrooms'), imagePath: 'assets/mashrooms.jpg'),
                            ProductCard(name: 'Beans', price: _getPriceForProduct(prices, 'Beans'), imagePath: 'assets/beans.jpg'),
                            ProductCard(name: 'Brinjal', price: _getPriceForProduct(prices, 'Brinjal'), imagePath: 'assets/brinjal.jpg'),
                            ProductCard(name: 'Potato', price: _getPriceForProduct(prices, 'Potato'), imagePath: 'assets/potato.jpeg'),
                            ProductCard(name: 'Rice', price: _getPriceForProduct(prices, 'Rice'), imagePath: 'assets/rice.jpeg'),
                            ProductCard(name: 'Mustard', price: _getPriceForProduct(prices, 'Mustard'), imagePath: 'assets/Mustard.jpeg'),
                            ProductCard(name: 'Cabbage', price: _getPriceForProduct(prices, 'cabbage'), imagePath: 'assets/cabbage.jpeg'),
                            ProductCard(name: 'Apple', price: _getPriceForProduct(prices, 'Apple'), imagePath: 'assets/apple.jpg'),
                            ProductCard(name: 'Pomegranate', price: _getPriceForProduct(prices, 'Pomegranate'), imagePath: 'assets/pomegranate.jpeg'),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
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
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopPage())),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, spreadRadius: 2, offset: const Offset(2, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                imagePath,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(price, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}