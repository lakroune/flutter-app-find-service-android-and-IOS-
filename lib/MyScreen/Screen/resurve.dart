import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/PageMessage.dart';
import 'package:s5/MyScreen/Screen/ServiceInfo.dart';
import 'package:s5/MyScreen/Screen/login.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservePages extends StatefulWidget {
  static const String screanRoute = "ReservePages";
  const ReservePages({Key? key}) : super(key: key);

  @override
  State<ReservePages> createState() => _ReservePagesState();
}

class _ReservePagesState extends State<ReservePages> {
  var serviceListCatigorie,
      idUser,
      typeUser,
      etat,
      sauveGarder = Colors.grey,
      nomCategorie,
      sommeEtoile,
      nombreClient,
      ListnumTelePhone,
      rechercher = TextEditingController();

  getdata({String modeRecherche = 'normal'}) async {
    // try {
      SharedPreferences peres = await SharedPreferences.getInstance();

      var url = Uri.parse(MYURL('getServiceReserver.php'));
        var response = await http.post(url, body: {
          "idUser": peres.getInt("idUser").toString(),
        });

      var data = jsonDecode(response.body);
      if (data == 'error') {
        setState(() {
          serviceListCatigorie = [];
        });
        print("stop et vider la la liste pour faire un future operation");
        return ;
      }
      data = data.toList();
      List<Service> art = [];
      List<Color> save = [];
      List<int> etoile = [];
      List<String> numTelePhone = [];
      List<int> nbCilent = [];
      for (int i = 0; i < data.length; i++) {
        numTelePhone.add(data[i]["numTele"]??"non");
        etoile.add(int.parse(data[i]['sommeEtoile']));
        nbCilent.add(int.parse(data[i]['nombreClient']));
        art.add(Service.fromJson(data[i]));
        if (data[i]['save'] == "oui") {
          save.add(Colors.red);
        } else if (data[i]['save'] == 'non') {
          save.add(Colors.grey);
        }
      }
      setState(() {
        sommeEtoile = etoile;
        nombreClient = nbCilent;
        etat = save;
        ListnumTelePhone = numTelePhone;
        serviceListCatigorie = art;
        idUser = peres.getInt("idUser");
        typeUser = peres.getString("typeUser");
        nomCategorie = peres.getString("nomCategorie");
      });
    // } catch (e) {
    //   Fluttertoast.showToast(
    //       msg: " Il y a une erreur, veuillez réessayer.",
    //       gravity: ToastGravity.TOP,
    //       backgroundColor: Colors.redAccent);
    // }
  }

  _selectService({required int idServiceS}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("idService", idServiceS);
    Navigator.pushNamed(context, InfoService.screanRoute);
  }

  messageError({required String message, String mes = "non"}) {
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
          onPressed: () {
            if (mes == "login") {
              Navigator.pushNamed(context, LoginPage.screanRoute);
            } else {
              Navigator.pushNamed(context, FirstPage.screanRoute);
            }
          },
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
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close)),
          )
        ],
        elevation: 0,
      ),
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             
             
             
            const SizedBox(
              height: 20,
            ),
            if (serviceListCatigorie != null)
              SizedBox(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: serviceListCatigorie.length ,
                    itemBuilder: (BuildContext context, int index) =>
                        Container()),
              ),
            if (serviceListCatigorie != null)
              for (int index = 0; index < serviceListCatigorie.length; index++)
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => _selectService(
                                idServiceS:
                                    serviceListCatigorie[index].idService),
                            child: Image.network(
                              MYURLIMG(
                                  serviceListCatigorie[index].images[0].source),
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
                                          child: Text(
                                              serviceListCatigorie[index]
                                                  .datePub)),
                                    ),
                                    Expanded(
                                      child: Container(
                                          child: Text(
                                              serviceListCatigorie[index]
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
                                          height: 60,
                                          child: Text(
                                              serviceListCatigorie[index]
                                                  .nomService)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          for (int i = 0; i < 5; i++)
                                            if (i <
                                                    sommeEtoile[index] /
                                                        nombreClient[index] &&
                                                nombreClient[index] != 0)
                                              const Icon(
                                                Icons.star_rate,
                                                color: Colors.orange,
                                                size: 17,
                                              )
                                            else
                                              const Icon(
                                                Icons.star_border,
                                                size: 17,
                                              ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(nombreClient[index].toString()),
                                          const Icon(
                                            Icons.person,
                                            size: 17,
                                          ),
                                        ],
                                      ),
                                    )
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
                                                message:
                                                    " Vous devez d'abord vous connecter",
                                                mes: "login");
                                          } else {
                                            makePhoneCall(
                                                ListnumTelePhone[index]);
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
                                              serviceListCatigorie[index]
                                                  .idService);
                                          Navigator.pushNamed(
                                              context, MyMessage.screanRoute);
                                        },
                                        icon: Icon(Icons.forum))),
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

class TextRechercher extends StatelessWidget {
  const TextRechercher({Key? key, required this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }
}
