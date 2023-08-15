import 'package:blocdisk/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../home_page/home_page.dart';
import '../login_page/login_page.dart';

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
    var h = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          FlutterNativeSplash.remove();

          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomePage.routename, (route) => false);
        } else if (state is UnAuthenticated) {
          FlutterNativeSplash.remove();

          Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.routename, (route) => false);
        }
      },
      child: Scaffold(
        body: Container(
          child: Center(
            child: Container(
              // height: 155,
              // width: 155,
              child: Image.asset(
                "assets/icons/app_icon.png",
                height: h / 5.5,
                width: h / 5.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
