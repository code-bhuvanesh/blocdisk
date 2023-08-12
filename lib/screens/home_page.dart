import 'dart:io';

import 'package:blocdisk/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routename = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UploadFile(),
    );
  }
}

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  String uploadResult = "";

  Future<void> onUploadFile() async {
    var result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.first.path!);
      // var response = await PinataClient.uploadFile(file);
      // var response = await PinataClient.testAuth();
      // response = "ipfs hash: $response";
      // print(response);
      // setState(() {
      //   uploadResult = response;
      // });
      var solConnect = SolConnect();
      await solConnect.loadContract();
      await solConnect.addFile(file);
      await solConnect.retriveFiles();
    } else {
      Fluttertoast.showToast(msg: "select a file to upload");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onUploadFile,
            child: const Text("upload file"),
          ),
          const SizedBox(
            height: 100,
          ),
          Text(uploadResult),
        ],
      ),
    );
  }
}
