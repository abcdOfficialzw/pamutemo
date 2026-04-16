import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/checklist_repository.dart';
import '../data/fines_repository.dart';
import '../models/category_item.dart';
import '../models/checklist_item.dart';
import '../models/fine.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import '../widgets/feature_card.dart';
import 'am_i_ready_screen.dart';
import 'category_detail_screen.dart';
import 'know_your_rights_screen.dart';
import 'offence_detail_screen.dart';

class FinesScreen extends StatefulWidget {
  const FinesScreen({super.key});

  @override
  State<FinesScreen> createState() => _FinesScreenState();
}

class _FinesScreenState extends State<FinesScreen> {
  static final Uri _depositFinesUri = Uri.parse(
    'https://bigsky.co.zw/wp-content/uploads/Schedule-of-Deposit-Fines-Traffic-2024.pdf',
  );

  final TextEditingController _searchController = TextEditingController();
  late Future<_ScreenData> _dataFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<_ScreenData> _loadData() async {
    final fines = await FinesRepository.loadFines();
    final checklist = await ChecklistRepository.load();
    return _ScreenData(fines: fines, checklist: checklist);
  }

  List<CategoryItem> _buildCategories(List<Fine> fines) {
    final counts = <String, int>{};
    for (final fine in fines) {
      final key = fine.category.isEmpty ? fine.group : fine.category;
      if (key.isEmpty) {
        continue;
      }
      counts[key] = (counts[key] ?? 0) + 1;
    }
    final categories = counts.entries
        .map(
          (entry) => CategoryItem(
            name: entry.key,
            count: entry.value,
            icon: _iconForCategory(entry.key),
          ),
        )
        .toList();
    categories.sort((a, b) => a.name.compareTo(b.name));
    return categories;
  }

  IconData _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('licen')) return Icons.badge_outlined;
    if (lower.contains('moving')) return Icons.swap_horiz;
    if (lower.contains('light') || lower.contains('reflect')) {
      return Icons.lightbulb_outline;
    }
    if (lower.contains('brake') || lower.contains('tyre')) {
      return Icons.build_circle_outlined;
    }
    if (lower.contains('vehicle') || lower.contains('condition')) {
      return Icons.car_repair_outlined;
    }
    if (lower.contains('psv') || lower.contains('commercial')) {
      return Icons.airport_shuttle_outlined;
    }
    if (lower.contains('document') || lower.contains('plate')) {
      return Icons.description_outlined;
    }
    if (lower.contains('safety') || lower.contains('belt')) {
      return Icons.warning_amber_outlined;
    }
    if (lower.contains('speed')) return Icons.speed;
    return Icons.folder_outlined;
  }

  List<Fine> _filterFines(List<Fine> fines, String query) {
    if (query.isEmpty) return [];
    final needle = query.toLowerCase();
    return fines.where((fine) {
      return fine.offence.toLowerCase().contains(needle) ||
          fine.section.toLowerCase().contains(needle) ||
          fine.category.toLowerCase().contains(needle) ||
          fine.group.toLowerCase().contains(needle) ||
          fine.act.toLowerCase().contains(needle) ||
          fine.explanation.toLowerCase().contains(needle);
    }).toList();
  }

  Future<void> _openDepositFinesDocument() async {
    final success = await launchUrl(
      _depositFinesUri,
      mode: LaunchMode.externalApplication,
    );
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the source document.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ScreenData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load fines data.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        final data =
            snapshot.data ?? _ScreenData(fines: const [], checklist: const []);
        final fines = data.fines;
        final categories = _buildCategories(fines);
        final results = _filterFines(fines, _query);
        final pending = data.checklist.where((item) => !item.checked).length;
        final pendingSubtitle = pending == 0
            ? 'All set. You are ready for the road.'
            : '$pending items pending. Tap to review.';

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.mist, AppColors.sand],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.45],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/logo/pamutero-logo-transparent.png',
                              width: 36,
                              height: 36,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'PaMutemo',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(color: AppColors.forestDeep),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: const Icon(Icons.info_outline),
                          color: AppColors.forestDeep,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Know the fine. Know your rights.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF2C3630),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disclaimer: Fine amounts are populated from the NATIONAL SCHEDULE OF DEPOSIT FINES [TRAFFIC OFFENCES ONLY] document.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.muted),
                        ),
                        const SizedBox(height: 6),
                        TextButton.icon(
                          onPressed: _openDepositFinesDocument,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text('Open source document (PDF)'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText:
                          'Search offences (e.g. triangle, seatbelt, licence)',
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_query.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search results',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '${results.length} found',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (results.isEmpty)
                      Text(
                        'No offences found for "$_query".',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.muted,
                        ),
                      )
                    else
                      ...results.map(
                        (fine) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: ListTile(
                            title: Text(
                              fine.offence,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              fine.section,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.muted),
                            ),
                            trailing: Text(
                              fine.displayAmount,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: AppColors.forestDeep),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      OffenceDetailScreen(fine: fine),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ] else ...[
                    FeatureCard(
                      title: 'Know Your Rights',
                      subtitle:
                          'Quick tips for handling roadblocks calmly and legally.',
                      icon: Icons.shield_outlined,
                      badge: 'Pinned',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const KnowYourRightsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    FeatureCard(
                      title: 'Am I Ready?',
                      subtitle: pendingSubtitle,
                      subtitleColor: pending == 0
                          ? AppColors.muted
                          : AppColors.danger,
                      icon: Icons.checklist_outlined,
                      badge: pending == 0 ? 'Ready' : '$pending pending',
                      badgeColor: pending == 0
                          ? AppColors.forest
                          : AppColors.danger,
                      badgeTextColor: Colors.white,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const AmIReadyScreen(),
                          ),
                        );
                        setState(() {
                          _dataFuture = _loadData();
                        });
                      },
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '${categories.length} sections',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.95,
                          ),
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        final categoryFines = fines
                            .where(
                              (fine) =>
                                  (fine.category.isNotEmpty
                                      ? fine.category
                                      : fine.group) ==
                                  item.name,
                            )
                            .toList();
                        return CategoryCard(
                          item: item,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => CategoryDetailScreen(
                                  category: item,
                                  fines: categoryFines,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScreenData {
  const _ScreenData({required this.fines, required this.checklist});

  final List<Fine> fines;
  final List<ChecklistItem> checklist;
}
