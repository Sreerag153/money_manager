import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager_app/provider/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/pages/catagory.dart';
import 'package:money_manager_app/pages/event.dart';
import 'package:money_manager_app/pages/homepage.dart';
import 'package:money_manager_app/pages/wallet.dart';
import 'package:money_manager_app/widget/colors.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    final pages = const [
      HomeContent(),
      CategoryScreen(),
      Wallet(),
      EventPage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: pages[navProvider.currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff1E293B),
          borderRadius: BorderRadius.circular(22),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xff6366F1),
          selectedIndex: navProvider.currentIndex,
          onDestinationSelected: (index) {
            context.read<NavigationProvider>().changeIndex(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category, color: Colors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.wallet_outlined),
              selectedIcon: Icon(Icons.wallet, color: Colors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event, color: Colors.white),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}