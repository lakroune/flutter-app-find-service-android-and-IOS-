import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:s5/MyScreen/Screen/Racine.dart';
import 'package:s5/MyScreen/Screen/login.dart';
import 'package:s5/MyScreen/Screen/secondPage.dart';
import 'package:s5/class/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  static const screanRoute = "FirstPage";

  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  connecterDeja() async {
    try {
      var response =
         await http.get(Uri.parse(MYURL("verifierLaConnexion.php")));
      var data = jsonDecode(response.body);
      if (data == "connecter1") {
        SharedPreferences peres = await SharedPreferences.getInstance();
        var idUser = peres.getInt("idUser");
        bool varBool = true; // await verifierLaConnexion();
        if (varBool == true) {
          if (idUser == 0 || idUser == null) {
            Navigator.pushNamed(context, LoginPage.screanRoute);
          } else {
            Navigator.pushNamed(context, Racine.screanRoute);
          }
        }
      }
      else {
         messageError("la serveur n'est pas connecté");
      }
    } catch (e) {
     messageError("vérifiez la connexion");
      // Navigator.pushNamed(context, LoginPage.screanRoute);
    }
  }

  messageError(String message) {
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
          onPressed: () => Navigator.pushNamed(context, FirstPage.screanRoute),
        ),
      ],
    ).show();
  }

  getInfo() async {
    SharedPreferences pere = await SharedPreferences.getInstance();
    var email = pere.getString("email");
    var password = pere.getString("password");
    await client.seConnecter(
        email: email.toString(), password: password.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
    connecterDeja();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: TextButton(
        onPressed:()=>connecterDeja() ,
        child: Center(
          child: Image.asset("assets/img/2.png"),
        ),
      ),
    );
  }
}
