import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../model/my_file_model.dart';
import '../../../utils/solconnect.dart';
import '../bloc/home_bloc.dart';
import '../widgets/file_widget.dart';

class MyFilesTab extends StatefulWidget {
  const MyFilesTab({super.key});

  @override
  State<MyFilesTab> createState() => _MyFilesTabState();
}

class _MyFilesTabState extends State<MyFilesTab> {
  List<Widget> fileWidgets = [];
  var solConnect = SolConnect();
  bool isLoading = true;

  bool _isFABVisible = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetMyFilesEvent());
    _scrollController.addListener(_updateFABVisibility);
  }

  Future<void> onUploadFile() async {
    var result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.first.path!);
      if (!mounted) return;
      context.read<HomeBloc>().add(UploadFileEvent(uploadfile: file));
    } else {
      Fluttertoast.showToast(msg: "select a file to upload");
    }
  }

  void delteFile(int index) {
    setState(() {
      fileWidgets.removeAt(index);
    });
  }

  void getFiles(Map<MyFileModel, bool> newFiles) async {
    fileWidgets.clear();
    setState(() {
      int index = 0;
      newFiles.forEach((fileWidget, isUploading) {
        fileWidgets.add(FileWidget(
          file: fileWidget,
          isUploading: isUploading,
          parentContext: context,
          delteFile: delteFile,
          index: index,
        ));
        index++;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is FileUploaded) {
              Fluttertoast.showToast(msg: "file Uploaded");
            }
            if (state is MyFilesRecived) {
              getFiles(state.newFiles);
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(GetMyFilesEvent());
            },
            child: (fileWidgets.isNotEmpty && !isLoading)
                ? RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(GetMyFilesEvent());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: fileWidgets.length,
                      itemBuilder: (context, index) =>
                          fileWidgets[fileWidgets.length - (index + 1)],
                    ),
                  )
                : fileWidgets.isEmpty && !isLoading
                    ? const Center(
                        child: Text("no files uploaded"),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
          )),
    );
  }
}
