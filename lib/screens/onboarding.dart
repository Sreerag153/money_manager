import 'package:flutter/material.dart';
import 'package:money_manager_app/screens/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_manager_app/pages/profile.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController controller = PageController();
  int currentpage = 0;

  final pages = [
    OnboardingPage1(),
    OnboardingPage2(),
    OnboardingPage3(),
  ];

  Future<void> finishOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenOnboarding", true);
    Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
        actions: [
          if (currentpage != pages.length - 1)
            TextButton(
              onPressed: finishOnBoarding,
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.black),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentpage = index;
                });
              },
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
                  color: currentpage == index ? Colors.blue : Colors.white,
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
              ),
              onPressed: () {
                if (currentpage == pages.length - 1) {
                  finishOnBoarding();
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(
                currentpage == pages.length - 1 ? "Get Started" : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
