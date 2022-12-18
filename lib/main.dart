import 'package:flutter/material.dart';
import 'package:no_banjir/add.dart';
import 'package:no_banjir/dashboard.dart';
import 'package:no_banjir/detail.dart';
import 'package:no_banjir/log.dart';
import 'package:no_banjir/login.dart';
import 'package:no_banjir/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/dashboard': (context) => DashboardPage(),
        '/detail': (context) => DetailPage(),
        '/log': (context) => LogPage(),
        '/add': (context) => AddLokasiPage(),
      },
    );
  }
}
