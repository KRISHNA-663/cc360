import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/commodity_price.dart';

class ApiService {
  static Future<List<CommodityPrice>> fetchPrices() async {
    final url = Uri.parse(
        'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070'
            '?api-key=aaaa&format=json&limit=100' //579b464db66ec23bdd00000183407be2861346244451e246e498ee53
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Ensure the API returns 'records' field
      final List<dynamic> records = decoded['records'];

      return records.map((json) => CommodityPrice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load prices: ${response.statusCode}');
    }
  }
}
