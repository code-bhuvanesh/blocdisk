// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class DownloadFileEvent extends HomeEvent {
  final MyFileModel file;
  final int index;

  DownloadFileEvent({
    required this.file,
    required this.index,
  });
}

class DownloadedProgress extends HomeEvent {
  final double progress;
  final int index;

  DownloadedProgress({
    required this.progress,
    required this.index,
  });
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

class GetMyFilesEvent extends HomeEvent {}

class GetSharedFilesEvent extends HomeEvent {}

class ShareFileEvent extends HomeEvent {
  final String filehash;
  final String anotherUserAddress;
  ShareFileEvent({
    required this.filehash,
    required this.anotherUserAddress,
  });
}

class DeleteFileEvent extends HomeEvent {
  final String filehash;
  DeleteFileEvent({
    required this.filehash,
  });
}
