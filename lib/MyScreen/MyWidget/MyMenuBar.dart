import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/ProfilePage.dart';
import 'package:s5/MyScreen/Screen/resurve.dart';
import 'package:s5/class/post.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
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
    modeArtisan(String message) {
    Alert(
      context: context,
      title: message,
      buttons: [
        DialogButton(
          child: const Text(
            "ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await client.toArtisan();
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }

  List<IconMenu> myMenu = [
    IconMenu(
        icon: const Icon(
          Icons.change_circle,
          color: Colors.white,
        ),
        nom: "mode Artisan"),
         IconMenu(
        icon: const Icon(
          Icons.add_task,
          color: Colors.white,
        ),
        nom: "reservation"),
         IconMenu(
        icon: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        nom: "profile"),
  ];

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
            customItemsIndexes: const [3],
            customItemsHeight: 8,
            items: [
              ...myMenu.map(
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
              }else if(value == "mode Artisan"){
                modeArtisan(" voullez-vous passer \nen monde Artisan ? ");
              }else if(value == "reservation"){
               Navigator.pushNamed(context,ReservePages.screanRoute);
              }else if(value == "profile"){
               Navigator.pushNamed(context,ProfilePage.screanRoute);
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
