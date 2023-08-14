import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContextMenu extends PopupMenuEntry<int> {
  @override
  double height = 100;

  ContextMenu({super.key});
  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().

  @override
  bool represents(int? value) => value == 1 || value == 2;

  @override
  PlusMinusEntryState createState() => PlusMinusEntryState();
}

class PlusMinusEntryState extends State<ContextMenu> {
  void _share() {
    // This is how you close the popup menu and return user selection.
    Navigator.pop<int>(context, 1);
  }

  void _delete() {
    Navigator.pop<int>(context, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: _share,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: Text('share')),
              Icon(
                Icons.share,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _delete,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: Text('delete')),
              Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
