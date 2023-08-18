import 'package:flutter/material.dart';

class AddressPopupMenu extends StatelessWidget {
  AddressPopupMenu({super.key});

  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Dialog(
      child: SizedBox(
        height: h / 3.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Add User To Share",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            textField(controller: textController, hintText: "public key"),
            ElevatedButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    Navigator.of(context).pop<String>(textController.text);
                  }
                  // else{

                  //   Navigator.of(context).pop();
                  // }
                },
                child: Text("share"))
          ],
        ),
      ),
    );
  }

  textField({
    required TextEditingController controller,
    required String hintText,
  }) {
    var normalTextBoxDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: controller,
        decoration: normalTextBoxDecoration,
      ),
    );
  }
}
