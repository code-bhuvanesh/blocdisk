import 'dart:convert';
import 'dart:io';

import 'package:blocdisk/constants.dart';
import 'package:http/http.dart' as http;

class PinataClient {
  static Future<String> uploadFile(File file) async {
    var url = Uri.parse(filePinningURl);
    var request = http.MultipartRequest("POST", url);

    request.headers.addAll({
      'Content-Type': "multipart/form-data",
      'authorization': "Bearer $jwtToken",
      'accept': "application/json",
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        file.path,
      ),
    );
    var response = await request.send();
    var body = jsonDecode(await response.stream.bytesToString())
        as Map<String, dynamic>;
    print(body);
    return body["IpfsHash"] ?? "no hash";
  }

  static Future<String> testAuth() async {
    var url = Uri.parse(authURL);
    var response = await http.get(
      url,
      headers: {
        "accept": "application/json",
        'authorization': "Bearer $jwtToken",
      },
    );

    return response.body;
  }
}