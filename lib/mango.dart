import 'package:flutter/material.dart';

class MangoSeedPage extends StatefulWidget {
  const MangoSeedPage({super.key});

  @override
  State<MangoSeedPage> createState() => _MangoSeedPageState();
}

class _MangoSeedPageState extends State<MangoSeedPage> {
  String _searchQuery = '';
  String _kgFilter = '';
  String _locationFilter = '';
  final List<Product> _cart = [];

  final List<Product> _products = [
    Product(
      image: 'assets/mango/MangoAlphonso.jpg',
      name: 'Mango - Alphonso',
      family: 'Anacardiaceae family',
      location: 'Salem',
      price: 'Rs 150/Kg',
    ),
    Product(
      image: 'assets/mango/MangoTotapuri.jpg',
      name: 'Mango - Totapuri',
      family: 'Anacardiaceae family',
      location: 'Coimbatore',
      price: 'Rs 120/Kg',
    ),
    Product(
      image: 'assets/mango/MangoHybrid.jpg',
      name: 'Mango - Hybrid',
      family: 'Anacardiaceae family',
      location: 'Madurai',
      price: 'Rs 140/Kg',
    ),
    Product(
      image: 'assets/mango/MangoOrganic.jpg',
      name: 'Mango - Organic',
      family: 'Anacardiaceae family',
      location: 'Tiruppur',
      price: 'Rs 180/Kg',
    ),
    Product(
      image: 'assets/mango/MangoBanganapalli.jpg',
      name: 'Mango - Banganapalli',
      family: 'Anacardiaceae family',
      location: 'Erode',
      price: 'Rs 130/Kg',
    ),
    Product(
      image: 'assets/mango/MangoNeelam.jpg',
      name: 'Mango - Neelam',
      family: 'Anacardiaceae family',
      location: 'Karur',
      price: 'Rs 110/Kg',
    ),
    Product(
      image: 'assets/mango/MangoLocal.jpg',
      name: 'Mango - Local',
      family: 'Anacardiaceae family',
      location: 'Tirunelveli',
      price: 'Rs 100/Kg',
    ),
    Product(
      image: 'assets/mango/MangoPremium.jpg',
      name: 'Mango - Premium',
      family: 'Anacardiaceae family',
      location: 'Palakkad',
      price: 'Rs 160/Kg',
    ),
  ];

  List<Product> get _filteredProducts {
    return _products.where((product) {
      final matchesName =
      product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLocation = _locationFilter.isEmpty ||
          product.location.toLowerCase().contains(_locationFilter.toLowerCase());
      final matchesKg = _kgFilter.isEmpty ||
          product.price.toLowerCase().contains(_kgFilter.toLowerCase());
      return matchesName && matchesLocation && matchesKg;
    }).toList();
  }

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CartPage(cartItems: _cart, onPlaceOrder: _placeOrder);
      },
    );
  }

  void _placeOrder() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Order Placed"),
        content: const Text("Your order was placed successfully!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
    setState(() {
      _cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0EAD8),
      appBar: AppBar(
        title: const Text(
          'Mango Seeds',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: _showCart,
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color(0xFF055B1D),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: const InputDecoration(
                    hintText: 'Search by name...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => _kgFilter = value),
                        decoration: const InputDecoration(
                          hintText: 'Kg range',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => _locationFilter = value),
                        decoration: const InputDecoration(
                          hintText: 'Location',
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

          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        product.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.family),
                              Text(product.location),
                            ],
                          ),
                        ),
                        Text(
                          product.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      color: Colors.green[800],
                      iconSize: 28,
                      onPressed: () => _addToCart(product),
                      tooltip: 'Add to Cart',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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

class Product {
  final String image;
  final String name;
  final String family;
  final String location;
  final String price;

  Product({
    required this.image,
    required this.name,
    required this.family,
    required this.location,
    required this.price,
  });
}

class CartPage extends StatelessWidget {
  final List<Product> cartItems;
  final VoidCallback onPlaceOrder;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Your Cart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text('No items in cart.'))
                : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.price),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onPlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Place Order'),
            ),
          ),
        ],
      ),
    );
  }
}
