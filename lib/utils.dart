import 'dart:convert';
import 'dart:io';

import 'package:blocdisk/constants.dart';
import 'package:blocdisk/model/file_model.dart';
import 'package:blocdisk/model/user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/contracts.dart';
import 'package:web3dart/web3dart.dart';

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

class SolConnect {
  late http.Client _httpClient;
  late Web3Client _ethClient;
  late DeployedContract _contract;

  bool _contractLoaded = false;

  SolConnect() {
    _httpClient = http.Client();
    _ethClient = Web3Client(infuraURL, _httpClient);
  }

  Future<void> loadContract() async {
    if (!_contractLoaded) {
      String abi = await rootBundle.loadString("assets/abi.json");
      String contractAddress = contractaddress;
      final contract = DeployedContract(
        ContractAbi.fromJson(abi, "disk.sol"),
        EthereumAddress.fromHex(contractAddress),
      ); // disk => sol file name
      _contract = contract;
    }
  }

  Future<List<dynamic>> _query(String funtionName, List<dynamic> args) async {
    await loadContract();
    final ethFuntion = _contract.function(funtionName);
    final result = await _ethClient.call(
      contract: _contract,
      function: ethFuntion,
      params: args,
    );
    return result;
  }

  Future<String> _submit(String funtionName, List<dynamic> args) async {
    await loadContract();
    EthPrivateKey credential = EthPrivateKey.fromHex(
      User.instance.privateKey,
    );
    final ethFunction = _contract.function(funtionName);
    final result = await _ethClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: _contract,
        function: ethFunction,
        parameters: args,
        from: EthereumAddress.fromHex(User.instance.publicKey),
        // maxGas: 100000,
      ),
      chainId: 11155111,
    );
    return result;
  }

  Future<void> getBalance() async {
    var address = EthereumAddress.fromHex(User.instance.publicKey);
    EtherAmount balance = await _ethClient.getBalance(address);
    print("balance");
    print(balance.getValueInUnit(EtherUnit.ether));
  }

  //call sol functions

  Future<void> addFile(File file) async {
    var filehash = await PinataClient.uploadFile(file);
    var result = await _submit("add", [
      EthereumAddress.fromHex(User.instance.publicKey),
      filehash,
      GeneralFuntions.getFileName(file.path),
      BigInt.from(await file.length()),
    ]);
    print("sumbit result : $result");
    print("filename: ${GeneralFuntions.getFileName(file.path)}");
    print("filesize: ${await file.length()}");
    print("filehash: $filehash");
    print("file added");
  }

  Future<List<FileModel>> retriveFiles() async {
    var result = await _query(
        "display", [EthereumAddress.fromHex(User.instance.publicKey)]);
    print(result);
    if (result[0] != null) {
      return (result[0] as List<dynamic>)
          .map((e) => FileModel.fromList(e))
          .toList();
    }
    return [];
  }
}

class GeneralFuntions {
  static String getFileName(String path) {
    return path.substring(path.lastIndexOf("/") + 1);
  }

  static String getFileType(String filename) {
    return filename.substring(filename.lastIndexOf(".") + 1);
  }
}

class SecureStorage {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<String> readSecureData(String key) async {
    String value = "";
    try {
      value = (await _storage.read(key: key)) ?? "";
    } catch (e) {
      print(e);
    }
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print(e);
    }
  }

  Future<void> writeSecureData(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
      );
    } catch (e) {
      print(e);
    }
  }
}
