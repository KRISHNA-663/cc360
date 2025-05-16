import 'package:flutter/material.dart';
import 'index.dart';
import 'shop.dart';
import 'listpage.dart';
import 'profilepage.dart';

class RiceSeedpage extends StatefulWidget {
  const RiceSeedpage({Key? key}) : super(key: key);

  @override
  _RiceSeedpageState createState() => _RiceSeedpageState();
}

class _RiceSeedpageState extends State<RiceSeedpage> {
  int _selectedIndex = 2;
  String _searchQuery = '';
  String _kgFilter = '';
  String _locationFilter = '';

  final List<Product> _cartItems = [];

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

  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _viewCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: _cartItems),
      ),
    );
  }

  List<Product> _filteredProducts() {
    List<Product> allProducts = [
      Product('assets/riceseedpremimum.jpg', 'Rice Seeds - Elite', 'Muthiah family', 'Karur', 'Rs 40/Kg'),
      Product('assets/riceseeddrum.jpg', 'Rice Seeds - Durum', 'Chinnasamy family', 'Tirunelveli', 'Rs 55/Kg'),
      Product('assets/riceseeedhybrid.jpg', 'Rice Seeds - Hybrid', 'Karuppan family', 'Palakkad', 'Rs 30/Kg'),
      Product('assets/riceseedlocal.jpg', 'Rice Seeds - Local', 'Periyasamy family', 'Tiruppur', 'Rs 25/Kg'),
      Product('assets/riceseedorganic.jpg', 'Rice Seeds - Organic', 'Muthulakshmi family', 'Coimbatore', 'Rs 50/Kg'),
      Product('assets/riceseedpremimum.jpg', 'Rice Seeds - Elite', 'Velu family', 'Madurai', 'Rs 45/Kg'),
      Product('assets/riceseedsoft.jpg', 'Rice Seeds - Soft', 'Ponnamma family', 'Salem', 'Rs 35/Kg'),
      Product('assets/riceseedspring.jpg', 'Rice Seeds - Spring', 'Vellaiyamma family', 'Erode', 'Rs 60/Kg'),
    ];

    return allProducts.where((product) {
      final matchesName = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLocation = _locationFilter.isEmpty ||
          product.location.toLowerCase().contains(_locationFilter.toLowerCase());
      final matchesKg = _kgFilter.isEmpty ||
          product.price.toLowerCase().contains(_kgFilter.toLowerCase());
      return matchesName && matchesLocation && matchesKg;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFF055B1D),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 46.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rice Seeds',
                     
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  IconButton(
                    onPressed: _viewCart,
                    icon: const Icon(Icons.shopping_bag),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() => _kgFilter = value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Kg range...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() => _locationFilter = value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Location...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Product List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: _filteredProducts()
                  .map((product) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ProductCard(
                          product: product,
                          color: const Color(0xFFE0EAD8),
                          onAddToCart: () => _addToCart(product),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF006400),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

// Product class
class Product {
  final String image;
  final String name;
  final String family;
  final String location;
  final String price;

  Product(this.image, this.name, this.family, this.location, this.price);
}

// Product Card Widget
class ProductCard extends StatelessWidget {
  final Product product;
  final Color color;
  final VoidCallback onAddToCart;

  const ProductCard({
    Key? key,
    required this.product,
    required this.color,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
            child: Image.asset(
              product.image,
              width: 90,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 100,
                color: Colors.grey[300],
                child: const Center(child: Text('Image Not Found')),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(product.family, style: const TextStyle(fontSize: 14)),
                  Text(product.location, style: const TextStyle(fontSize: 14)),
                  Text(product.price,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: onAddToCart,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF055B1D),
        iconTheme: const IconThemeData(
          color: Colors.white, // Changes the arrow icon to white
        ),
        title: const Text(
          'Your Cart',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return ListTile(
                  leading: Image.asset(
                    product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text(product.price),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF055B1D),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Handle place order logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully!')),
                  );
                },
                child: const Text(
  'Place Order',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white, // <-- added this line
  ),
),

              ),
            ),
    );
  }
}
