import 'package:flutter/material.dart';
import '../../constants/styles.dart';

class ShipComparisonHeader extends StatelessWidget {
  const ShipComparisonHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ship Comparison',
            style: TextStyles.headerText.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Compare specifications and features',
            style: TextStyles.subheaderText.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}