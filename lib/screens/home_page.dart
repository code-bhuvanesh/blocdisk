import 'dart:io';

import 'package:blocdisk/model/file_model.dart';
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
  List<FileWidget> fileWidgets = [];
  List<FileModel> filesList = [];
  var solConnect = SolConnect();

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  Future<void> onUploadFile() async {
    var result = null;
    result = await FilePicker.platform.pickFiles();

    await solConnect.getBalance();
    await solConnect.retriveFiles();

    if (result != null) {
      File file = File(result.files.first.path!);

      var fileSize = await file.length();

      setState(() {
        filesList.add(FileModel.fromFile(file, fileSize));
        fileWidgets.add(FileWidget(
          file: filesList.last,
          isUploading: true,
        ));
      });
      await solConnect.addFile(file);
      await Future.delayed(const Duration(seconds: 15));
      getFiles();
    } else {
      Fluttertoast.showToast(msg: "select a file to upload");
    }
  }

  void getFiles() async {
    var newFiles = await solConnect.retriveFiles();
    setState(() {
      // filesList.addAll(newFiles);
      filesList = newFiles;
      fileWidgets = filesList
          .map((e) => FileWidget(
                file: e,
                isUploading: false,
              ))
          .toList();
    });
  }

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
        itemBuilder: (context, index) =>
            fileWidgets[filesList.length - (index + 1)],
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
  const FileWidget({
    super.key,
    required this.file,
    required this.isUploading,
  });

  final FileModel file;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    print("is uploading $isUploading");
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
            if (isUploading)
              Row(
                children: [
                  const Text(
                    "uploading",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
