import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogo.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogoAsset.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/PageMessage.dart';
import 'package:s5/class/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../class/post.dart';

class MyChat extends StatefulWidget {
  static const screanRoute = "MyChat";

  const MyChat({Key? key}) : super(key: key);

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  var messageParService;
  final TextEditingController _message = TextEditingController();

  Future _getdata() async {
    try {
      SharedPreferences peres = await SharedPreferences.getInstance();
      var url = Uri.parse(MYURL('get_interface.php'));
      final response = await http.post(url, body: {
        "idUser": (peres.getInt("idUser")).toString(),
      });
      var data = jsonDecode(response.body);
      if (data == 'error') return;
      data = data.toList();
      List<Service> service = [];
      for (int i = 0; i < data.length; i++) {
        service.add(Service.fromJson(data[i]));
      }

      setState(() {
        messageParService = service;
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

  _envoyer(int i) async {
    var resultat = await client.selectionService(i);
    if (resultat == "ok") {
      Navigator.pushNamed(context, MyMessage.screanRoute);
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return messageParService == null
        ? const Center(
            child: Image(image: AssetImage('assets/img/5.png')),
          )
        : ListView(
            children: [
              for (int index = 0; index < messageParService.length; index++)
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Card(
                    color: Color.fromARGB(255, 143, 195, 238),
                    child: TextButton(
                      onPressed: () =>
                          _envoyer(messageParService[index].idService),
                      child: ListTile(
                        leading: messageParService[index].images == null
                            ? const ProfileLogoAsset(
                                photo: 'profile.jpg',
                                size: 50,
                              )
                            : ProfileLogo(
                                photo:
                                    messageParService[index].images[0].source,
                                size: 50,
                              ),
                        title: Text(messageParService[index].nomService),
                        trailing: const Icon(Icons.mail),
                      ),
                    ),
                  ),
                ),
            ],
          );
  }
}
