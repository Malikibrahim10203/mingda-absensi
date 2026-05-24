import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/features/splash/presentation/blocs/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SplashBloc>().add(AppStarted());

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SuccessSplashState) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(body: CircularProgressIndicator()),
    );
  }
}
