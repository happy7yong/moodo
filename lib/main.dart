import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodo/component/MonthSelectorDialog.dart';
import 'package:moodo/component/calendarGrid.dart';
import 'package:moodo/component/flowerPotImage.dart';
import 'package:moodo/screen/homePage.dart';
import 'package:moodo/screen/loginPage.dart';
import 'package:moodo/service/diary_service.dart';
import 'package:moodo/utils/firebase_options.dart';
import 'service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'screen/diaryPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => DiaryService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'leeseoyun',
      ),
      home: user == null ? const LoginPage() : const HomePage(),
    );
  }
}

/// 로그인 페이지
