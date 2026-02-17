import 'package:flutter/material.dart';

import '../models/fine.dart';
import '../theme/app_theme.dart';

class RoadblockModeScreen extends StatelessWidget {
  const RoadblockModeScreen({super.key, required this.fine});

  final Fine fine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.forestDeep,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ROADBLOCK MODE',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Text(
                  fine.offence,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    fine.displayAmount,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.forestDeep,
                      fontSize: 42,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Section: ${fine.section}',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const Spacer(),
                Text(
                  'Tap anywhere to exit',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
