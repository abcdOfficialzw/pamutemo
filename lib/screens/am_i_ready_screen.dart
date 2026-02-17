import 'package:flutter/material.dart';

import '../data/checklist_repository.dart';
import '../models/checklist_item.dart';
import '../theme/app_theme.dart';

class AmIReadyScreen extends StatefulWidget {
  const AmIReadyScreen({super.key});

  @override
  State<AmIReadyScreen> createState() => _AmIReadyScreenState();
}

class _AmIReadyScreenState extends State<AmIReadyScreen> {
  late Future<List<ChecklistItem>> _itemsFuture;
  List<ChecklistItem> _items = [];

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadItems();
  }

  Future<List<ChecklistItem>> _loadItems() async {
    final items = await ChecklistRepository.load();
    _items = List<ChecklistItem>.from(items);
    return items;
  }

  Future<void> _toggleItem(int index) async {
    final item = _items[index];
    setState(() {
      _items[index] = item.copyWith(checked: !item.checked);
    });
    await ChecklistRepository.save(_items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Am I Ready?'),
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
          child: FutureBuilder<List<ChecklistItem>>(
            future: _itemsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = _items;
              final remaining = items.where((item) => !item.checked).length;
              final potentialFine = items
                  .where((item) => !item.checked)
                  .fold<int>(0, (total, item) => total + item.fine);

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  Text(
                    'Tick off the most requested items at roadblocks.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.forest.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.payments_outlined,
                            color: AppColors.forest,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Potential fines',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Based on unchecked items',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$$potentialFine',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppColors.forestDeep),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.forest.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          color: AppColors.forest,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Reminders for unchecked items are coming soon.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: item.checked
                              ? AppColors.forest.withOpacity(0.4)
                              : AppColors.border,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _toggleItem(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: item.checked,
                                activeColor: AppColors.forest,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                onChanged: (_) => _toggleItem(index),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: item.checked
                                            ? AppColors.forest
                                            : AppColors.ink,
                                        decoration: item.checked
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: item.checked
                                      ? AppColors.forest.withOpacity(0.12)
                                      : AppColors.gold.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '\$${item.fine}',
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(color: AppColors.forestDeep),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 4),
                  Text(
                    '$remaining items not checked yet.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
