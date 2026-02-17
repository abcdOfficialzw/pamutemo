import 'package:flutter/material.dart';

import '../models/category_item.dart';
import '../theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.item, this.onTap});

  final CategoryItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.forest.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(item.icon, color: AppColors.forest, size: 18),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 15),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.count} offences',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
