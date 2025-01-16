import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart'; 

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteShips = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: favoriteShips.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: favoriteShips.length,
              itemBuilder: (context, index) {
                final ship = favoriteShips[index];
                return ListTile(
                  title: Text(ship['ship_name']),
                  subtitle: Text(ship['ship_type']),
                );
              },
            ),
    );
  }
}
