import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogo.dart';
import 'package:s5/MyScreen/Screen/BoitMessage.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoitMessageService extends StatefulWidget {
  static const screanRoute = "BoitMessageService";

  const BoitMessageService({Key? key}) : super(key: key);

  @override
  State<BoitMessageService> createState() => _BoitMessageServiceState();
}

class _BoitMessageServiceState extends State<BoitMessageService> {
  var listService;
  selctService(var val) async {
    await client.selectionService(val);
    Navigator.pushNamed(context, BoitMessage.screanRoute);
  }

  getdata() async {
    try {
      SharedPreferences pere = await SharedPreferences.getInstance();
      var response =
          await http.post(Uri.parse(MYURL("getServiceMessage.php")), body: {
        "idArtisan": pere.getInt("idUser").toString(),
      });
      var data = jsonDecode(response.body);
      print(data);
      if (data == "error") return;
      data = data.toList();
      List<Service> listSer = [];
      for (int i = 0; i < data.length; i++) {
        listSer.add(Service.fromJson(data[i]));
      }
      setState(() {
        listService = listSer;
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
          if (listService != null)
            for (int index = 0; index < listService.length; index++)
              TextButton(
                onPressed: () => selctService(listService[index].idService),
                child: Card(
                  color: Color.fromARGB(255, 143, 195, 238),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          ProfileLogo(
                            photo: listService[index].images[0].source,
                            size: 70,
                            radius: 0,
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(listService[index].nomService),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(listService[index].datePub),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
