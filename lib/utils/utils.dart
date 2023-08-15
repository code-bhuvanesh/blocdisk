class GeneralFuntions {
  static String getFileName(String path) {
    return path.substring(path.lastIndexOf("/") + 1);
  }

  static String getFileType(String filename) {
    return filename.substring(filename.lastIndexOf(".") + 1);
  }

  static String shortenNames(String filename) {
    if (filename.length > 18) {
      var len = filename.length;
      return "${filename.substring(0, 9)}...${filename.substring(len - 9, len)}";
    }
    return filename;
  }
}
