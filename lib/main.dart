import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mhike_app/screen/setting.dart';
import 'package:mhike_app/screen/home_screen.dart';
import 'package:mhike_app/screen/sign_up_screen.dart';
import 'package:mhike_app/screen/sign_in_screen.dart';
import 'package:mhike_app/service/database/database_service.dart';
import 'screen/detail_hike.dart';
import 'models/m_hike.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
  options: const FirebaseOptions(apiKey: 'AIzaSyA7AYqbtRr81omK2roBbzzMLL5sZcBzMjU', appId: '1:91278911576:android:2b583a20153969ad0d822d', messagingSenderId: '91278911576', projectId: 'm-hike-app')) :
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
      // home:AccountPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
