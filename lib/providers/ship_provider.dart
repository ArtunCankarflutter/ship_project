import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShipProvider with ChangeNotifier {
  List<Map<String, dynamic>> _ships = [];

  List<Map<String, dynamic>> get ships => _ships;

  Future<void> fetchShips() async {
    final url = Uri.parse('http://localhost/get_ships.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        _ships = List<Map<String, dynamic>>.from(json.decode(response.body));
        notifyListeners();
      } else {
        throw Exception('Failed to load ships');
      }
    } catch (error) {
      print('Error fetching ships: $error');
    }
  }
}



