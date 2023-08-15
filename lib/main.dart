import 'package:blocdisk/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/home_page/bloc/home_bloc.dart';
import 'features/home_page/home_page.dart';
import 'features/login_page/bloc/login_bloc.dart';
import 'features/login_page/login_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(BlocProvider(
    create: (context) => AuthBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Route pageTransition(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
    );
  }

  Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routename:
        return pageTransition(
          BlocProvider(
            create: (context) => HomeBloc(),
            child: const HomePage(),
          ),
        );
      case LoginPage.routename:
        return pageTransition(BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginPage(),
        ));
    }
    return pageTransition(const SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlocDisk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routename,
      onGenerateRoute: routes,
    );
  }
}


// ToDo: make the download as a background process