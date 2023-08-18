import 'dart:io';
import 'dart:math';

import 'package:blocdisk/utils/utils.dart';

class MyFileModel {
  final String name;
  final int size;
  final String type;
  final String hash;
  MyFileModel({
    required this.name,
    required this.size,
    required this.type,
    required this.hash,
  });

  String getFileSize() {
    const sizeConst = 1024;
    if (size < pow(sizeConst, 1)) {
      return "${size.toDouble()} B";
    } else if (size < pow(sizeConst, 2)) {
      return "${(size / pow(sizeConst, 1)).toStringAsFixed(2)} kB";
    } else if (size < pow(sizeConst, 3)) {
      return "${(size / pow(sizeConst, 2)).toStringAsFixed(2)} MB";
    } else if (size < pow(sizeConst, 4)) {
      return "${(size / pow(sizeConst, 3)).toStringAsFixed(2)} GB";
    } else {
      return "${(size / pow(sizeConst, 4)).toStringAsFixed(2)} TB";
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'size': size,
      'type': type,
    };
  }

  factory MyFileModel.fromList(List<dynamic> fileData) {
    return MyFileModel(
      name: fileData[0],
      size: fileData[1].toInt(),
      type: GeneralFuntions.getFileType(fileData[0]),
      hash: fileData[2],
    );
  }

  factory MyFileModel.fromFile(File file, int fileSize) {
    var filename = GeneralFuntions.getFileName(file.path);
    var filetype = GeneralFuntions.getFileType(filename);
    return MyFileModel(
      name: filename,
      size: fileSize,
      type: filetype,
      hash: "",
    );
  }
}
