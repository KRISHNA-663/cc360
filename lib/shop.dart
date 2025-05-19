import 'dart:ui';
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
  String _searchQuery = '';
  List<Map<String, String>> favoriteItems = [];

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
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ListPage()),
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

  List<Map<String, String>> _filteredProducts() {
    final allProducts = [
      {'name': 'Rice Seed', 'image': 'assets/Rice_Seed.jpeg'},
      {'name': 'Lemon Tree', 'image': 'assets/lemon_tree.jpeg'},
      {'name': 'Weat Seed', 'image': 'assets/wheat.jpeg'},
      {'name': 'Cherry Tree', 'image': 'assets/cherry.jpeg'},
      {'name': 'Dry Chilly', 'image': 'assets/drychilly2.jpeg'},
      {'name': 'Mango', 'image': 'assets/mango.jpeg'},
    ];

    return allProducts.where((product) {
      final name = product['name']!.toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts();

    return Scaffold(
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
                    setState(() {
                      _searchQuery = value;
                    });
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
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
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
}

class ProductCard extends StatefulWidget {
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
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveUpAnimation;
  late Animation<double> _fadeOutAnimation;
  bool _showFlyingHeart = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _moveUpAnimation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeOutAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showFlyingHeart = false);
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFavoritePressed() {
    widget.onFavorite();
    setState(() {
      _showFlyingHeart = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
                      widget.imagePath,
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
                          widget.name,
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
                          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: widget.isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: _onFavoritePressed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showFlyingHeart)
            Positioned(
              right: 8, // near the heart icon horizontally
              bottom: 36, // just above the icon vertically
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _moveUpAnimation.value),
                    child: Opacity(
                      opacity: _fadeOutAnimation.value,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
