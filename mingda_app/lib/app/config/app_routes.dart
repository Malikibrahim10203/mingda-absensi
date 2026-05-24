import 'package:flutter/material.dart';
import 'package:mingda_app/features/auth/presentation/pages/login_page.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mingda_app/features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginPage());
      case '/dashboard':
        return MaterialPageRoute(builder: (context) => DashboardPage());
      default:
        return MaterialPageRoute(builder: (context) => LoginPage());
    }
  }
}
