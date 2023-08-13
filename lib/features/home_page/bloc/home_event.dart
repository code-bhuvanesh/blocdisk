// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class DownloadFileEvent extends HomeEvent {
  final FileModel file;

  DownloadFileEvent({required this.file});
}

class DownloadedProgress extends HomeEvent {
  final double progress;

  DownloadedProgress({required this.progress});
}

class OpenFileEvent extends HomeEvent {
  final String filename;
  OpenFileEvent({required this.filename});
}

class UploadFileEvent extends HomeEvent {
  final File uploadfile;
  UploadFileEvent({
    required this.uploadfile,
  });
}
class GetFielsEvent extends HomeEvent{
 
}
