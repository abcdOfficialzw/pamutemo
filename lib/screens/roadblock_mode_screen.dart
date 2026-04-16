import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/fine.dart';
import '../theme/app_theme.dart';

class RoadblockModeScreen extends StatelessWidget {
  const RoadblockModeScreen({super.key, required this.fine});

  static final Uri _depositFinesUri = Uri.parse(
    'https://bigsky.co.zw/wp-content/uploads/Schedule-of-Deposit-Fines-Traffic-2024.pdf',
  );
  static final Uri _buyMeCoffeeUri = Uri.parse(
    'https://buymeacoffee.com/sirtitusvetech',
  );
  static const String _depositFinesAssetPath =
      'assets/Schedule-of-Deposit-Fines-Traffic-2024.pdf';
  static const String _depositFinesFileName =
      'Schedule-of-Deposit-Fines-Traffic-2024.pdf';

  final Fine fine;

  Future<void> _downloadScheduleOffline(BuildContext context) async {
    if (kIsWeb) {
      await _openWebSchedule(
        context,
        message: 'Opened the local PDF in your browser.',
      );
      return;
    }

    try {
      final data = await rootBundle.load(_depositFinesAssetPath);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_depositFinesFileName');
      if (!await file.exists()) {
        await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
      }

      final opened = await launchUrl(
        Uri.file(file.path),
        mode: LaunchMode.externalApplication,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              opened
                  ? 'Schedule downloaded for offline use.'
                  : 'Schedule downloaded for offline use at: ${file.path}',
            ),
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      await _openOfficialScheduleAsFallback(
        context,
        message: 'Offline copy unavailable. Opened the official PDF instead.',
      );
    }
  }

  Future<void> _openOfficialSource(BuildContext context) async {
    await _openExternalLink(
      context,
      _depositFinesUri,
      errorMessage: 'Unable to open the online source.',
    );
  }

  Future<void> _openWebSchedule(
    BuildContext context, {
    required String message,
  }) async {
    final success = await launchUrl(
      Uri.base.resolve(_depositFinesFileName),
      webOnlyWindowName: '_blank',
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? message : 'Unable to download the schedule.'),
      ),
    );
  }

  Future<void> _openOfficialScheduleAsFallback(
    BuildContext context, {
    required String message,
  }) async {
    final success = await launchUrl(
      _depositFinesUri,
      mode: LaunchMode.externalApplication,
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? message : 'Unable to download the schedule.'),
      ),
    );
  }

  Future<void> _openBuyMeACoffee(BuildContext context) async {
    await _openExternalLink(
      context,
      _buyMeCoffeeUri,
      errorMessage: 'Unable to open Buy me a coffee.',
    );
  }

  Future<void> _openExternalLink(
    BuildContext context,
    Uri uri, {
    required String errorMessage,
  }) async {
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

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
                const SizedBox(height: 18),
                Text(
                  'Fine amounts are populated from the NATIONAL SCHEDULE OF DEPOSIT FINES [TRAFFIC OFFENCES ONLY].',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
                const Spacer(),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_zip_outlined,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Reference',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.icon(
                              onPressed: () =>
                                  _downloadScheduleOffline(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: AppColors.forestDeep,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                              ),
                              icon: const Icon(
                                Icons.download_rounded,
                                size: 14,
                              ),
                              label: const Text('PDF'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _openOfficialSource(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              icon: const Icon(
                                Icons.open_in_new_rounded,
                                size: 14,
                              ),
                              label: const Text('Source'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: () => _openBuyMeACoffee(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.gold.withValues(alpha: 0.88),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      textStyle: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                    icon: const Icon(Icons.coffee_rounded, size: 14),
                    label: const Text('Buy me a coffee'),
                  ),
                ),
                const SizedBox(height: 10),
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
