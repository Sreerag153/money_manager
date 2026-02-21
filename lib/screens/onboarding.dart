import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/app_state.dart';
import 'package:money_manager_app/screens/onboarding_page.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final controller = PageController(initialPage: appState.onboardingPageIndex);

    final pages = const [
      OnboardingPage1(),
      OnboardingPage2(),
      OnboardingPage3(),
    ];

    bool isLastPage = appState.onboardingPageIndex == pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xff2B2B2B),
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!isLastPage)
            TextButton(
              onPressed: () => appState.compleateOnboarding(),
              child: const Text("Skip", style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (index) => appState.setOnboardingPage(index),
              itemBuilder: (context, index) => pages[index],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => Container(
                margin: const EdgeInsets.all(4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appState.onboardingPageIndex == index 
                      ? Colors.blue 
                      : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (isLastPage) {
                  appState.compleateOnboarding();
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(isLastPage ? "Get Started" : "Next"),
            ),
          ),
        ],
      ),
    );
  }
}