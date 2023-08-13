// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

class FileModel {
  final String name;
  final int size;
  final String type;
  FileModel({
    required this.name,
    required this.size,
    required this.type,
  });

  String getFileSize() {
    const sizeConst = 1024;
    if (size < pow(sizeConst, 1)) {
      return "${size.toDouble()} B";
    } else if (size < pow(sizeConst, 2)) {
      return "${size / pow(sizeConst, 1)} kB";
    } else if (size < pow(sizeConst, 3)) {
      return "${size / pow(sizeConst, 2)} MB";
    } else if (size < pow(sizeConst, 4)) {
      return "${size / pow(sizeConst, 3)} GB";
    } else {
      return "${size / pow(sizeConst, 4)} TB";
    }
  }
}
