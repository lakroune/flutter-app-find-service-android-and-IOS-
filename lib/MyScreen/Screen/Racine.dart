import 'package:flutter/material.dart';
import 'package:s5/MyScreen/MyWidget/MynavigationBottomAppBarArtisan.dart';
import 'package:s5/MyScreen/MyWidget/MynavigationBottomAppBarClient.dart';
import 'package:s5/MyScreen/Screen/admin/interfaceAdmin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Racine extends StatefulWidget {
   static const screanRoute = "Racine";

  const Racine({Key? key}) : super(key: key);

  @override
  State<Racine> createState() => _RacineState();
}

class _RacineState extends State<Racine> {
  var myButtomBAr;
  racine() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var typeUser = preferences.get("typeUser");
    setState(() {
      if (typeUser == "client") {
        myButtomBAr = const MyNavicationClient();
        print(typeUser);
      } else if (typeUser == "artisan") {
        myButtomBAr = const MyNavicationArtisan();
        print(typeUser);
      } else if (typeUser == "admin") {
         myButtomBAr = const InterfaceAdmin();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    racine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: myButtomBAr,
    );
  }
}
