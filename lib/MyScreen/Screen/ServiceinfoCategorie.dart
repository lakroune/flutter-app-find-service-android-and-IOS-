import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogoAsset.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/PageMessage.dart';
import 'package:s5/MyScreen/Screen/ServiceInfo.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class ServiceinfoCategorie extends StatefulWidget {
  static const screanRoute = "ServiceinfoCategorie";

  const ServiceinfoCategorie({Key? key}) : super(key: key);

  @override
  State<ServiceinfoCategorie> createState() => _ServiceinfoCategorieState();
}

class _ServiceinfoCategorieState extends State<ServiceinfoCategorie> {
  var serviceListCatigorie1;
  var serviceListCatigorie,
      idUser,
      typeUser,
      etat,
      etatAticleSave,
      sauveGarder = Colors.grey,
      nomCategorie,
      sommeEtoile,
      nombreClient,
      listNum,
      rechercher = TextEditingController();

  getdata1() async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var url = Uri.parse(MYURL('getServiceCategorie.php'));
    var response = await http.post(url, body: {
      "idCategorie": peres.getInt("idCategorie").toString(),
      "idUser": peres.getInt("idUser").toString(),
    });
    var data = jsonDecode(response.body);
    if (data == 'error') return;
    data = data.toList();
    print(data);
    List<Service> art = [];
    List<Color> save = [];
    List<int> etoile = [];
    List<int> nbCilent = [];
    List<String> numTelePhone = [];
    for (int i = 0; i < data.length; i++) {
      numTelePhone.add(data[i]["numTele"]);
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
      listNum = numTelePhone;
      sommeEtoile = etoile;
      nombreClient = nbCilent;
      etatAticleSave = save;
      serviceListCatigorie = art;
      idUser = peres.getInt("idUser");
      typeUser = peres.getString("typeUser");
      nomCategorie = peres.getString("nomCategorie");
    });
  }

  _selectService({required int idServiceS}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("idService", idServiceS);
    Navigator.pushNamed(context, InfoService.screanRoute);
  }

  // rechercherFunction() async {
  //   if (rechercher.text != "") {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     preferences.setString("recherche", rechercher.text);
  //     Navigator.pushNamed(context, RchercherPage.screanRoute);
  //   }
  // }

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

  var textCont = "";
  var moderecherche = "normal";
  var ListnumTelePhone;
  int indexOption = 1;

  getdata({required String recher}) async {
    try {
      SharedPreferences peres = await SharedPreferences.getInstance();
      var response, url;
      if (moderecherche == "normal") {
        url = Uri.parse(MYURL('getServiceRecherche1.php'));
      } else if (moderecherche == "artisan") {
        url = Uri.parse(MYURL('getServiceRechercheArtisan1.php'));
      } else if (moderecherche == "prix") {
        url = Uri.parse(MYURL('getServiceRecherchePrix1.php'));
      } else if (moderecherche == "proche") {
        url = Uri.parse(MYURL('getServiceRechercheAdresse1.php'));
      }

      response = await http.post(url, body: {
        "idUser": peres.getInt("idUser").toString(),
        "recherche": recher,
        "idCategorie": peres.getInt("idCategorie").toString(),
        "ville": peres.getString("ville"),
      });

      var data = jsonDecode(response.body);
      // print(data);
      if (data == 'error') {
        setState(() {
          serviceListCatigorie1 = [];
        });
        print("stop et vider la la liste pour faire un future operation");
        return;
      }
      data = data.toList();
      List<Service> art = [];
      List<Color> save = [];
      List<int> etoile = [];
      List<String> numTelePhone = [];
      List<int> nbCilent = [];
      for (int i = 0; i < data.length; i++) {
        numTelePhone.add(data[i]["numTele"]);
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
        serviceListCatigorie1 = art;
        idUser = peres.getInt("idUser");
        typeUser = peres.getString("typeUser");
        nomCategorie = peres.getString("nomCategorie");
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: " Il y a une erreur, veuillez réessayer.",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.redAccent);
    }
  }

  save({required int index, required int idService}) {
    if (etatAticleSave[index] == Colors.red) {
      setState(() {
        etatAticleSave[index] = Colors.grey;
        client.anullerSaveService(idService: idService);
      });
    } else if (etatAticleSave[index] == Colors.grey) {
      setState(() {
        etatAticleSave[index] = Colors.red;
        client.saveService(idService: idService);
      });
    }
  }

  // rechercherFunction({String modeRecherche = 'normal'}) async {
  //   if (rechercher.text != "") {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     if (modeRecherche == "normal") {
  //       await preferences.setString("recherche", rechercher.text);
  //       await getdata(recher: "", modeRecherche: "normal");
  //     } else if (modeRecherche == "adresse") {
  //       await preferences.setString("recherche", rechercher.text);
  //       await getdata(recher: "", modeRecherche: "adresse");
  //     } else if (modeRecherche == "artisan") {
  //       await preferences.setString("recherche", rechercher.text);
  //       await getdata(recher: "", modeRecherche: "artisan");
  //     } else if (modeRecherche == "categorie") {
  //       await preferences.setString("recherche", rechercher.text);
  //       await getdata(recher: "", modeRecherche: "categorie");
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Que cherchez-vous?",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
                child: Card(
                  child: Row(children: [
                    Expanded(
                        child: TextField(
                      onChanged: (String val) {
                        try {
                          setState(() {
                            textCont = val;
                            getdata(recher: val);
                          });
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "??",
                              backgroundColor: Colors.red,
                              gravity: ToastGravity.TOP);
                        }
                      },
                      controller: rechercher,
                    )),
                    if (textCont != "")
                      IconButton(
                          onPressed: () async {
                            await getdata1();
                            setState(() {
                              textCont = "";
                              rechercher.clear();
                              moderecherche = "normal";
                              indexOption = -1;
                            });
                          },
                          icon: const Icon(Icons.close))
                  ]),
                ),
              ),
              if (listOptionRecherche.isNotEmpty)
                SizedBox(
                  height: 140.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listOptionRecherche.length,
                    itemBuilder: (BuildContext context, int index) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () async {
                               getdata(recher: textCont);
                              setState(() {
                                moderecherche =
                                    listOptionRecherche[index].option;
                                indexOption = listOptionRecherche[index].id;
                              });
                            },
                            child: ProfileLogoAsset(
                                photo: listOptionRecherche[index].image,
                                size: 50),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                              width: 120,
                              child: Center(
                                child: Text(listOptionRecherche[index].nom,
                                    style: indexOption ==
                                            listOptionRecherche[index].id
                                        ? const TextStyle(
                                            color: Colors.red,
                                          )
                                        : const TextStyle(
                                            color: Colors.white,
                                          )),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              if (serviceListCatigorie != null && textCont == "")
                for (int index = 0;
                    index < serviceListCatigorie.length;
                    index++)
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
                                MYURLIMG(serviceListCatigorie[index]
                                    .images[0]
                                    .source),
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
                                            Text(
                                                nombreClient[index].toString()),
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
                                  child: SizedBox(
                                      height: 40,
                                      child: IconButton(
                                          onPressed: () {
                                            if (idUser == null || idUser == 0) {
                                              messageError(
                                                  message:
                                                      " Vous devez d'abord vous connecter",
                                                  mes: "login");
                                            } else {
                                              makePhoneCall(listNum[index]);
                                            }
                                          },
                                          icon: const Icon(Icons.phone))),
                                ),
                                Container(
                                  height: 30,
                                  child: IconButton(
                                      onPressed: () async {
                                        if (idUser == null || idUser == 0) {
                                          messageError(
                                              message:
                                                  " Vous devez d'abord vous connecter",
                                              mes: "login");
                                        } else {
                                          await client.selectionService(
                                              serviceListCatigorie[index]
                                                  .idService);
                                          Navigator.pushNamed(
                                              context, MyMessage.screanRoute);
                                        }
                                      },
                                      icon: const Icon(Icons.forum)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (idUser == null || idUser == 0) {
                                      messageError(
                                          message:
                                              " Vous devez d'abord vous connecter",
                                          mes: "login");
                                    } else {
                                      save(
                                          index: index,
                                          idService: serviceListCatigorie[index]
                                              .idService);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: etatAticleSave[index],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
              if (serviceListCatigorie1 != null && textCont != "")
                for (int index = 0;
                    index < serviceListCatigorie1.length;
                    index++)
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
                                      serviceListCatigorie1[index].idService),
                              child: Image.network(
                                MYURLIMG(serviceListCatigorie1[index]
                                    .images[0]
                                    .source),
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
                                                serviceListCatigorie1[index]
                                                    .datePub)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            child: Text(
                                                serviceListCatigorie1[index]
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
                                                serviceListCatigorie1[index]
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
                                            Text(
                                                nombreClient[index].toString()),
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
                                  child: SizedBox(
                                      height: 40,
                                      child: IconButton(
                                          onPressed: () {
                                            if (idUser == null || idUser == 0) {
                                              messageError(
                                                  message:
                                                      " Vous devez d'abord vous connecter",
                                                  mes: "login");
                                            } else {
                                              makePhoneCall(listNum[index]);
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
                                                serviceListCatigorie1[index]
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
                                          message:
                                              " Vous devez d'abord vous connecter",
                                          mes: "login");
                                    } else {
                                      save(
                                          index: index,
                                          idService:
                                              serviceListCatigorie1[index]
                                                  .idService);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    color: etatAticleSave[index],
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
      ),
    );
  }
}




// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:s5/MyScreen/Screen/FristPage.dart';
// import 'package:s5/MyScreen/Screen/PageMessage.dart';
// import 'package:s5/MyScreen/Screen/ServiceInfo.dart';
// import 'package:s5/MyScreen/Screen/recherche.dart';
// import 'package:s5/class/post.dart';
// import 'package:s5/class/service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'login.dart';

// class ServiceinfoCategorie extends StatefulWidget {
//   static const screanRoute = "ServiceinfoCategorie";

//   const ServiceinfoCategorie({Key? key}) : super(key: key);

//   @override
//   State<ServiceinfoCategorie> createState() => _ServiceinfoCategorieState();
// }

// class _ServiceinfoCategorieState extends State<ServiceinfoCategorie> {
//   var serviceListCatigorie,
//       idUser,
//       typeUser,
//       etat,
//       sauveGarder = Colors.grey,
//       nomCategorie,
//       sommeEtoile,
//       nombreClient,
//       listNum,
//       rechercher = TextEditingController();

//   getdata() async {
//     SharedPreferences peres = await SharedPreferences.getInstance();
//     var url = Uri.parse(MYURL('getServiceCategorie.php'));
//     var response = await http.post(url, body: {
//       "idCategorie": peres.getInt("idCategorie").toString(),
//       "idUser": peres.getInt("idUser").toString(),
//     });
//     var data = jsonDecode(response.body);
//     if (data == 'error') return;
//     data = data.toList();
//     print(data);
//     List<Service> art = [];
//     List<Color> save = [];
//     List<int> etoile = [];
//     List<int> nbCilent = [];
//     List<String> numTelePhone = [];
//     for (int i = 0; i < data.length; i++) {
//       numTelePhone.add(data[i]["numTele"]);
//       etoile.add(int.parse(data[i]['sommeEtoile']));
//       nbCilent.add(int.parse(data[i]['nombreClient']));
//       art.add(Service.fromJson(data[i]));
//       if (data[i]['save'] == "oui") {
//         save.add(Colors.red);
//       } else if (data[i]['save'] == 'non') {
//         save.add(Colors.grey);
//       }
//     }
//     setState(() {
//       listNum = numTelePhone;
//       sommeEtoile = etoile;
//       nombreClient = nbCilent;
//       etat = save;
//       serviceListCatigorie = art;
//       idUser = peres.getInt("idUser");
//       typeUser = peres.getString("typeUser");
//       nomCategorie = peres.getString("nomCategorie");
//     });
//   }

//   _selectService({required int idServiceS}) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     preferences.setInt("idService", idServiceS);
//     Navigator.pushNamed(context, InfoService.screanRoute);
//   }

//   rechercherFunction() async {
//     if (rechercher.text != "") {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       preferences.setString("recherche", rechercher.text);
//       Navigator.pushNamed(context, RchercherPage.screanRoute);
//     }
//   }

//   messageError({required String message, String mes = "non"}) {
//     Alert(
//       context: context,
//       type: AlertType.warning,
//       title: message,
//       buttons: [
//         DialogButton(
//           child: const Text(
//             "OK",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () {
//             if (mes == "login") {
//               Navigator.pushNamed(context, LoginPage.screanRoute);
//             } else {
//               Navigator.pushNamed(context, FirstPage.screanRoute);
//             }
//           },
//         ),
//       ],
//     ).show();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getdata();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//             child: IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: Icon(Icons.close)),
//           )
//         ],
//         elevation: 0,
//       ),
//       backgroundColor: Colors.blueAccent,
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Center(
//                 child: Text(
//                   "Que cherchez-vous?",
//                   style: TextStyle(color: Colors.white, fontSize: 30),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
//               child: Card(
//                 child: Row(children: [
//                   Expanded(
//                       child: TextField(
//                     controller: rechercher,
//                   )),
//                   IconButton(
//                     icon: const Icon(Icons.search),
//                     onPressed: () => rechercherFunction(),
//                   ),
//                 ]),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             if (serviceListCatigorie != null)
//               SizedBox(
//                 child: ListView.builder(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.vertical,
//                     itemCount: serviceListCatigorie.length,
//                     itemBuilder: (BuildContext context, int index) =>
//                         Container()),
//               ),
//             if (serviceListCatigorie != null)
//               for (int index = 0; index < serviceListCatigorie.length; index++)
//                 Column(
//                   children: [
//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4.0),
//                       ),
//                       child: Row(
//                         children: [
//                           TextButton(
//                             onPressed: () => _selectService(
//                                 idServiceS:
//                                     serviceListCatigorie[index].idService),
//                             child: Image.network(
//                               MYURLIMG(
//                                   serviceListCatigorie[index].images[0].source),
//                               width: 120,
//                               height: 120,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                           child: Text(
//                                               serviceListCatigorie[index]
//                                                   .datePub)),
//                                     ),
//                                     Expanded(
//                                       child: Container(
//                                           child: Text(
//                                               serviceListCatigorie[index]
//                                                       .prix
//                                                       .toString() +
//                                                   " DH")),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                           height: 60,
//                                           child: Text(
//                                               serviceListCatigorie[index]
//                                                   .nomService)),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Row(
//                                         children: [
//                                           for (int i = 0; i < 5; i++)
//                                             if (i <
//                                                     sommeEtoile[index] /
//                                                         nombreClient[index] &&
//                                                 nombreClient[index] != 0)
//                                               const Icon(
//                                                 Icons.star_rate,
//                                                 color: Colors.orange,
//                                                 size: 17,
//                                               )
//                                             else
//                                               const Icon(
//                                                 Icons.star_border,
//                                                 size: 17,
//                                               ),
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Row(
//                                         children: [
//                                           Text(nombreClient[index].toString()),
//                                           const Icon(
//                                             Icons.person,
//                                             size: 17,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: SizedBox(
//                                     height: 40,
//                                     child: IconButton(
//                                         onPressed: () {
//                                           if (idUser == null || idUser == 0) {
//                                             messageError(
//                                                 message:
//                                                     " Vous devez d'abord vous connecter",
//                                                 mes: "login");
//                                           } else {
//                                             makePhoneCall(listNum[index]);
//                                           }
//                                         },
//                                         icon: const Icon(Icons.phone))),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                     height: 40,
//                                     child: IconButton(
//                                         onPressed: () async {
//                                           await client.selectionService(
//                                               serviceListCatigorie[index]
//                                                   .idService);
//                                           Navigator.pushNamed(
//                                               context, MyMessage.screanRoute);
//                                         },
//                                         icon: Icon(Icons.forum))),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }
