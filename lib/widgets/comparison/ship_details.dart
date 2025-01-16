import 'package:flutter/material.dart';
import '../../constants/styles.dart';

class ShipDetails extends StatelessWidget {
  final Map<String, dynamic> shipData;
  final Color accentColor;

  const ShipDetails({
    Key? key,
    required this.shipData,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildDetailsList(),
    );
  }

  List<Widget> _buildDetailsList() {
    final keyMappings = {
      'type': ['type', 'ship_type', 'vessel_type'],
      'length': ['length', 'ship_length', 'vessel_length'],
      'width': ['width', 'ship_width', 'vessel_width'],
      'price': ['price', 'cost', 'value', 'selling_price'],
      'seller': ['seller', 'vendor', 'dealer']
    };

    final List<Widget> details = [];
    
    keyMappings.forEach((desiredKey, possibleKeys) {
      for (final key in possibleKeys) {
        if (shipData.containsKey(key)) {
          details.add(_buildDetailItem(desiredKey, shipData[key], isPrice: desiredKey == 'price'));
          break;
        }
      }
    });

    return details;
  }

  Widget _buildDetailItem(String key, dynamic value, {bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatKey(key),
            style: TextStyles.detailLabelText.copyWith(color: accentColor),
          ),
          const SizedBox(height: 4),
          if (isPrice)
            Row(
              children: [
                Text(
                  value.toString(),
                  style: TextStyles.detailValueText,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            )
          else
            Text(
              value.toString(),
              style: TextStyles.detailValueText,
            ),
          const SizedBox(height: 8),
          Divider(color: accentColor.withOpacity(0.2)),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}