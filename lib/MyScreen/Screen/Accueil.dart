import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogoAsset.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/PageMessage.dart';
import 'package:s5/MyScreen/Screen/ServiceInfo.dart';
import 'package:s5/MyScreen/Screen/ServiceinfoCategorie.dart';
import 'package:s5/class/categorie.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:s5/src/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accueil extends StatefulWidget {
  static const screanRoute = "Accueil";

  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  TextEditingController rechercher = TextEditingController();
  TextEditingController message = TextEditingController();
  var listArticle,
      etatAticleSave,
      moyenneEtoile,
      listCartegorie,
      idUser,
      nombreClient,
      sommeEtoile,
      typeUser,
      ListnumTelePhone;

  getService() async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var url = Uri.parse(MYURL('getService.php'));
    var url1 = Uri.parse(MYURL('getCategorie.php'));

    List<Service> art = [];
    List<int> etoile = [];
    List<int> nbCilent = [];
    List<Color> save = [];
    List<Categorie> categorie = [];
    List<String> numTelePhone = [];
    try {
      var response1 = await http.get(url1);
      var data1 = jsonDecode(response1.body);

      for (int i = 0; i < data1.length; i++) {
        categorie.add(Categorie.fromJson(data1[i]));
      }
      setState(() {
        listCartegorie = categorie;
      });
    } catch (e) {
      print(e);
    }

    try {
      var response = await http.post(url, body: {
        "idUser": peres.getInt("idUser").toString(),
      });
      var data = jsonDecode(response.body);
      if (data == 'error' || data == null) return;
      print(data);
      data = data.toList();
      for (int i = 0; i < data.length; i++) {
        numTelePhone.add(data[i]["numTele"]);
        art.add(Service.fromJson(data[i]));
        etoile.add(int.parse(data[i]['sommeEtaile']));
        nbCilent.add(int.parse(data[i]['nombreClient']));
        if (data[i]['save'] == "oui") {
          save.add(Colors.red);
        } else if (data[i]['save'] == 'non') {
          save.add(Colors.grey);
        }
      }
    } catch (e) {
      messageError(message: "vévifiez la connexion");
    }
    xxxx(save, art, etoile, nbCilent, numTelePhone);
  }

  xxxx(var save, var art, var etoile, var nbCilent, var numTelePhone) async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    setState(() {
      ListnumTelePhone = numTelePhone;
      etatAticleSave = save;
      listArticle = art;
      sommeEtoile = etoile;
      nombreClient = nbCilent;
      idUser = peres.getInt("idUser");
      typeUser = peres.getString("typeUser");
    });
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

  _selectService({required int idServiceS}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("idService", idServiceS);
    Navigator.pushNamed(context, InfoService.screanRoute);
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

  _selectCategorie(
      {required int idCategorie, required String nomCategorie}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("idCategorie", idCategorie);
    preferences.setString("nomCategorie", nomCategorie);
    Navigator.pushNamed(context, ServiceinfoCategorie.screanRoute);
  }

  var textCont = "";
  var moderecherche = "normal";
  var serviceListCatigorie;
  int indexOption = 1;
  var etat, nomCategorie, response;

  getdata({required String recher}) async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    try {
      var response, url;
      if (moderecherche == "normal") {
        url = Uri.parse(MYURL('getServiceRecherche.php'));
      } else if (moderecherche == "artisan") {
        url = Uri.parse(MYURL('getServiceRechercheArtisan.php'));
      } else if (moderecherche == "prix") {
        url = Uri.parse(MYURL('getServiceRecherchePrix.php'));
      } else if (moderecherche == "proche") {
        url = Uri.parse(MYURL('getServiceRechercheAdresse.php'));
      }

      try {
        response = await http.post(url, body: {
          "idUser": peres.getInt("idUser").toString(),
          "recherche": recher,
          "ville": peres.getString("ville"),
        });
      } catch (e) {
        Fluttertoast.showToast(
            msg:
                " Devrait. Tout d'abord, vous devez déterminer la ville actuelle",
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.redAccent);
      }

      var data = jsonDecode(response.body);
      print(data);
      if (data == 'error') {
        setState(() {
          serviceListCatigorie = null;
        });
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
        etatAticleSave = save;
        ListnumTelePhone = numTelePhone;
        serviceListCatigorie = art;
        idUser = peres.getInt("idUser");
        typeUser = peres.getString("typeUser");
        nomCategorie = peres.getString("nomCategorie");
      });
    } catch (e) {
      serviceListCatigorie.removeRange(0, serviceListCatigorie.length);
      Fluttertoast.showToast(
          msg: " Il y a une erreur, veuillez réessayer.",
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.redAccent);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getService();
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
                          print("errror");
                        }
                      },
                      controller: rechercher,
                    )),
                    if (textCont != "")
                      IconButton(
                          onPressed: () {
                            getService();
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
              if (listCartegorie != null)
                SizedBox(
                  height: 140.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: textCont == ""
                        ? listCartegorie.length
                        : listOptionRecherche.length,
                    itemBuilder: (BuildContext context, int index) =>
                        textCont == ""
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () => _selectCategorie(
                                          idCategorie:
                                              listCartegorie[index].idCategorie,
                                          nomCategorie: listCartegorie[index]
                                              .nomCategorie),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          MYURLIMG(listCartegorie[index]
                                              .imageCategorie),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Center(
                                        child: Text(
                                          listCartegorie[index].nomCategorie,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          getdata(recher: textCont);
                                          moderecherche =
                                              listOptionRecherche[index].option;
                                          indexOption =
                                              listOptionRecherche[index].id;
                                        });
                                      },
                                      child: ProfileLogoAsset(
                                          photo:
                                              listOptionRecherche[index].image,
                                          size: 50),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                        width: 120,
                                        child: Center(
                                          child: Text(
                                              listOptionRecherche[index].nom,
                                              style: indexOption ==
                                                      listOptionRecherche[index]
                                                          .id
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
              if (listArticle != null && textCont == "")
                for (int index = 0; index < listArticle.length; index++)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => _selectService(
                              idServiceS: listArticle[index].idService),
                          child: Image.network(
                            MYURLIMG(listArticle[index].images[0].source),
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
                                        child:
                                            Text(listArticle[index].datePub)),
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Text(
                                            listArticle[index].prix.toString() +
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
                                            listArticle[index].nomService)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        for (int i = 0; i < 5; i++)
                                          if (nombreClient[index] > 0 &&
                                              i <
                                                  sommeEtoile[index] /
                                                      nombreClient[index])
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
                                  height: 30,
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
                                      icon: Icon(Icons.phone))),
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
                                          listArticle[index].idService);
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
                                      idService: listArticle[index].idService);
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
                  )
              else if (serviceListCatigorie != null && textCont != "")
                for (int index = 0;
                    index < serviceListCatigorie.length;
                    index++)
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
                                        child: Text(serviceListCatigorie[index]
                                            .datePub)),
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Text(serviceListCatigorie[index]
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
                                        child: Text(serviceListCatigorie[index]
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
                                      
                                          if (i <sommeEtoile[index] /
                                                      nombreClient[index] &&
                                              nombreClient[index] > 0)
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
        ),
      ),
    );
  }
}
