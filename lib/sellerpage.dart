import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Product Model
class Product {
  final String name;
  final String pricePerKg;
  final String location;
  final String farmerName;
  final File image;

  Product({
    required this.name,
    required this.pricePerKg,
    required this.location,
    required this.farmerName,
    required this.image,
  });
}

// Singleton Product Manager
class ProductManager {
  static final ProductManager _instance = ProductManager._internal();
  factory ProductManager() => _instance;
  ProductManager._internal();

  final List<Product> _products = [];
  int _totalSales = 0;
  int _itemsSold = 0;
  int _pendingOrders = 0;

  List<Product> get products => _products;
  int get totalSales => _totalSales;
  int get itemsSold => _itemsSold;
  int get pendingOrders => _pendingOrders;

  void addProduct(Product product) {
    _products.add(product);
    _totalSales += 100; // Placeholder logic
    _itemsSold += 10;
    _pendingOrders += 1;
  }
}

// Seller Page
class SellerPage extends StatefulWidget {
  const SellerPage({Key? key}) : super(key: key);
  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  final productManager = ProductManager();

  void _navigateToAddProductPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
    setState(() {}); // Refresh after adding product
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        backgroundColor: const Color(0xFF055B1D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Welcome, Seller!', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _navigateToAddProductPage,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF055B1D)),
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sales Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF055B1D)),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFFDCE8D6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Sales: Rs ${productManager.totalSales}'),
                    Text('Items Sold: ${productManager.itemsSold}'),
                    Text('Pending Orders: ${productManager.pendingOrders}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF055B1D)),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productManager.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final product = productManager.products[index];
                return SellerProductCard(
                  name: product.name,
                  price: 'Rs ${product.pricePerKg}/kg',
                  stock: '${productManager.itemsSold} in stock',
                  imageFile: product.image,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Add Product Page
class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File? _productImage;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _farmerNameController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _productImage = File(picked.path);
      });
    }
  }

  void _submitProduct() {
    if (_productImage == null ||
        _nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _farmerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    final product = Product(
      name: _nameController.text,
      pricePerKg: _priceController.text,
      location: _locationController.text,
      farmerName: _farmerNameController.text,
      image: _productImage!,
    );

    ProductManager().addProduct(product);
    Navigator.pop(context);
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose image source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: const Color(0xFF055B1D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _productImage != null
                ? Image.file(_productImage!, height: 200, fit: BoxFit.cover)
                : Container(
              height: 200,
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showImagePickerDialog,
              child: const Text("Select Image"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF055B1D)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price (Rs/kg)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _farmerNameController,
              decoration: const InputDecoration(labelText: 'Farmer Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProduct,
              child: const Text('Add Product'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF055B1D)),
            ),
          ],
        ),
      ),
    );
  }
}

// SellerProductCard Widget
class SellerProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String stock;
  final File imageFile;

  const SellerProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFDCE8D6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image.file(imageFile, fit: BoxFit.cover, width: double.infinity)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price, style: const TextStyle(fontSize: 12)),
                Text(stock, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
