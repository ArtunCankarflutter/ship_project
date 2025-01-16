// lib/services/rating_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingService {
  static Future<double> getShipRating(String shipName) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/get_rating.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'ship_name': shipName,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return double.parse(data['rating'].toString());
      }
      return 0.0;
    } catch (e) {
      print('Error fetching rating: $e');
      return 0.0;
    }
  }
}
