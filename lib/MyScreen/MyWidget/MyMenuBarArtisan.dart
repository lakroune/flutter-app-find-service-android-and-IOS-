import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/Screen/BoitMessageService.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/ProfilePage.dart';
import 'package:s5/MyScreen/Screen/resurve.dart';
import 'package:s5/class/post.dart';

class MenuBarArtisan extends StatefulWidget {
  const MenuBarArtisan({Key? key}) : super(key: key);

  @override
  State<MenuBarArtisan> createState() => _MenuBarArtisanState();
}

class _MenuBarArtisanState extends State<MenuBarArtisan> {
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
    boitMessage() {
    Navigator.pushNamed(context, BoitMessageService.screanRoute);
  }
  boiteReservation(){
    Navigator.pushNamed(context, ReservePages.screanRoute);
  }
  monProfile(){
     Navigator.pushNamed(context, ProfilePage.screanRoute);
  }

  List<IconMenu> myMenu = [
    IconMenu(
        icon: const Icon(
          Icons.messenger_rounded  ,
          color: Colors.white,
        ),
        nom: "boite des messages"),
         IconMenu(
        icon: const Icon(
          Icons.add_task_outlined,
          color: Colors.white,
        ),
        nom: "reservation"),
        
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
            customItemsIndexes: const [2],
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
              }else if(value == "boite des messages"){
               boitMessage();
              }else if(value == "reservation"){
               boiteReservation();
              }


            },
            itemHeight: 48,
            itemPadding: const EdgeInsets.only(left: 16, right: 16),
            dropdownWidth: 230,
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
