// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:blocdisk/features/home_page/widgets/enterUserAddressMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blocdisk/features/home_page/widgets/context_menu.dart';

import '../../../constants.dart';
import '../../../model/my_file_model.dart';
import '../bloc/home_bloc.dart';

class FileWidget extends StatefulWidget {
  const FileWidget({
    Key? key,
    required this.file,
    required this.isUploading,
    required this.parentContext,
    required this.delteFile,
  }) : super(key: key);

  final MyFileModel file;
  final bool isUploading;
  final BuildContext parentContext;
  final void Function() delteFile;

  @override
  State<FileWidget> createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
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

  late Offset _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<void> _shareFile() async {
    String? anotherUserAddress = await showDialog(
      context: context,
      builder: (context) => AddressPopupMenu(),
    );
    if (anotherUserAddress != null) {
      if (mounted) {
        context.read<HomeBloc>().add(
              ShareFileEvent(
                filehash: widget.file.hash,
                anotherUserAddress: anotherUserAddress,
              ),
            );
      }
    }
  }

  void _deleteFile() {
    context.read<HomeBloc>().add(DeleteFileEvent(filehash: widget.file.hash));
    widget.delteFile();
  }

  Future<void> _openPopUpMenu() async {
    if (widget.isUploading) return;
    var outValue = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        _tapPosition & const Size(0, 0), // smaller rect, the touch area
        const Offset(0, -20) &
            const Size(0, 0), // Bigger rect, the entire screen
      ),
      items: <PopupMenuEntry<int>>[ContextMenu()],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
    );
    switch (outValue) {
      case 1:
        _shareFile();
      case 2:
        _deleteFile();
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
          onTap: () {
            HapticFeedback.lightImpact();
            downloadOrOpenFile();
          },
          onLongPress: () {
            HapticFeedback.heavyImpact();
            _openPopUpMenu();
          },
          onTapDown: _storePosition,
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
