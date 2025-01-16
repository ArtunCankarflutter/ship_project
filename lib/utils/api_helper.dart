import 'package:http/http.dart' as http;

class ApiHelper {
  static const String baseUrl = 'http://localhost';

  static Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/test_connection.php'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test error: $e');
      return false;
    }
  }
}