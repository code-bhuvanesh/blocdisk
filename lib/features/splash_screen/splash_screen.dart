import 'package:blocdisk/features/auth/bloc/auth_bloc.dart';
import 'package:blocdisk/features/login_page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routename = "/splashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomePage.routename, (route) => false);
        } else if (state is UnAuthenticated) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.routename, (route) => false);
        }
      },
      child: const Scaffold(),
    );
  }
}
