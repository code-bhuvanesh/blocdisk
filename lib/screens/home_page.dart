import 'dart:io';

import 'package:blocdisk/model/file_model.dart';
import 'package:blocdisk/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routename = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> onUploadFile() async {
    var result = null;
    // result = await FilePicker.platform.pickFiles();
    var solConnect = SolConnect();
    await solConnect.loadContract();

    await solConnect.getBalance();
    await solConnect.retriveFiles();

    if (result != null) {
      File file = File(result.files.first.path!);
      // var response = await PinataClient.uploadFile(file);
      // var response = await PinataClient.testAuth();
      // response = "ipfs hash: $response";
      // print(response);
      // setState(() {
      //   uploadResult = response;
      // });

      await solConnect.addFile(file);
      await Future.delayed(Duration(seconds: 5));
      await solConnect.retriveFiles();
    } else {
      Fluttertoast.showToast(msg: "select a file to upload");
    }
  }

  List<FileModel> filesList = [
    FileModel(
      name: "filename",
      size: 134432213,
      type: "jpg",
    ),
    FileModel(
      name: "filename",
      size: 134432213,
      type: "jpg",
    ),
    FileModel(
      name: "filename",
      size: 134432213,
      type: "jpg",
    ),
    FileModel(
      name: "filename",
      size: 134432213,
      type: "jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BlocDisk",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: filesList.length,
        itemBuilder: (context, index) => FileWidget(file: filesList[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onUploadFile,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class FileWidget extends StatelessWidget {
  final FileModel file;
  const FileWidget({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset("assets/icons/file_icon.png"),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(file.name),
                Text(
                  file.getFileSize(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
