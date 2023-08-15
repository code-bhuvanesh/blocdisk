// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class FileDownloadingProgress extends HomeState {
  final double progress;
  final int index;

  FileDownloadingProgress({
    required this.progress,
    required this.index,
  });
}

class FileFinishedDownloading extends HomeState {
  final String filePath;
  final int index;

  FileFinishedDownloading({
    required this.index,
    required this.filePath,
  });
}

class FileOpened extends HomeState {}

class MyFilesRecived extends HomeState {
  final List<MyFileModel> newFiles;
  MyFilesRecived({
    required this.newFiles,
  });
}

class SharedFilesRecived extends HomeState {
  final List<SharedFileModel> newFiles;
  SharedFilesRecived({
    required this.newFiles,
  });
}

class FileUploaded extends HomeState {
  final String result;

  FileUploaded({required this.result});
}

class FileShared extends HomeState {}

class FileDeleted extends HomeState {}
