import 'dart:math';

import 'package:blocdisk/utils.dart';

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

  factory FileModel.fromList(List<dynamic> fileData) {
    return FileModel(
      name: fileData[0],
      size: fileData[1].toInt(),
      type: GeneralFuntions.getFileType(fileData[0]),
    );
  }
}
