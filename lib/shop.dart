import 'package:flutter/material.dart';
import 'package:niral_prj/drychilly.dart';
import 'package:niral_prj/lemon.dart';
import 'package:niral_prj/listpage.dart';
import 'package:niral_prj/mango.dart';
import 'package:niral_prj/profilepage.dart';
import 'package:niral_prj/index.dart';
import 'package:niral_prj/wheat.dart';
import 'package:niral_prj/rice.dart';
import 'package:niral_prj/cherry.dart';
import 'package:niral_prj/favorite_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _selectedIndex = 2;
  List<Map<String, String>> favoriteItems = [];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
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
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ListPage()),
        );
        break;
      case 2:
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  Widget _buildProductCard(String name, String imagePath) {
    bool isFav = favoriteItems.any((item) => item['name'] == name);

    return ProductCard(
      name: name,
      imagePath: imagePath,
      isFavorite: isFav,
      onTap: () {
        switch (name) {
          case 'Rice Seed':
            Navigator.push(context, MaterialPageRoute(builder: (_) => RiceSeedpage()));
            break;
          case 'Lemon Tree':
            Navigator.push(context, MaterialPageRoute(builder: (_) => LemonSeedPage()));
            break;
          case 'Weat Seed':
            Navigator.push(context, MaterialPageRoute(builder: (_) => WheatSeedPage()));
            break;
          case 'Cherry Tree':
            Navigator.push(context, MaterialPageRoute(builder: (_) => CherrySeedPage()));
            break;
          case 'Dry Chilly':
            Navigator.push(context, MaterialPageRoute(builder: (_) => DryChillySeedPage()));
            break;
          case 'Mango':
            Navigator.push(context, MaterialPageRoute(builder: (_) => MangoSeedPage()));
            break;
        }
      },
      onFavorite: () {
        setState(() {
          if (isFav) {
            favoriteItems.removeWhere((item) => item['name'] == name);
          } else {
            favoriteItems.add({'name': name, 'image': imagePath});
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = [
      {'name': 'Rice Seed', 'image': 'assets/Rice_Seed.jpeg'},
      {'name': 'Lemon Tree', 'image': 'assets/lemon_tree.jpeg'},
      {'name': 'Weat Seed', 'image': 'assets/wheat.jpeg'},
      {'name': 'Cherry Tree', 'image': 'assets/cherry.jpeg'},
      {'name': 'Dry Chilly', 'image': 'assets/drychilly2.jpeg'},
      {'name': 'Mango', 'image': 'assets/mango.jpeg'},
    ];

    final filteredProducts = products.where((product) {
      final name = product['name']!.toLowerCase();
      return name.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFF055B1D),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Explore Your Wishes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FavoritePage(favorites: favoriteItems),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cart opened')),
                  );
                },
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF055B1D), Color(0xFF077A2F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDCE8D6)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: filteredProducts.map((product) {
                  return _buildProductCard(product['name']!, product['image']!);
                }).toList(),
              ),
            ),
          ],
        ),
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
}

class ProductCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const ProductCard({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.onTap,
    required this.onFavorite,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFDCE8D6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                    onPressed: onFavorite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
