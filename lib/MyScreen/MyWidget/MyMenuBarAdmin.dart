import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/class/post.dart';

class MenuBarAdmin extends StatefulWidget {
  const MenuBarAdmin({Key? key}) : super(key: key);

  @override
  State<MenuBarAdmin> createState() => _MenuBarAdminState();
}

class _MenuBarAdminState extends State<MenuBarAdmin> {
  operationError(String message) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: message,
      buttons: [
        DialogButton(
          child: const Text(
            "déconnecter",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await client.deconnecter();
            Navigator.pushNamed(context, FirstPage.screanRoute);
          },
        ),
      ],
    ).show();
  }

  List<IconMenu> deconnecter = [
    IconMenu(
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
        nom: "Deconnecter")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: const Icon(
              Icons.list,
              color: Colors.white,
              size: 35,
            ),
            customItemsIndexes: const [1],
            customItemsHeight: 8,
            items: [
               const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
              const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
              ...deconnecter.map(
                (e) => DropdownMenuItem<String>(
                  value: e.nom,
                  child: Row(
                    children: [
                      e.icon,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.nom,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
             
            ],
            onChanged: (value) {
              print(value);
              if (value == "Deconnecter") {
                operationError("voullez-vous vous déconnecter ?");
              }
            },
            itemHeight: 48,
            itemPadding: const EdgeInsets.only(left: 16, right: 16),
            dropdownWidth: 190,
            dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.blueAccent,
            ),
            dropdownElevation: 8,
            offset: const Offset(0, 8),
          ),
        ),
      ),
    );
  }
}

class IconMenu {
  Icon icon;
  String nom;
  IconMenu({required this.icon, required this.nom});
}
