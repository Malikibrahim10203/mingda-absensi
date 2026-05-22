import 'package:flutter/material.dart';
import 'package:mingda_app/core/theme/app_colors.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(child: Column(children: [])),
    );
  }
}
