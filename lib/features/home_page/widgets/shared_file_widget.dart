import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';
import '../../../model/shared_file_model.dart';
import '../bloc/home_bloc.dart';

class SharedFileWidget extends StatefulWidget {
  const SharedFileWidget({
    super.key,
    required this.file,
    required this.isUploading,
    required this.parentContext,
  });

  final SharedFileModel file;
  final bool isUploading;
  final BuildContext parentContext;

  @override
  State<SharedFileWidget> createState() => _SharedFileWidgetState();
}

class _SharedFileWidgetState extends State<SharedFileWidget> {
  bool isDownloading = false;
  bool isDownloaded = false;
  double downloadingPercentage = 0.0;

  Future<void> checkIfFileExist() async {
    if (await File(downloadLocation + widget.file.name).exists()) {
      setState(() {
        isDownloaded = true;
      });
    }
  }


 

  void downloadOrOpenFile() {
    if (isDownloaded) {
      context.read<HomeBloc>().add(
            OpenFileEvent(
              filename: widget.file.name,
            ),
          );
    } else {
      context.read<HomeBloc>().add(
            DownloadFileEvent(
              file: widget.file,
            ),
          );
      setState(() {
        isDownloading = true;
      });
    }
  }

  @override
  void initState() {
    checkIfFileExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("is uploading ${widget.isUploading}");
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is FileDownloadingProgress) {
          print("downloading : ${state.progress}");
          setState(() {
            isDownloading = true;
            downloadingPercentage = state.progress;
          });
        }
        if (state is FileFinishedDownloading) {
          setState(() {
            isDownloading = false;
            isDownloaded = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: downloadOrOpenFile,
          child: Card(
            elevation: 3,
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
                        Text(widget.file.name),
                        Text(
                          widget.file.getFileSize(),
                        ),
                      ],
                    ),
                  ],
                ),
                widget.isUploading
                    ? Row(
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
                            margin: const EdgeInsets.only(right: 15),
                            width: 20,
                            height: 20,
                            child:
                                const CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      )
                    : (!isDownloading && !isDownloaded)
                        ? const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.download_rounded,
                            ),
                          )
                        : (isDownloading && !isDownloaded)
                            ? Container(
                                margin: const EdgeInsets.only(right: 15),
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  backgroundColor: (downloadingPercentage == 0)
                                      ? null
                                      : Colors.grey,
                                  value: (downloadingPercentage == 0)
                                      ? null
                                      : downloadingPercentage,
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(right: 15),
                                width: 20,
                                height: 20,
                                child: const Icon(Icons.check),
                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
