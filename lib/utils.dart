import 'dart:convert';
import 'dart:io';

import 'package:blocdisk/constants.dart';
import 'package:flutter/services.dart';
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

  SolConnect() {
    _httpClient = http.Client();
    _ethClient = Web3Client(infuraURL, _httpClient);
  }

  Future<void> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x898208CEe3A1B7bBE198e48D2310C81482411C7b";
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "disk.sol"),
      EthereumAddress.fromHex(contractAddress),
    ); // disk => sol file name
    _contract = contract;
  }

  Future<List<dynamic>> _query(String funtionName, List<dynamic> args) async {
    final ethFuntion = _contract.function(funtionName);
    final result = await _ethClient.call(
      contract: _contract,
      function: ethFuntion,
      params: args,
    );
    return result;
  }

  Future<String> _submit(String funtionName, List<dynamic> args) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(
      privateAddress,
    );
    final ethFunction = _contract.function(funtionName);
    final result = await _ethClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: _contract,
        function: ethFunction,
        parameters: args,
        // maxGas: 100000,
      ),
      chainId: 11155111,
    );
    return result;
  }

  //call sol functions

  Future<void> addFile(File file) async {
    var filehash = await PinataClient.uploadFile(file);
    await _submit("add", [EthereumAddress.fromHex(myaddress), filehash]);
    print("file: ${file.path}");
    print("filehash: $filehash");
    print("file added");
  }

  Future<String> retriveFiles() async {
    var result = await _query("display", [EthereumAddress.fromHex(myaddress)]);
    print("result.............");
    print(result);
    print("end result.............");
    return "";
  }
}
