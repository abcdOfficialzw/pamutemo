import 'package:flutter/material.dart';

import '../models/fine.dart';
import '../theme/app_theme.dart';
import 'roadblock_mode_screen.dart';

class OffenceDetailScreen extends StatelessWidget {
  const OffenceDetailScreen({super.key, required this.fine});

  final Fine fine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offence'),
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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              Text(fine.offence, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              _DetailPillRow(
                leftLabel: 'Level',
                leftValue: fine.level.isEmpty ? '-' : fine.level,
                rightLabel: 'Fine',
                rightValue: fine.displayAmount,
              ),
              const SizedBox(height: 16),
              _DetailCard(
                title: 'Explanation',
                value: fine.explanation.isEmpty
                    ? 'Explanation coming soon.'
                    : fine.explanation,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RoadblockModeScreen(fine: fine),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Roadblock Mode'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _DetailCard(title: 'Section', value: fine.section),
              const SizedBox(height: 12),
              _DetailCard(title: 'Category', value: fine.category),
              const SizedBox(height: 12),
              if (fine.subsection.isNotEmpty)
                _DetailCard(title: 'Subsection', value: fine.subsection),
              if (fine.subsection.isNotEmpty) const SizedBox(height: 12),
              if (fine.act.isNotEmpty)
                _DetailCard(title: 'Act / SI', value: fine.act),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailPillRow extends StatelessWidget {
  const _DetailPillRow({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Pill(label: leftLabel, value: leftValue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Pill(label: rightLabel, value: rightValue),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.forestDeep),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            value.isEmpty ? '-' : value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
