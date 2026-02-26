import 'package:flutter/material.dart';
import 'package:money_manager_app/app_state.dart';
import 'package:money_manager_app/home.dart';
import 'package:money_manager_app/pages/profile.dart';
import 'package:money_manager_app/screens/onboarding.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (!appState.initialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!appState.seenOnboarding) {
      return const Onboarding();
    }

    if (!appState.profileCreated) {
      return const ProfilePage();
    }

    return const Homepage();
  }
}