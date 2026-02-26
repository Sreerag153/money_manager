import 'package:flutter/material.dart';
import 'package:money_manager_app/provider/catagory_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/app_state.dart';
import 'package:money_manager_app/database/database.dart';
import 'package:money_manager_app/root_screen.dart';
import 'package:money_manager_app/provider/navigation_provider.dart';
import 'package:money_manager_app/provider/profile_provider.dart';
import 'package:money_manager_app/provider/transaction_provider.dart';
import 'package:money_manager_app/provider/event_provider.dart';
import 'package:money_manager_app/provider/wallet_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Database.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()..init()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()..loadProfile()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Manager',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff0F172A),
        primarySwatch: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff0F172A),
          elevation: 0,
        ),
      ),
      home: const RootScreen(),
    );
  }
}