import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:blocdisk/model/my_file_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../model/shared_file_model.dart';
import '../../../utils/solconnect.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<DownloadFileEvent>(downloadFileEvent);
    on<DownloadedProgress>(downloadedProgress);
    on<OpenFileEvent>(openFileEvent);
    on<UploadFileEvent>(uploadFileEvent);
    on<GetMyFilesEvent>(getMyFilesEvent);
    on<GetSharedFilesEvent>(getSharedFilesEvent);
    on<ShareFileEvent>(shareFileEvent);
    on<DeleteFileEvent>(deleteFileEvent);
  }

  var solConnect = SolConnect();

  Future<FutureOr<void>> downloadFileEvent(
    DownloadFileEvent event,
    Emitter<HomeState> emit,
  ) async {
    var fileModel = event.file;
    File file = File(downloadLocation + fileModel.name);
    if (!await file.exists()) {
      var fileModel = event.file;
      int total = 0, received = 0;
      late http.StreamedResponse response;
      final List<int> bytes = [];
      response = await http.Client()
          .send(http.Request('GET', Uri.parse(downloadUrl + fileModel.hash)));
      total = response.contentLength ?? 0;
      // emit(FileDownloadingProgress(progress: total ~/ received));
      await for (final value in response.stream) {
        received += value.length;
        bytes.addAll(value);
        add(DownloadedProgress(progress: received / total));
        print("downloaded: $received / $total");
      }
      final file = File(downloadLocation + fileModel.name);
      await file.writeAsBytes(bytes);
      emit(FileFinishedDownloading(filePath: file.path));
    } else {
      print("file already donwnloaded");
    }
  }

  void openFile(String path) {
    print(path);
  }

  FutureOr<void> downloadedProgress(
    DownloadedProgress event,
    Emitter<HomeState> emit,
  ) {
    emit(FileDownloadingProgress(progress: event.progress));
    emit(HomeInitial());
  }

  FutureOr<void> openFileEvent(
    OpenFileEvent event,
    Emitter<HomeState> emit,
  ) {
    OpenFile.open("$downloadLocation/${event.filename}");
    emit(FileOpened());
  }

  FutureOr<void> uploadFileEvent(
    UploadFileEvent event,
    Emitter<HomeState> emit,
  ) async {
    await solConnect.getBalance();
    await solConnect.readMyFiles();
    await solConnect.addFile(event.uploadfile);
    await Future.delayed(const Duration(seconds: 15));
    add(GetMyFilesEvent());
    emit(FileUploaded(result: "uploaded"));
  }

  Future<FutureOr<void>> getMyFilesEvent(
    GetMyFilesEvent event,
    Emitter<HomeState> emit,
  ) async {
    var newFiles = await solConnect.readMyFiles();
    emit(MyFilesRecived(newFiles: newFiles));
  }

  FutureOr<void> getSharedFilesEvent(
    GetSharedFilesEvent event,
    Emitter<HomeState> emit,
  ) async {
    var newSharedFiles = await solConnect.readSharedFiles();
    emit(SharedFilesRecived(newFiles: newSharedFiles));
  }

  FutureOr<void> shareFileEvent(
    ShareFileEvent event,
    Emitter<HomeState> emit,
  ) async {
    var sharedFiles = await solConnect.readSharedFiles();
    emit(SharedFilesRecived(newFiles: sharedFiles));
  }

  FutureOr<void> deleteFileEvent(
    DeleteFileEvent event,
    Emitter<HomeState> emit,
  ) async {
    await solConnect.deleteFile(event.filehash);
    emit(FileDeleted());
  }
}
