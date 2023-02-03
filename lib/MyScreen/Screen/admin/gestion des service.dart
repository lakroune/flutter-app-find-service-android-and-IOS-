import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/MyMenuBarAdmin.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GestioService extends StatefulWidget {
  static const screanRoute = "GestioService";

  const GestioService({Key? key}) : super(key: key);

  @override
  State<GestioService> createState() => _GestioServiceState();
}

class _GestioServiceState extends State<GestioService> {
  var myservice;
  getdata() async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var url = Uri.parse(MYURL('gestionService.php'));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    print(data);
    List<Service> myarticle = [];
    setState(() {
      myservice = myarticle;
    });
    if (data == "error") return;
    data = data.toList();

    for (int i = 0; i < data.length; i++) {
      myarticle.add(Service.fromJson(data[i]));
    }
    setState(() {
      myservice = myarticle;
    });
  }

  faireTraitment(
      {required String mes, required int idService, etat = 'accepte'}) {
    Alert(
      context: context,
      title: mes,
      buttons: [
        DialogButton(
          onPressed: () async {
            if (etat == "accepte") {
              await admin.accepterService(idService: idService);
            } else if (etat == "refuse") {
              await admin.refuserService(idService: idService);
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
        title: Text("Gestion des services"),
        backgroundColor: Colors.blueAccent,
        leading: const MenuBarAdmin(),
        elevation: 0,
      ),
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (myservice != null)
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: [
                        for (int i = 0; i < myservice.length; i++)
                          Card(
                            color: Colors.blueAccent,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextStile(
                                                text: myservice[i].nomService),
                                          ),
                                          TextStile(
                                              text: myservice[i].description)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextStile(
                                                text: myservice[i].datePub),
                                          ),
                                          TextStile(
                                              text:
                                                  myservice[i].prix.toString() +
                                                      " Dh"),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextStile(
                                                text: myservice[i]
                                                        .images
                                                        .length
                                                        .toString() +
                                                    " images"),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 200.0,
                                  child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: myservice[i].images.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        child: Image.network(
                                          MYURLIMG(myservice[i]
                                              .images[index]
                                              .source),
                                          width: 300,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 23),
                                      child: TextButton.icon(
                                          onPressed: () => faireTraitment(
                                              mes: "Voulez-vous accepter le service ?",
                                              idService:
                                                  myservice[i].idService),
                                          label:
                                              const TextStile(text: "accepter"),
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 23),
                                      child: TextButton.icon(
                                          onPressed: () => faireTraitment(
                                              mes: "Voulez-vous refuser le service ?",
                                              idService: myservice[i].idService,
                                              etat: "refuse"),
                                          label: TextStile(
                                            text: "refuser",
                                          ),
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
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
