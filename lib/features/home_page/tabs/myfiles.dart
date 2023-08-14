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
  List<MyFileModel> filesList = [];
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
      if (mounted) {
        context.read<HomeBloc>().add(UploadFileEvent(uploadfile: file));
      }
      var fileSize = await file.length();

      setState(() {
        filesList.add(MyFileModel.fromFile(file, fileSize));
        // fileWidgets.add(BlocProvider(
        //   create: (context) => HomeBloc(),
        //   child: FileWidget(
        //     file: filesList.last,
        //     isUploading: true,
        //     parentContext: context,
        //     delteFile: () => delteFile(fileWidgets.length),
        //   ),
        // ));
        fileWidgets.add(FileWidget(
          file: filesList.last,
          isUploading: true,
          parentContext: context,
          delteFile: () => delteFile(fileWidgets.length),
        ));
      });
    } else {
      Fluttertoast.showToast(msg: "select a file to upload");
    }
  }

  
  void delteFile(int index) {
    setState(() {
      fileWidgets.removeAt(index);
      filesList.removeAt(index);
    });
    getFiles();
  }

  void getFiles() async {
    setState(() {
      // filesList.addAll(newFiles);
      // fileWidgets = filesList
      //     .map(
      //       (e) => BlocProvider(
      //         create: (context) => HomeBloc(),
      //         child: FileWidget(
      //           file: e,
      //           isUploading: false,
      //           parentContext: context,
      //           delteFile: () => delteFile(),
      //         ),
      //       ),
      //     )
      //     .toList();
      fileWidgets = filesList
          .asMap()
          .entries
          .map(
            (entry) => FileWidget(
              file: entry.value,
              isUploading: false,
              parentContext: context,
              delteFile: () => delteFile(entry.key),
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
              filesList = state.newFiles;
              getFiles();
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(GetMyFilesEvent());
            },
            child: (filesList.isNotEmpty && !isLoading)
                ? RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(GetMyFilesEvent());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: filesList.length,
                      itemBuilder: (context, index) =>
                          fileWidgets[filesList.length - (index + 1)],
                    ),
                  )
                : filesList.isEmpty && !isLoading
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
