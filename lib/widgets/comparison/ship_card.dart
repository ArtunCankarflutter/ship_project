import 'package:flutter/material.dart';
import '../../constants/styles.dart';
import 'ship_image.dart';
import 'ship_details.dart';

class ShipCard extends StatelessWidget {
  final Map<String, dynamic> ship;
  final Color backgroundColor;
  final Color accentColor;

  const ShipCard({
    Key? key,
    required this.ship,
    required this.backgroundColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShipImage(imageUrl: ship['image_url']),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ship['ship_name'] ?? 'Unknown Ship',
                  style: TextStyles.shipNameText,
                ),
                const SizedBox(height: 16),
                ShipDetails(
                  shipData: ship,
                  accentColor: accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}