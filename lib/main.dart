import 'package:amp_awesome/screens/confirm.dart';
import 'package:amp_awesome/screens/confirm_reset.dart';
import 'package:amp_awesome/screens/dashboard.dart';
import 'package:amp_awesome/screens/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'helpers/configure_amplify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amp Awesome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/confirm') {
          return PageRouteBuilder(
            // context, animation, animation
            pageBuilder: (_, __, ___) =>
                ConfirmScreen(data: settings.arguments as LoginData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }
        if (settings.name == '/confirm-reset') {
          return PageRouteBuilder(
            // context, animation, animation
            pageBuilder: (_, __, ___) => ConfirmResetScreen(
              data: settings.arguments as LoginData,
            ),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }
        if (settings.name == '/dashboard') {
          return PageRouteBuilder(
            // context, animation, animation
            pageBuilder: (_, __, ___) => DashboardScreen(),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }
        return MaterialPageRoute(builder: (_) => EntryScreen());
      },
    );
  }
}
