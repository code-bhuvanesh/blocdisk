import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String routename = "/loginpage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  // var _session, _uri;

  // loginUsingMetamask(BuildContext context) async {
  //   if (!connector.connected) {
  //     try {
  //       var session = await connector.createSession(onDisplayUri: (uri) async {
  //         _uri = uri;
  //         await launchUrlString(uri, mode: LaunchMode.externalApplication);
  //       });
  //       setState(() {
  //         _session = session;
  //       });
  //     } catch (exp) {
  //       print(exp);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login Page'),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // SizedBox(
          //   height: 300,
          //   width: double.infinity,
          //   // child: Image.network(
          //   //   "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/MetaMask_Fox.svg/1024px-MetaMask_Fox.svg.png",
          //   //   fit: BoxFit.contain,
          //   // ),
          // ),
          ElevatedButton(
            onPressed: () => {},
            child: const Text("Connect with Metamask"),
          ),
        ],
      ),
    );
  }
}
