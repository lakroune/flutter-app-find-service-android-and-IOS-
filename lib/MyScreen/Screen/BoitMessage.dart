import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogo.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/pageMessageArtisan.dart';
import 'package:s5/class/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../class/client.dart';

class BoitMessage extends StatefulWidget {
  static const screanRoute = "BoitMessage";

  const BoitMessage({Key? key}) : super(key: key);

  @override
  State<BoitMessage> createState() => _BoitMessageState();
}

class _BoitMessageState extends State<BoitMessage> {
  var listClientMessage, mbMessage;
  getdata() async {
    try {
      SharedPreferences pere = await SharedPreferences.getInstance();
      var response =
          await http.post(Uri.parse(MYURL("getClientMessage.php")), body: {
        "idService": pere.getInt("idServiceM").toString(),
      });
      var data = jsonDecode(response.body);
      print(data);
      if (data == "error") return;
      List<Client> listClt = [];
      List<int> nbMes = [];
      data = data.toList();
      for (int i = 0; i < data.length; i++) {
        listClt.add(Client.fromJson(data[i]));
        nbMes.add(int.parse(data[i]["mbMessage"]));
      }

      setState(() {
        listClientMessage = listClt;
        mbMessage = nbMes;
      });
    } catch (e) {
      messageError("vriefier la connexion");
    }
  }

//  messageError("vriefier la conexion");
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

  selectClient(var val) async {
    SharedPreferences perer = await SharedPreferences.getInstance();
    perer.setInt("idClient", val);
    Navigator.pushNamed(context, MymessageArtisan.screanRoute);
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
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          if (listClientMessage != null)
            for (int index = 0; index < listClientMessage.length; index++)
              TextButton(
                onPressed: () => selectClient(listClientMessage[index].idUser),
                child: Card(
                  color: Color.fromARGB(255, 143, 195, 238),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ProfileLogo(
                            photo: listClientMessage[index].photo, size: 60),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          listClientMessage[index].nomUser +
                              "  " +
                              listClientMessage[index].prenomUser,
                        )),
                        Text(mbMessage[index].toString()),
                        Icon(Icons.message),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
