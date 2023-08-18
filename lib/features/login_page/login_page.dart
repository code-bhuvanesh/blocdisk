import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../styles/styles.dart';
import '../home_page/home_page.dart';
import 'bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routename = "/loginpage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _publicKeyTextController = TextEditingController();
  final _privateKeyTextController = TextEditingController();

  // final _publicKeyTextController =
  //     TextEditingController(text: "0xff4ce0D8aCB7C9FF642De0ca1df972E59c6636d5");

  // final _privateKeyTextController = TextEditingController(
  //     text: "8448142232d2f7b498fca1855ab4f8f59fce730cdff824f9f19fb04147e10a5b");

  var isLoginLoading = false;

  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).padding.top;
    // var h = MediaQuery.of(context).size.height;
    // var w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        Container(
          height: double.infinity,
          padding: EdgeInsets.only(top: topPadding),
          child: SingleChildScrollView(
            child: Column(children: [
              logoWidget(),
              greetingText(),
              emptySpace(15),
              loginTextField(
                controller: _publicKeyTextController,
                hintText: "Public Key",
              ),
              loginTextField(
                controller: _privateKeyTextController,
                hintText: "Private key",
              ),
              emptySpace(15),
              loginButton(
                "Login",
              ),
              BlocListener<LoginBloc, LoginState>(
                  listener: (loginContext, state) {
                    if (state is LoginLoading) {
                      setState(() {
                        isLoginLoading = true;
                      });
                    }
                    if (state is LoginSucessfull) {
                      setState(() {
                        isLoginLoading = false;
                      });
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        HomePage.routename,
                        (route) => false,
                      );
                    } else if (state is LoginFailure) {
                      setState(() {
                        isLoginLoading = false;
                        Fluttertoast.showToast(
                            msg: "username or password is wrong!");
                      });
                    }
                  },
                  child: Container()),
            ]),
          ),
        ),
        if (isLoginLoading)
          Container(
            color: const Color.fromARGB(36, 0, 0, 0),
            child: const Center(child: CircularProgressIndicator()),
          )
      ]),
    );
  }

  loginButton(String text) {
    return ElevatedButton(
      onPressed: loginButtonOnPressed,
      onLongPress: () => loginButtonOnPressed(longPressed: true),
      child: Text(" $text "),
    );
  }

  logoWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: const Center(
        child: Text(
          "Bloc Disk",
          style: AppTextStyles.logoTextStyle,
        ),
      ),
    );
  }

  greetingText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: const Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome,",
              style: AppTextStyles.titleTextStyle,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "login to continue.",
              style: AppTextStyles.subTitleTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  emptySpace(double space) {
    return Padding(
      padding: EdgeInsets.only(top: space),
    );
  }

  loginTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    var normalTextBoxDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: controller,
        decoration: normalTextBoxDecoration,
      ),
    );
  }

  void loginButtonOnPressed({bool longPressed = false}) {
    print("loginPressed");
    context.read<LoginBloc>().add(
          LoginButtonPressed(
            publicKey: _publicKeyTextController.text,
            privateKey: _privateKeyTextController.text,
          ),
        );
  }
}
