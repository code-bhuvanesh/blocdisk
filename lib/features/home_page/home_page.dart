import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/file_model.dart';
import '../../utils.dart';
import 'bloc/home_bloc.dart';
import 'widgets/file_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routename = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> fileWidgets = [];
  List<FileModel> filesList = [];
  var solConnect = SolConnect();

  bool _isFABVisible = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    askPermission();
    context.read<HomeBloc>().add(GetFielsEvent());
    _scrollController.addListener(_updateFABVisibility);
    super.initState();
  }

  Future<void> askPermission() async {
    try {
      if (await Permission.storage.request().isGranted) {}
      if (await Permission.manageExternalStorage.request().isGranted) {}
    } on Exception catch (e) {
      print("error: $e");
    }
  }

  Future<void> onUploadFile() async {
    var result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.first.path!);
      if (mounted) {
        context.read<HomeBloc>().add(UploadFileEvent(uploadfile: file));
      }
      var fileSize = await file.length();

      setState(() {
        filesList.add(FileModel.fromFile(file, fileSize));
        fileWidgets.add(BlocProvider(
          create: (context) => HomeBloc(),
          child: FileWidget(
            file: filesList.last,
            isUploading: true,
            parentContext: context,
          ),
        ));
      });
    } else {
      Fluttertoast.showToast(msg: "select a file to upload");
    }
  }

  void getFiles() async {
    setState(() {
      // filesList.addAll(newFiles);
      fileWidgets = filesList
          .map(
            (e) => BlocProvider(
              create: (context) => HomeBloc(),
              child: FileWidget(
                file: e,
                isUploading: false,
                parentContext: context,
              ),
            ),
          )
          .toList();
      isLoading = false;
    });
  }

  void _updateFABVisibility() {
    print(_scrollController.position);
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // Scrolled to the top
        setState(() {
          _isFABVisible = true;
        });
      } else {
        // Scrolled to the bottom
        setState(() {
          _isFABVisible = false;
        });
      }
    } else {
      setState(() {
        _isFABVisible = true;
      });
    }
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is FileUploaded) {
          Fluttertoast.showToast(msg: "file Uploaded");
        }
        if (state is FilesRecived) {
          filesList = state.newFiles;
          getFiles();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Files",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        body: (filesList.isNotEmpty && !isLoading)
            ? ListView.builder(
                controller: _scrollController,
                itemCount: filesList.length,
                itemBuilder: (context, index) =>
                    fileWidgets[filesList.length - (index + 1)],
              )
            : filesList.isEmpty
                ? const Center(
                    child: Text("no files uploaded"),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
        floatingActionButton: Visibility(
          visible: _isFABVisible,
          child: AnimatedOpacity(
            opacity: _isFABVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: FloatingActionButton(
              onPressed: onUploadFile,
              child: const Icon(
                Icons.add,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
