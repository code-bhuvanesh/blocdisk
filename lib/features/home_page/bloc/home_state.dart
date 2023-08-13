// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class FileDownloadingProgress extends HomeState {
  final double progress;

  FileDownloadingProgress({required this.progress});
}

class FileFinishedDownloading extends HomeState {
  final String filePath;
  FileFinishedDownloading({required this.filePath});
}

class FileOpened extends HomeState {}

class FilesRecived extends HomeState {
  final List<FileModel> newFiles;
  FilesRecived({
    required this.newFiles,
  });
}

class FileUploaded extends HomeState {
  final String result;

  FileUploaded({required this.result});
}
