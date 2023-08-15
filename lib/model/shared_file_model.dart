import 'dart:math';

import 'package:blocdisk/model/my_file_model.dart';
import 'package:blocdisk/utils/utils.dart';

class SharedFileModel extends MyFileModel {
  final String owner;
  final String username;
  SharedFileModel({
    required String name,
    required int size,
    required String type,
    required String hash,
    required this.owner,
    required this.username,
  }) : super(
          name: name,
          size: size,
          type: type,
          hash: hash,
        );

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

  factory SharedFileModel.fromList(List<dynamic> fileData) {
    return SharedFileModel(
      name: fileData[2][0],
      size: fileData[2][1].toInt(),
      type: GeneralFuntions.getFileType(fileData[1][0]),
      hash: fileData[2][2],
      owner: fileData[0].toString(),
      username: fileData[1],
    );
  }
}
