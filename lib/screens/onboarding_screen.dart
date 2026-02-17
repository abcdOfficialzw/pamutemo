import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/onboarding_repository.dart';
import '../theme/app_theme.dart';
import 'home_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      title: 'Know the fine',
      body:
          'Quickly find the correct traffic fine and stay calm at roadblocks.',
      illustrationPath: 'assets/illustrations/onboard_fines.svg',
    ),
    _OnboardingPage(
      title: 'Be ready',
      body: 'Use the checklist to avoid common roadblock penalties.',
      illustrationPath: 'assets/illustrations/onboard_ready.svg',
    ),
    _OnboardingPage(
      title: 'Roadblock Mode',
      body: 'Show the offence and amount clearly to an officer in one tap.',
      illustrationPath: 'assets/illustrations/onboard_roadblock.svg',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await OnboardingRepository.setCompleted();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PaMutemo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.forestDeep,
                    ),
                  ),
                  TextButton(onPressed: _finish, child: const Text('Skip')),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: SvgPicture.asset(
                              page.illustrationPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: AppColors.forestDeep,
                                fontSize: 28,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.muted),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.forest
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == _pages.length - 1) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.illustrationPath,
  });

  final String title;
  final String body;
  final String illustrationPath;
}
