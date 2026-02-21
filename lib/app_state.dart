import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _seenOnboarding = false;
  bool _profileCreated = false;
  bool _initialized = false;
  int _onboardingPageIndex = 0;

  bool get seenOnboarding => _seenOnboarding;
  bool get profileCreated => _profileCreated;
  bool get initialized => _initialized;
  int get onboardingPageIndex => _onboardingPageIndex;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    _profileCreated = prefs.getBool('profileCreated') ?? false;
    _initialized = true;
    notifyListeners();
  }

  void setOnboardingPage(int index) {
    _onboardingPageIndex = index;
    notifyListeners();
  }

  Future<void> compleateOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    _seenOnboarding = true;
    notifyListeners();
  }

  Future<void> createProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profileCreated', true);
    _profileCreated = true;
    notifyListeners();
  }
}