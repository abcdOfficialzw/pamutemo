import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static final Uri _buyMeCoffeeUri = Uri.parse(
    'https://buymeacoffee.com/sirtitusvetech',
  );
  static final Uri _websiteUri = Uri.parse('https://takutitus.me');
  static final Uri _companyUri = Uri.parse('https://vetech.co.zw');
  static final Uri _emailUri = Uri.parse('mailto:info@vetech.co.zw');

  Future<void> _openLink(BuildContext context, Uri uri) async {
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to open the link.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo/pamutero-logo-transparent.png',
                  width: 44,
                  height: 44,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PaMutemo',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.forestDeep,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Know the fine. Know your rights.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.forest.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.forestDeep,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Takudzwa Titus Nyanhanga',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Zimbabwean software developer',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.coffee, color: AppColors.forest),
              title: const Text('Buy me a coffee'),
              subtitle: const Text('Support PaMutemo'),
              onTap: () => _openLink(context, _buyMeCoffeeUri),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.public, color: AppColors.forest),
              title: const Text('Personal website'),
              subtitle: const Text('takutitus.me'),
              onTap: () => _openLink(context, _websiteUri),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.apartment, color: AppColors.forest),
              title: const Text('veTech Private Limited'),
              subtitle: const Text('vetech.co.zw'),
              onTap: () => _openLink(context, _companyUri),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.email_outlined,
                color: AppColors.forest,
              ),
              title: const Text('Get an app for your business'),
              subtitle: const Text('info@vetech.co.zw'),
              onTap: () => _openLink(context, _emailUri),
            ),
            const Divider(height: 32),
            Text(
              'Thank you for supporting a safer, more transparent road experience.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
