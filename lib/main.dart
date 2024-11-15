import 'package:flutter/material.dart';
import 'package:my_apk/page/authentification/login.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Page',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(0, 233, 197, 197)),
          useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
