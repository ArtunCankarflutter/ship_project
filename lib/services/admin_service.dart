import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminService {
  static Future<bool> isUserAdmin() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/check_admin.php?user_id=2'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['is_admin'] ?? false;
      } else {
        throw Exception('Failed to check admin status');
      }
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }
}