import 'package:flutter/material.dart';

class ShipImage extends StatelessWidget {
  final String? imageUrl;

  const ShipImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Image.network(
        imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingIndicator();
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.directions_boat,
          size: 64,
          color: Colors.grey,
        ),
      ),
    );
  }
}