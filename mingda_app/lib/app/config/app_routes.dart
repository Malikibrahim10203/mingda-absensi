import 'package:flutter/material.dart';
import 'package:mingda_app/features/auth/presentation/pages/login_page.dart';

class AppRoutes {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => LoginPage());
      default:
        return MaterialPageRoute(builder: (context) => LoginPage());
    }
  }
}
