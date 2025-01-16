import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {

  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void addFavorite(Map<String, dynamic> ship) {
    if (!_favorites.contains(ship)) {
      _favorites.add(ship);
      notifyListeners();
    }
  }

  void removeFavorite(Map<String, dynamic> ship) {
    _favorites.remove(ship);
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> ship) {
    return _favorites.contains(ship);
  }
}
