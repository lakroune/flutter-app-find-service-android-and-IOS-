import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogo.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/PageMessage.dart';
import 'package:s5/class/categorie.dart';
import 'package:s5/class/client.dart';
import 'package:s5/class/evaluer.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:s5/src/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InfoService extends StatefulWidget {
  static const screanRoute = "InfoService";

  const InfoService({Key? key}) : super(key: key);

  @override
  State<InfoService> createState() => _InfoServiceState();
}

class _InfoServiceState extends State<InfoService> {
  var idUser,
      typeUser,
      serviceSelect,
      categorieSelect,
      artisanSelect,
      listClientEvaluer,
      nombretotaleEtoile = 0,
      _index = 0,
      comantaire = TextEditingController(),
      dejaEvaluer;

  getDataService() async {
    try {
      SharedPreferences peres = await SharedPreferences.getInstance();
      var url = Uri.parse(MYURL('getSelectService.php'));
      var response = await http.post(url, body: {
        "idService": peres.getInt("idService").toString(),
        "idClient": peres.getInt("idUser").toString(),
      });
      var data = jsonDecode(response.body);
      if (data == null) return;
      data = data.toList();
      print(data[0]);
      Service serviceS = Service.fromJson(data[0]);
      Client artisanS = Client.fromJson(data[1]);
      Categorie categorieS = Categorie.fromJson(data[2]);
      var etat = data[3]["etat"];
      int nombreTotal = int.parse(data[4]['nombreTotal']);
      List<Evaluer> evalueService = [];
      for (int i = 5; i < data.length; i++) {
        evalueService.add(Evaluer.fromJson(data[i]));
      }
      setState(() {
        dejaEvaluer = etat;
        nombretotaleEtoile = nombreTotal;
        listClientEvaluer = evalueService;
        serviceSelect = serviceS;
        artisanSelect = artisanS;
        categorieSelect = categorieS;
        idUser = peres.getInt("idUser");
        typeUser = peres.getString("typeUser");
      });
    } catch (e) {
      messageError(message: "verifier la connexion ");
    }
  }

  _evalier(int i) {
    setState(() {
      _index = i;
    });
  }

  var res=false ;

  queCeQueReserveFunction() async {
    setState(() async {
      res= await queCeQueReserve();
    });

  }
  reserve() async {
    setState(() async {
     String reponse= await client.reserveService(idService: serviceSelect.idService);
      res = true;
      if(reponse == 'error'){
        Fluttertoast.showToast(msg: "deja reserver ", backgroundColor: Colors.red ,gravity: ToastGravity.TOP );
      }
      else if (reponse == 'ok'){
        res=true;
        Fluttertoast.showToast(msg: "l'operation ***  ", backgroundColor: Colors.green ,gravity: ToastGravity.TOP );
      }
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
             reserve();
              Navigator.pop(context);
            }
          },
        ),
      ],
    ).show();
  }

functionx(){
  queCeQueReserveFunction();
   getDataService();
    
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   functionx();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          // leading: const MenuBar(),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 91, 150, 250),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text("reserve"),
              ),
              onPressed: () {
                if (idUser == null || idUser == 0) {
                  messageError(
                      message: " Vous devez d'abord vous connecter",
                      mes: "login");
                } else {
                  messageError(
                      message: " voullez-vous  réserver ce service ?",
                      mes: "reserve");
                }
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (serviceSelect != null)
                Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 200.0,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: serviceSelect.images.length,
                                  itemBuilder:
                                      (BuildContext context, int index) => Card(
                                    child: Image.network(
                                      MYURLIMG(
                                          serviceSelect.images[index].source),
                                      width: 400,
                                      height: 500,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (serviceSelect != null)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 157, 196, 160),
                            ),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text("appeler"),
                          ),
                          onPressed: () {
                            if (idUser == null || idUser == 0) {
                              messageError(
                                  message: " Vous devez d'abord vous connecter",
                                  mes: "login");
                            } else {
                              makePhoneCall(artisanSelect.numTele);
                            }
                          },
                          icon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 157, 196, 160),
                            ),
                          ),
                          label: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text('message'),
                          ),
                          onPressed: () async {
                            if (idUser == null || idUser == 0) {
                              messageError(
                                  message: " Vous devez d'abord vous connecter",
                                  mes: "login");
                            } else {
                              await client
                                  .selectionService(serviceSelect.idService);

                              Navigator.pushNamed(
                                  context, MyMessage.screanRoute);
                            }
                          },
                          icon: const Icon(Icons.message),
                        ),
                      ),
                    ),
                  ],
                ),
              if (serviceSelect != null)
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Text("infomation sur le service"),
                      ),
                      ListTile(
                        leading: const Text("titre"),
                        title: Text(serviceSelect.nomService),
                      ),
                      ListTile(
                        leading: const Text("description"),
                        title: Text(serviceSelect.description),
                      ),
                      ListTile(
                        leading: const Text("categorie"),
                        title: Text(categorieSelect.nomCategorie),
                      ),
                      ListTile(
                        leading: const Text("date de publie"),
                        title: Text(serviceSelect.datePub),
                      ),
                      ListTile(
                        leading: const Text("prix"),
                        title: Text(serviceSelect.prix.toString() + " DH"),
                      ),
                      ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 80, 0),
                          child: Text("Star"),
                        ),
                        title: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (int i = 1; i < 6; i++)
                                if (i <=
                                    (nombretotaleEtoile /
                                        listClientEvaluer.length))
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  )
                                else
                                  const Icon(Icons.star_border),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  children: [
                                    Text(listClientEvaluer.length.toString()),
                                    Icon(Icons.person)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (artisanSelect != null)
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Text("informationsur l'Artisan"),
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              MYURLIMG(artisanSelect.photo),
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  artisanSelect.nomUser,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  artisanSelect.prenomUser,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      ListTile(
                        leading: const Text('ville'),
                        title: Text(
                          artisanSelect.ville,
                        ),
                      ),
                      ListTile(
                        leading: const Text("mombre depuis "),
                        title: Text(artisanSelect.dateCreation),
                      )
                    ],
                  ),
                ),
              if (dejaEvaluer == 'non' && res == true && idUser != 0)
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (int i = 1; i < 6; i++)
                              if (i <= _index)
                                IconButton(
                                    onPressed: () => _evalier(i),
                                    icon: const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ))
                              else
                                IconButton(
                                    onPressed: () => _evalier(i),
                                    icon: Icon(Icons.star_border))
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                controller: comantaire,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('comantaire'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: IconButton(
                            onPressed: () {
                              client.evaluerService(
                                  idService: serviceSelect.idService,
                                  nombreEtoile: _index,
                                  comantaire: comantaire.text);
                              getDataService();
                            },
                            icon: const Icon(
                              Icons.send,
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              if (listClientEvaluer != null)
                for (int i = 0; i < listClientEvaluer.length; i++)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ProfileLogo(
                                    photo: listClientEvaluer[i].photo,
                                    size: 30),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(listClientEvaluer[i].nomUser +
                                      " " +
                                      listClientEvaluer[i].prenomUser),
                                ),
                              ),
                              for (int j = 1; j < 6; j++)
                                if (j <= listClientEvaluer[i].nombreEtoile)
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  )
                                else
                                  const Icon(Icons.star_border),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(listClientEvaluer[i].comantaire),
                          )
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ));
  }
}
