//import 'package:doane/controller/login.dart';
import 'package:doane/controller/login.dart';
import 'package:doane/firebase_options.dart';
import 'package:doane/front/indexmain.dart';
import 'package:doane/front/singlepage.dart';
import 'package:doane/page/homepage.dart';
import 'package:doane/page_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doane',
        theme: ThemeData(
          fontFamily: GoogleFonts.roboto().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6295A2)),
          useMaterial3: true,
        ),
        home: const AuthenticationWrapper());
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const Mainpage();
        }
      },
    );
  }
}
