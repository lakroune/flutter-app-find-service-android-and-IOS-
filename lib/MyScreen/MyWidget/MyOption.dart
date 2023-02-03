import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/login.dart';
import 'package:s5/class/post.dart';

class Mybottonlist extends StatefulWidget {
  int idService;
  Mybottonlist({required this.idService, Key? key}) : super(key: key);

  @override
  State<Mybottonlist> createState() => _MybottonlistState();
}

class _MybottonlistState extends State<Mybottonlist> {
  messageError({required String message, String mes = "non"}) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: message,
      buttons: [
        DialogButton(
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            if (mes == "supprimer") {
              var ok =
                  await artisan.supprimerService(idService: widget.idService);
              if (ok == "success") {
                Fluttertoast.showToast(
                    msg: "Service ${widget.idService}  est supprime",
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.green);
              } else {
                Fluttertoast.showToast(
                    msg: " il ya un erreur",
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.red);
              }

              Navigator.pop(context);
            } else {
              Navigator.pushNamed(context, FirstPage.screanRoute);
            }
          },
        ),
      ],
    ).show();
  }

  String? selectedValue;
  List<String> items = ['supprimer', 'modifier'];
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.more_vert),
        ),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (val) {
          setState(() {
            selectedValue = val as String;
            if (selectedValue != null) {
              if (selectedValue == "supprimer") {
                messageError(
                    message: "Voulez-vous supprimer ce service !!",
                    mes: 'supprimer');
              }
              if (selectedValue == 'modifier') {
                // messageError(message: "message");
                Fluttertoast.showToast(
                    msg: "il y a un erreur au niveur du serveur !!!! ",
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.redAccent);
              }
            }
          });
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 160,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.blue,
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 8),
      ),
    );
  }
}
