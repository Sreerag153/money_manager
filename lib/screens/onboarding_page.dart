import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});
  @override
  Widget build(BuildContext context) {
    return _onboardContent(Icons.account_balance_wallet, Colors.blue, 
      'Track Your Expenses', 'Easily record and manage all your daily spending in one place.');
  }
}

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});
  @override
  Widget build(BuildContext context) {
    return _onboardContent(Icons.bar_chart_rounded, Colors.green, 
      'Analyze Your Budget', 'See clear charts and reports to understand where your money goes.');
  }
}

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});
  @override
  Widget build(BuildContext context) {
    return _onboardContent(Icons.savings_rounded, Colors.orange, 
      'Save Smarter', 'Set goals and build better saving habits for your future.');
  }
}

Widget _onboardContent(IconData icon, Color color, String title, String desc) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 200, color: color),
        const SizedBox(height: 25),
        Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white70)),
        ),
      ],
    ),
  );
}