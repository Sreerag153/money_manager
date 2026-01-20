import 'package:flutter/material.dart';
import 'package:money_manager_app/database/database.dart';
import 'package:money_manager_app/home.dart';
import 'package:money_manager_app/pages/profile.dart';
import 'package:money_manager_app/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database.init();
  final prefs=await SharedPreferences.getInstance();
  final bool seenOnboarding=prefs.getBool('seenOnboarding')??false;
  final bool profileCreated=prefs.getBool('profileCreated')??false;
  runApp( MyApp(seenOnboarding: seenOnboarding,profileCreated: profileCreated,));
}


class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final bool profileCreated;
  const MyApp({super.key,required this.seenOnboarding,required this.profileCreated});


  @override
  Widget build(BuildContext context) {
    String initialRoute;
    if (!seenOnboarding){
      initialRoute='/onboard';
    }else if (!profileCreated){
      initialRoute='/profile';
    }
    else{
      initialRoute=Homepage.routeName;
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:initialRoute,
      routes: {
        "/onboard":(context)=> const Onboarding(),
         '/profile': (context) => const ProfilePage(),
        Homepage.routeName:(context)=>Homepage()
      },
    );
  }
}

