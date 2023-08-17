import 'dart:convert';
import 'dart:io';

import 'package:blocdisk/constants.dart';
import 'package:blocdisk/model/my_file_model.dart';
import 'package:blocdisk/model/shared_file_model.dart';
import 'package:blocdisk/model/user.dart';
import 'package:blocdisk/utils/pinata_client.dart';
import 'package:blocdisk/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

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

  Future<String> _checkTrasactionStatus(String transactionHash) async {
    Uri url = Uri.parse(
      "$etherscanUrl?module=transaction&action=gettxreceiptstatus&txhash=$transactionHash&apikey=$etherscanApiKey",
    );
    var response = await http.get(url);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    jsonResponse = jsonResponse["result"] as Map<String, dynamic>;
    if (jsonResponse["status"] == "") {
      await Future.delayed(const Duration(seconds: 1));
      print("checking trasacation again......");
      _checkTrasactionStatus(transactionHash);
    }
    print("tranasction result : ${response.body}");
    return jsonResponse["status"];
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

    // _ethClient
    //     .events(FilterOptions.events(
    //         contract: _contract,
    //         event: ContractEvent(false, "fileUploaded", [])))
    //     .listen((event) {
    //   print(event);
    //   print("file stored");
    // });
    // print("file upload id: $result");
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
    var result = await _submit("addFile", [
      EthereumAddress.fromHex(User.instance.publicKey),
      filehash,
      GeneralFuntions.getFileName(file.path),
      BigInt.from(await file.length()),
    ]);

    print("add file id : $result");
    await _checkTrasactionStatus(result);
    print("filename: ${GeneralFuntions.getFileName(file.path)}");
    print("filesize: ${await file.length()}");
    print("filehash: $filehash");
    print("file added");
  }

  Future<List<MyFileModel>> readMyFiles() async {
    var result = await _query("readMyFiles", [
      EthereumAddress.fromHex(User.instance.publicKey),
    ]);
    print(result);
    if (result[0] != null) {
      return (result[0] as List<dynamic>)
          .map((e) => MyFileModel.fromList(e))
          .toList();
    }
    return [];
  }

  Future<List<SharedFileModel>> readSharedFiles() async {
    var result = await _query("readSharedFiles", [
      EthereumAddress.fromHex(User.instance.publicKey),
    ]);
    print("shared files: $result");
    if (result[0] != null) {
      return (result[0] as List<dynamic>)
          .map((e) => SharedFileModel.fromList(e))
          .toList();
    }
    return [];
  }

  Future<void> shareFile(String filehash, String anotherUser) async {
    if (User.instance.publicKey == anotherUser) {
      // throw Exception("you cannot share to yourself");
      Fluttertoast.showToast(msg: "you cannot share to yourself");
      return;
    }
    var result = await _submit("giveAnotherUserAcess", [
      EthereumAddress.fromHex(User.instance.publicKey),
      EthereumAddress.fromHex(anotherUser),
      filehash
    ]);

    print("share file id: $result");
    Fluttertoast.showToast(msg: "file shared");
  }

  Future<void> deleteFile(String filehash) async {
    var result = await _submit("deleteFile", [
      EthereumAddress.fromHex(User.instance.publicKey),
      filehash,
    ]);
    print("delete file id: $result");
    Fluttertoast.showToast(msg: "file will be deleted within 20sec");
  }
}
