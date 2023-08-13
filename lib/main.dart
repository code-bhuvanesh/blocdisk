import 'package:blocdisk/screens/home_page.dart';
import 'package:blocdisk/screens/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlocDisk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routename,
      routes: {
        HomePage.routename: (context) => const HomePage(),
        LoginPage.routename: (context) => const LoginPage(),
      },
    );
  }
}
