import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/Screen/PageMessage.dart';
import 'package:s5/MyScreen/Screen/Racine.dart';
import 'package:s5/MyScreen/Screen/ServiceInfo.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FristPage.dart';

class SauvegardPage extends StatefulWidget {
  static const screanRoute = "SauvegardPage";

  const SauvegardPage({Key? key}) : super(key: key);

  @override
  State<SauvegardPage> createState() => _SauvegardPageState();
}

class _SauvegardPageState extends State<SauvegardPage> {
  TextEditingController _message = TextEditingController();
  var listServiceSauvgarder, idUser, typeUser, etatService, ListnumTelePhone;

  getdata() async {
    try {
      SharedPreferences peres = await SharedPreferences.getInstance();
      var url = Uri.parse(MYURL('getServiceSauvegarder.php'));
      var response = await http.post(url, body: {
        "idCategorie": peres.getInt("idCategorie").toString(),
        "idUser": peres.getInt("idUser").toString(),
      });
      var data = jsonDecode(response.body);
      if (data == 'error') return;
      print(data);
      data = data.toList();
      List<Service> art = [];
      List<String> numTelePhone = [];
      List<Color> save = [];
      List<int> etoile=[];
      List<int> nbClient = []; 
      for (int i = 0; i < data.length; i++) {
        //  etoile.add(int.parse(data[i]['sommeEtoile']));
        // nbClient.add(int.parse(data[i]['nombreClient']));
        numTelePhone.add(data[i]["numTele"]);
        art.add(Service.fromJson(data[i]));
        if (data[i]['save'] == "oui") {
          save.add(Colors.red);
        } else if (data[i]['save'] == 'non') {
          save.add(Colors.grey);
        }
      }
      setState(() {
        ListnumTelePhone = numTelePhone;
        etatService = save;
        listServiceSauvgarder = art;
        idUser = peres.getInt("idUser");
        typeUser = peres.getString("typeUser");
      });
    } catch (e) {
      messageError("vérifiez la connexion");
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
          onPressed: () => Navigator.pushNamed(context, Racine.screanRoute),
        ),
      ],
    ).show();
  }

  operationSuccus(String message) {
    Alert(
      context: context,
      type: AlertType.success,
      title: message,
      buttons: [
        DialogButton(
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 47, 161, 72),
            Color.fromARGB(255, 5, 99, 28)
          ]),
        )
      ],
    ).show();
  }

  operationError(String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: message,
      buttons: [
        DialogButton(
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 17, 20, 199),
            Color.fromARGB(255, 24, 81, 146),
            Color.fromARGB(255, 43, 44, 87),
            Color.fromARGB(255, 74, 21, 95)
          ]),
        ),
      ],
    ).show();
  }

  selectService(var val) async {
    await client.selectionService(val);
    Navigator.pushNamed(context, MyMessage.screanRoute);
  }

  _selectService({required int idServiceS}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("idService", idServiceS);
    Navigator.pushNamed(context, InfoService.screanRoute);
  }

  save({required int index, required int idService}) {
    if (etatService[index] == Colors.red) {
      setState(() {
        etatService[index] = Colors.grey;
        client.anullerSaveService(idService: idService);
      });
    } else if (etatService[index] == Colors.grey) {
      setState(() {
        etatService[index] = Colors.red;
        client.saveService(idService: idService);
      });
    }
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            listServiceSauvgarder == null
                ? const Text("")
                : Column(
                    children: [
                      for (int i = 0; i < listServiceSauvgarder.length; i++)
                        if (listServiceSauvgarder[i].idArtisan.toString() !=
                            idUser.toString())
                          Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => _selectService(
                              idServiceS:
                                  listServiceSauvgarder[i].idService),
                          child: Image.network(
                            MYURLIMG(
                                listServiceSauvgarder[i].images[0].source),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        child: Text(listServiceSauvgarder[i]
                                            .datePub)),
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Text(listServiceSauvgarder[i]
                                                .prix
                                                .toString() +
                                            " DH")),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        child: Text(listServiceSauvgarder[i]
                                            .nomService)),
                                  ),
                                ],
                              ),
                               const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
                              Row(
                                children: [
                                  Expanded(child: Text(listServiceSauvgarder[i].description))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 40,
                                  child: IconButton(
                                      onPressed: () {
                                        if (idUser == null || idUser == 0) {
                                          messageError(
                                              // message:
                                                  " Vous devez d'abord vous connecter",
                                              // mes: "login"
                                              );
                                        } else {
                                          makePhoneCall(
                                              ListnumTelePhone[i]);
                                        }
                                      },
                                      icon: const Icon(Icons.phone))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 40,
                                  child: IconButton(
                                      onPressed: () async {
                                        await client.selectionService(
                                            listServiceSauvgarder[i]
                                                .idService);
                                        Navigator.pushNamed(
                                            context, MyMessage.screanRoute);
                                      },
                                      icon: Icon(Icons.forum))),
                            ),
                            IconButton(
                              onPressed: () {
                                if (idUser == null || idUser == 0) {
                                  messageError(
                                      // message:
                                          " Vous devez d'abord vous connecter",
                                      // mes: "login"
                                      );
                                } else {
                                  save(
                                      index: i,
                                      idService: listServiceSauvgarder[i].idService);
                                }
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: etatService[i],
                              ),
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
    );
  }
}
