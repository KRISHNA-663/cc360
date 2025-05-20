import 'package:flutter/material.dart';
import 'dart:math';

class RiceSeedPage extends StatefulWidget {
  const RiceSeedPage({super.key});

  @override
  State<RiceSeedPage> createState() => _RiceSeedPageState();
}

class _RiceSeedPageState extends State<RiceSeedPage> {
  String _searchQuery = '';
  String _kgFilter = '';
  String _locationFilter = '';
  final List<Product> _cart = [];

  final List<Product> _products = [
    Product(image: 'assets/riceseedpremimum.jpg', name: 'Rice Seeds - Elite', family: 'Muthiah family', location: 'Karur', price: 'Rs 40/Kg'),
    Product(image: 'assets/riceseeddrum.jpg', name: 'Rice Seeds - Durum', family: 'Chinnasamy family', location: 'Tirunelveli', price: 'Rs 55/Kg'),
    Product(image: 'assets/riceseeedhybrid.jpg', name: 'Rice Seeds - Hybrid', family: 'Karuppan family', location: 'Palakkad', price: 'Rs 30/Kg'),
    Product(image: 'assets/riceseedlocal.jpg', name: 'Rice Seeds - Local', family: 'Periyasamy family', location: 'Tiruppur', price: 'Rs 25/Kg'),
    Product(image: 'assets/riceseedorganic.jpg', name: 'Rice Seeds - Organic', family: 'Muthulakshmi family', location: 'Coimbatore', price: 'Rs 50/Kg'),
    Product(image: 'assets/riceseedpremimum.jpg', name: 'Rice Seeds - Elite', family: 'Velu family', location: 'Madurai', price: 'Rs 45/Kg'),
    Product(image: 'assets/riceseedsoft.jpg', name: 'Rice Seeds - Soft', family: 'Ponnamma family', location: 'Salem', price: 'Rs 35/Kg'),
    Product(image: 'assets/riceseedspring.jpg', name: 'Rice Seeds - Spring', family: 'Vellaiyamma family', location: 'Erode', price: 'Rs 60/Kg'),
  ];

  List<Product> get _filteredProducts {
    return _products.where((product) {
      final matchesName = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLocation = _locationFilter.isEmpty || product.location.toLowerCase().contains(_locationFilter.toLowerCase());
      final matchesKg = _kgFilter.isEmpty || product.price.toLowerCase().contains(_kgFilter.toLowerCase());
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
    Navigator.pop(context); // Close the cart sheet
    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Logistics Service"),
          content: const Text("Do you want to avail logistics service?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _showOrderPlacedDialog();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _showDriverSelection();
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    });
  }

  void _showDriverSelection() {
    final List<Driver> drivers = [
      Driver(name: 'Arjun', plate: 'TN-45', phone: _generatePhoneNumber()),
      Driver(name: 'Ravi', plate: 'TN-38', phone: _generatePhoneNumber()),
      Driver(name: 'Mani', plate: 'TN-67', phone: _generatePhoneNumber()),
      Driver(name: 'Kumar', plate: 'TN-22', phone: _generatePhoneNumber()),
    ];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Select a Driver',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return ListTile(
                      leading: const Icon(Icons.local_shipping),
                      title: Text('Driver: ${driver.name} (${driver.plate})'),
                      onTap: () {
                        Navigator.pop(context); // Close bottom sheet
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _showDriverInfo(driver);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDriverInfo(Driver driver) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Driver Assigned"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("The driver will contact you shortly.\n"),
            Text("Name: ${driver.name}"),
            Text("Contact: ${driver.phone}"),
            Text("Vehicle: ${driver.plate}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showOrderPlacedDialog();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showOrderPlacedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Order Placed"),
        content: const Text("Your rice seed order was placed successfully!"),
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

  String _generatePhoneNumber() {
    final rnd = Random();
    return '9${rnd.nextInt(9)}${rnd.nextInt(10)}${rnd.nextInt(10)}-${rnd.nextInt(900000) + 100000}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0EAD8),
      appBar: AppBar(
        title: const Text(
          'Rice Seeds',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
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
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
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

class Driver {
  final String name;
  final String plate;
  final String phone;

  Driver({required this.name, required this.plate, required this.phone});
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
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Place Order'),
            ),
          ),
        ],
      ),
    );
  }
}
