import 'package:flutter/material.dart';
import 'shop.dart'; // Make sure this import points to your ShopPage

class FavoritePage extends StatelessWidget {
  final List<Map<String, String>> favorites;

  const FavoritePage({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: const Color(0xFF055B1D),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ShopPage()),
                    );
                  },
                  child: ListTile(
                    leading: Image.asset(
                      item['image']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['name']!),
                  ),
                );
              },
            ),
    );
  }
}
