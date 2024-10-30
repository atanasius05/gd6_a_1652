import 'package:flutter/material.dart';
import 'package:gd6_a_1652/database/sql_helper.dart';
import 'package:gd6_a_1652/entity/gadget.dart';

class inputPageGadget extends StatefulWidget {
  const inputPageGadget(
      {super.key,
      required this.title,
      required this.id,
      required this.name,
      required this.merk});

  final String? title, name, merk;
  final int? id;

  @override
  State<inputPageGadget> createState() => _InputPageGadgetState();
}

class _InputPageGadgetState extends State<inputPageGadget> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerMerk = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerName.text = widget.name!;
      controllerMerk.text = widget.merk!;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text("INPUT GADGET"),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.blue),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), 
                ),
              ),
              cursorColor: Colors.blue, 
            ),
            SizedBox(height: 24),
            TextField(
              controller: controllerMerk,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Merk',
                labelStyle: TextStyle(color: Colors.blue), 
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), 
                ),
              ),
              cursorColor: Colors.blue,
            ),
            SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
              onPressed: () async {
                if (widget.id == null) {
                  await addGadget();
                } else {
                  await editGadget(widget.id!);
                }
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  Future<void> addGadget() async {
    await SQLHelper.addGadget(controllerName.text, controllerMerk.text);
  }

  Future<void> editGadget(int id) async {
    await SQLHelper.editGadget(id, controllerName.text, controllerMerk.text);
  }
}