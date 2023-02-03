import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/MyMenuBarAdmin.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogo.dart';
import 'package:s5/class/client.dart';
import 'package:s5/class/post.dart';
import 'package:http/http.dart' as http;

class GestionCompte extends StatefulWidget {
  static const screanRoute = "GestionCompte";
  const GestionCompte({Key? key}) : super(key: key);

  @override
  State<GestionCompte> createState() => _GestionCompteState();
}

class _GestionCompteState extends State<GestionCompte> {
  var listUsers;
  getdata() async {
    var response = await http.get(Uri.parse(MYURL("gestionComptes.php")));
    var data = jsonDecode(response.body);
    print(data);
    if (data == "error") return;

    data = data.toList();
    List<Client> listClt = [];

    for (var val in data) listClt.add(Client.fromJson(val));
    setState(() {
      listUsers = listClt;
    });
  }

  faireTraitment({required String mes, required int idUser, etat = 'accepte'}) {
    Alert(
      context: context,
      title: mes,
      buttons: [
        DialogButton(
          onPressed: () async {
            if (etat == "accepte") {
              await admin.accepterUser(idUser: idUser);
            } else if (etat == "reffuse") {
              await admin.refuserUser(idUser: idUser);
            }
            await getdata();
            Navigator.pop(context);
          },
          child: const Text(
            "ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close))
        ],
        backgroundColor: Colors.blueAccent,
        leading: const MenuBarAdmin(),
        elevation: 0,
        title: Text("Gestion des comptes"),
      ),
      backgroundColor: Colors.blueAccent,
      body: listUsers == null
          ? Container()
          : ListView.builder(
              itemCount: listUsers.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: const Color.fromARGB(255, 91, 150, 250),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: ProfileLogo(
                                photo: listUsers[index].photo, size: 60),
                          ),
                        ],
                      ),
                      TextStyleWrite(
                          text: "nom ", val: ": " + listUsers[index].nomUser),
                      TextStyleWrite(
                          text: "prenom ",
                          val: ": " + listUsers[index].prenomUser),
                      TextStyleWrite(
                          text: "email ", val: ": " + listUsers[index].email),
                      TextStyleWrite(
                          text: "numero telephone ",
                          val: ": " + listUsers[index].numTele),
                      TextStyleWrite(
                          text: "date creation ",
                          val: ": " + listUsers[index].dateCreation),
                      TextStyleWrite(
                          text: "adresse ", val: ": " + listUsers[index].ville),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () => faireTraitment(
                                mes: "Voulez-vous accepter le compte ?", idUser: listUsers[index].idUser),
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            label: const Text(
                              "accepter",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => faireTraitment(
                                mes: "Voulez-vous refuser le compte ?",
                                idUser: listUsers[index].idUser,
                                etat: 'refuser'),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            label: const Text(
                              "refuse",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class TextStile extends StatelessWidget {
  const TextStile({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }
}

class TextStyleWrite extends StatelessWidget {
  const TextStyleWrite({Key? key, required this.text, required this.val})
      : super(key: key);
  final String text, val;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              val,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
