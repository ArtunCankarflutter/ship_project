import 'package:flutter/material.dart';
import '../widgets/comparison/ship_comparison_header.dart';
import '../widgets/comparison/ship_card.dart';
import '../constants/styles.dart';

class CompareScreen extends StatelessWidget {
  final Map<String, dynamic> ship1;
  final Map<String, dynamic> ship2;

  const CompareScreen({
    Key? key,
    required this.ship1,
    required this.ship2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compare Ships"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ShipComparisonHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ShipCard(
                        ship: ship1,
                        backgroundColor: AppColors.ship1Background,
                        accentColor: AppColors.ship1Accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShipCard(
                        ship: ship2,
                        backgroundColor: AppColors.ship2Background,
                        accentColor: AppColors.ship2Accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







