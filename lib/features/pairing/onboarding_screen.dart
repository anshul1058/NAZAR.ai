import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    const _OnboardingData(
      image: 'assets/images/Onboarding1.png',
      title: 'Nice to meet\nyou!\nI\'m Nazar.Ai',
      desc: 'I\'m your little buddy on your phone. My job is to help '
          'you stay safe while using your phone, without getting in '
          'the way of your fun.',
    ),
    const _OnboardingData(
      image: 'assets/images/Onboarding2.png',
      title: 'Your world is fun, let me\nhelp keep it\nthat way.',
      desc: 'Just do everything as usual. I\'m here '
          'behind the scenes, you won\'t even notice.',
    ),
    const _OnboardingData(
      image: 'assets/images/Onboarding3.png',
      title: 'But sometimes, something\ntries to sneak in without\nyou noticing.',
      desc: 'A trap that costs you. I\'m here to help '
          'you recognize and avoid it, '
          'before you click.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _skip() => context.go('/scan-qr');
  void _start() => context.go('/scan-qr');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) =>
                    _OnboardingPage(data: _pages[index]),
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.toggleOff,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bottom buttons — smooth transition
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      )),
                      child: child,
                    ),
                  );
                },
                child: _currentPage == _pages.length - 1

                    // Last page — START button
                    ? SizedBox(
                        key: const ValueKey('start'),
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _start,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'START',
                            style: TextStyle(
                              color: AppColors.buttonPrimaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      )

                    // Pages 1 & 2 — Skip & Next
                    : SizedBox(
                        key: ValueKey('nav-$_currentPage'),
                        height: 52,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Skip button
                            TextButton(
                              onPressed: _skip,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                              ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            // Round Next button
                            SizedBox(
                              width: 52,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonPrimary,
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.buttonPrimaryText,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data Model ───────────────────────────────────────
class _OnboardingData {
  final String image;
  final String title;
  final String desc;

  const _OnboardingData({
    required this.image,
    required this.title,
    required this.desc,
  });
}

// ─── Page Widget ──────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Smaller image
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Image.asset(
                data.image,
                fit: BoxFit.contain,
                height: 200,
              ),
            ),
          ),

          // Text
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.desc,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
