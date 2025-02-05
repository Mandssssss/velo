import 'package:flutter/material.dart';
import 'package:velo/presentation/pages/login.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: "PLAN",
      subtitle: "your route, ride\nschedule, and your\nbike buddies.",
      image: "assets/images/image1.png",
      buttonText: "Next",
    ),
    OnboardingContent(
      title: "TRACK",
      subtitle: "the weather and\ntraffic along your\nroute.",
      image: "assets/images/image2.png",
      buttonText: "Next",
    ),
    OnboardingContent(
      title: "SHARE",
      subtitle: "the experience and\nyour journey with\nVELORA",
      image: "assets/images/image3.png",
      buttonText: "Get Started",
    ),
  ];

  void _onButtonPressed() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _contents.length,
            itemBuilder: (context, index) {
              final content = _contents[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0),
                    Image.asset(
                      'assets/images/logo.png', // Splash logo for onboarding
                      height: 24,
                    ),
                    const SizedBox(height: 0),
                    Text(
                      content.title,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB42B2B),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content.subtitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          content.image,
                          height: 300,
                          width: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _contents.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? const Color(0xFF4A1515)
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A1515),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _contents[_currentPage].buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String subtitle;
  final String image;
  final String buttonText;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
  });
}
