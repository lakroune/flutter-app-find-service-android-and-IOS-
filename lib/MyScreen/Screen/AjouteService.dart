import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/class/categorie.dart';
import 'package:s5/class/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AjouteService extends StatefulWidget {
  static const screanRoute = "AjouteService";

  const AjouteService({Key? key}) : super(key: key);

  @override
  State<AjouteService> createState() => _AjouteServiceState();
}

class _AjouteServiceState extends State<AjouteService> {
  TextEditingController nomService = TextEditingController();
  TextEditingController prix = TextEditingController();
  TextEditingController categorie = TextEditingController();
  TextEditingController description = TextEditingController();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  File? imageFile4;
  final ImagePicker _picker = ImagePicker();
  String selectNomCategorie = "select categorie";
  int selectIdCategrie = 0;
  var LISTCATIGORIE;

  Future getImageIS1() async {
    XFile? pickerFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile1 = File(pickerFile!.path);
    });
  }

  Future getImageIS2() async {
    XFile? pickerFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile2 = File(pickerFile!.path);
    });
  }

  Future getImageIS3() async {
    XFile? pickerFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile3 = File(pickerFile!.path);
    });
  }

  Future getImageIS4() async {
    XFile? pickerFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile4 = File(pickerFile!.path);
    });
  }

  changeCategorie({required int idCategorie, required String nomCategrie}) {
    setState(() {
      selectNomCategorie = nomCategrie;
      selectIdCategrie = idCategorie;
      print(idCategorie);
      print(nomCategrie);
      Navigator.pop(context);
    });
  }

  selectCategorie() {
    Alert(
      context: context,
      title: "chaisi un categorie",
      content: Column(
        children: <Widget>[
          if (LISTCATIGORIE == null)
            Text('verifier la connexion')
          else
            for (int index = 0; index < LISTCATIGORIE.length; index++)
              TextButton(
                  onPressed: () => changeCategorie(
                      idCategorie: LISTCATIGORIE[index].idCategorie,
                      nomCategrie: LISTCATIGORIE[index].nomCategorie),
                  child: Text(LISTCATIGORIE[index].nomCategorie))
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "annuler",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  Future fanctionAjouteService() async {
    if (prix.text == '' || nomService.text == '' || selectIdCategrie == 0)
      return;
    String namefile1 = '';
    String namefile2 = '';
    String namefile3 = '';
    String namefile4 = '';
    String base641 = '';
    String base642 = '';
    String base643 = '';
    String base644 = '';
    setState(() {
      if (imageFile1 != null) {
        namefile1 = imageFile1!.path.split("/").last;
        base641 = base64Encode(imageFile1!.readAsBytesSync());
      }
      if (imageFile2 != null) {
        namefile2 = imageFile2!.path.split("/").last;
        base642 = base64Encode(imageFile2!.readAsBytesSync());
      }
      if (imageFile3 != null) {
        namefile3 = imageFile3!.path.split("/").last;
        base643 = base64Encode(imageFile3!.readAsBytesSync());
      }
      if (imageFile4 != null) {
        namefile4 = imageFile4!.path.split("/").last;
        base644 = base64Encode(imageFile4!.readAsBytesSync());
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response =
        await http.post(Uri.parse(MYURL('ajouteService.php')), body: {
      "nom1": namefile1,
      "image1": base641,
      "nom2": namefile2,
      "image2": base642,
      "nom3": namefile3,
      "image3": base643,
      "nom4": namefile4,
      "image4": base644,
      "idArtisan": prefs.getInt("idUser").toString(),
      "nomService": nomService.text,
      "prix": prix.text,
      "description": description.text,
      "idCategorie": selectIdCategrie.toString(),
    });
    var data = jsonDecode(response.body) ?? "null";
    print(data);
    if (data == "ok") {
      Navigator.pushNamed(context, FirstPage.screanRoute);
    }
  }

  getListaCategorie() async {
    var response = await http.get(Uri.parse(MYURL('getCategorie.php')));
    var data = jsonDecode(response.body);
    if (data == null) return;
    data = data.toList();
    List<Categorie> ListCategories = [];
    for (int i = 0; i < data.length; i++) {
      ListCategories.add(Categorie.fromJson(data[i]));
    }
    setState(() {
      LISTCATIGORIE = ListCategories;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListaCategorie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: ListView(
        children: [
          Container(
            child: Column(children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  if (imageFile1 != null)
                    TextButton(
                      onPressed: getImageIS1,
                      child: Card(
                        child: Container(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Image.file(
                              File(imageFile1!.path),
                              height: 300,
                              width: 240,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    TextButton(
                      onPressed: getImageIS1,
                      child: Stack(
                        children: [
                          Card(
                            child: Container(
                              width: 150,
                              height: 150,
                              child: const Center(
                                child: Icon(Icons.add_a_photo),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            left: 20,
                            child: Stack(
                              children: const [
                                Text("ajoute un image"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  if (imageFile1 != null)
                    if (imageFile2 != null)
                      TextButton(
                        onPressed: getImageIS2,
                        child: Card(
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Center(
                              child: Image.file(
                                File(imageFile2!.path),
                                height: 300,
                                width: 240,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: getImageIS2,
                        child: Stack(
                          children: [
                            Card(
                              child: Container(
                                width: 150,
                                height: 150,
                                child: const Center(
                                  child: Icon(Icons.add_a_photo),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              left: 20,
                              child: Stack(
                                children: const [
                                  Text("ajoute un image"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                ],
              ),
              Row(
                children: [
                  if (imageFile2 != null)
                    if (imageFile3 != null)
                      TextButton(
                        onPressed: getImageIS3,
                        child: Card(
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Center(
                              child: Image.file(
                                File(imageFile3!.path),
                                height: 300,
                                width: 240,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: getImageIS3,
                        child: Stack(
                          children: [
                            Card(
                              child: Container(
                                width: 150,
                                height: 150,
                                child: const Center(
                                  child: Icon(Icons.add_a_photo),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              left: 20,
                              child: Stack(
                                children: const [
                                  Text("ajoute un image"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  if (imageFile3 != null)
                    if (imageFile4 != null)
                      TextButton(
                        onPressed: getImageIS4,
                        child: Card(
                          child: Container(
                            width: 150,
                            height: 150,
                            child: Center(
                              child: Image.file(
                                File(imageFile4!.path),
                                height: 300,
                                width: 240,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: getImageIS4,
                        child: Stack(
                          children: [
                            Card(
                              child: Container(
                                width: 150,
                                height: 150,
                                child: const Center(
                                  child: Icon(Icons.add_a_photo),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              left: 20,
                              child: Stack(
                                children: const [
                                  Text("ajoute un image"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 1, 1, 1),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextButton(
                          onPressed: () => selectCategorie(),
                          child: Text(selectNomCategorie),
                        ),
                      )),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 1, 5, 1),
                      child: Card(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: prix,
                          decoration: const InputDecoration(
                            label: Text('prix'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 1, 1, 1),
                      child: Card(
                        child: TextField(
                          controller: nomService,
                          decoration: const InputDecoration(
                            label: Text('titre service'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                child: Card(
                  child: TextField(
                    controller: description,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      label: Text('description'),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: TextButton(
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(100, 3, 100, 3),
                    child: Text("ajoute un service"),
                  ),
                  onPressed: () => fanctionAjouteService(),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
