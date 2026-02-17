import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class KnowYourRightsScreen extends StatelessWidget {
  const KnowYourRightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = <String>[
      'Remain calm and be respectful. Ask the officer to identify themselves.',
      'You may request an official receipt for any fine paid at a roadblock.',
      'If you disagree, you can ask to pay at the nearest police station.',
      'Keep your documents accessible to avoid delays at the checkpoint.',
      'Roadblocks should be marked and supervised by officers in uniform.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Know Your Rights'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.mist, AppColors.sand],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45],
          ),
        ),
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            itemCount: tips.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Text(
                  'Quick, calm guidance for handling roadblocks.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
                );
              }
              final tip = tips[index - 1];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.forest.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 18,
                        color: AppColors.forest,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tip,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
