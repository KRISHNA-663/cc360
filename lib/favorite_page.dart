import 'package:flutter/material.dart';
import 'shop.dart';

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
        padding: const EdgeInsets.all(16.0),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FavoriteProductCard(
              image: item['image']!,
              name: item['name']!,
              family: item['family'] ?? '',  // optional: you can add family info
              price: item['price'] ?? '',    // optional: add price if you have it
              color: const Color(0xFFDCE8D6),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopPage()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FavoriteProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String family;
  final String price;
  final Color color;
  final VoidCallback onTap;

  const FavoriteProductCard({
    Key? key,
    required this.image,
    required this.name,
    this.family = '',
    this.price = '',
    required this.color,
    required this.onTap,
  }) : super(key: key);

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
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
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
                  if (family.isNotEmpty)
                    Text(family,
                        style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  if (price.isNotEmpty)
                    Text(price,
                        style: const TextStyle(fontSize: 13, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
