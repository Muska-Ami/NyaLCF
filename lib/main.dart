import 'package:flutter/material.dart';
import 'package:nyalcf/ui/auth/login.dart';
import 'package:nyalcf/ui/auth/register.dart';
import 'package:nyalcf/ui/home.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  final title = "NyaLCF";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NyaLCF',
      routes: {
        "/": (context) => Home(title: title),
        "/login": (context) => Login(title: title),
        "/register": (context) => Register(title: title)
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      )
    );
  }
}
