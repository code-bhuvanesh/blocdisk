

class GeneralFuntions {
  static String getFileName(String path) {
    return path.substring(path.lastIndexOf("/") + 1);
  }

  static String getFileType(String filename) {
    return filename.substring(filename.lastIndexOf(".") + 1);
  }
}

