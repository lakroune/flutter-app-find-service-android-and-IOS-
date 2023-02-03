import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/MyMenuBarAdmin.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogo.dart';
import 'package:s5/class/categorie.dart';
import 'package:s5/class/post.dart';

class GestionCategorie extends StatefulWidget {
  static const screanRoute = "GestionCategorie";
  const GestionCategorie({Key? key}) : super(key: key);

  @override
  State<GestionCategorie> createState() => _GestionCategorieState();
}

class _GestionCategorieState extends State<GestionCategorie> {
  var listCategorie,lanlist=0, val = 0;
  var nomCategorie = TextEditingController();
  var nomCategorie1 = TextEditingController();
  var imageFile, imageFile1;
  var picker = ImagePicker();

  getData() async {
    var data = await admin.getCategorie();
    if (data == "error") return;
    data = data.toList();
    List<Categorie> listCg = [];
    for (var val in data) {
      listCg.add(Categorie.fromJson(val));
    }
    setState(() {
      listCategorie = listCg;
      lanlist=listCg.length;
    });
  }

  faireTraitment(
      {required String mes,
      required int idCategorie,
      String etat = 'modifier'}) {
    Alert(
      context: context,
      title: mes,
      buttons: [
        DialogButton(
          color: Colors.green,
          onPressed: () async {
            if (etat == 'modifier') {
              await validerLaModification(idCategorie: idCategorie);
            } else if (etat == 'supprimer') {
            
              await admin.suppremeCategorie(idCategorie: idCategorie);
               setState(() {
                lanlist--;
             });
            }
            getData();
            Navigator.pop(context);
          },
          child: Text(
            etat,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  ajouteCategor() {
    Alert(
      context: context,
      content: Column(
        children: [
          if (imageFile1 != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => getImageProfile1(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.file(
                    File(imageFile1!.path),
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () => getImageProfile1(),
                  child: SizedBox(
                    height: 130,
                    width: 130,
                    child: Text(" select image"),
                  )),
            ),
          TextField(
            controller: nomCategorie1,
            decoration: const InputDecoration(
              hintText: "nom categorie",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: Colors.green,
          onPressed: () async {
            await ajouteCategorieFun();
            getData();
            Navigator.pop(context);
          },
          child: Text(
            'ajoute',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  getImageProfile() async {
    XFile? pickerFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickerFile!.path);
    });
  }

  getImageProfile1() async {
    XFile? pickerFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile1 = File(pickerFile!.path);
    });
  }

  _selectCategorie({required int index}) {
    setState(() {
      val = index;
      imageFile = null;
      nomCategorie.text = "";
    });
  }

  validerLaModification({required int idCategorie}) async {
    var nomImage = '';
    var image = '';
    setState(() {
      if (imageFile != null) {
        nomImage = imageFile!.path.split("/").last;
        image = base64Encode(imageFile!.readAsBytesSync());
      }
    });
    await admin.modifieCategorie(
        nomCategorie: nomCategorie.text,
        idCategorie: idCategorie,
        image: image,
        nomImage: nomImage);
  }

  ajouteCategorieFun() async {
    var nomImage = '5';
    var image = '7';
    String nomcategorie =nomCategorie1.text;
    setState(() {
      if (imageFile1 != null) {
        nomImage = imageFile1!.path.split("/").last;
        image = base64Encode(imageFile1!.readAsBytesSync());
        nomCategorie1.clear();
      }
    });
   
    await admin.ajouteCategorie(
        nomCategorie: nomcategorie, image: image, nomImage: nomImage);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        elevation: 0,
        title:const Text("Gestion des Categories"),
        leading: const MenuBarAdmin(),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              if (listCategorie != null)
                SizedBox(
                  height: 170.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: lanlist,
                    itemBuilder: (BuildContext context, int index) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () => _selectCategorie(index: index),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                MYURLIMG(listCategorie[index].imageCategorie),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 160,
                            height: 100,
                            child: Center(
                              child: Text(
                                listCategorie[index].nomCategorie,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (listCategorie != null)
                Card(
                  color: const Color.fromARGB(255, 91, 150, 250),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                if (imageFile != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.file(
                                        File(imageFile!.path),
                                        height: 130,
                                        width: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ProfileLogo(
                                      photo: listCategorie[val].imageCategorie,
                                      size: 130,
                                      radius: 30,
                                    ),
                                  ),
                                Positioned(
                                  top: 50,
                                  left: 122,
                                  child: Stack(
                                    children: [
                                      IconButton(
                                        onPressed: () => getImageProfile(),
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              controller: nomCategorie,
                              decoration: InputDecoration(
                                hintText: listCategorie[val].nomCategorie,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orange),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color.fromARGB(
                                              255, 100, 211, 146),
                                        ),
                                      ),
                                      onPressed: () => faireTraitment(
                                          mes: 'Voulez-vous enregistrer la catégorie ?',
                                          idCategorie:
                                              listCategorie[val].idCategorie),
                                      icon: const Icon(Icons.change_circle),
                                      label: const Text("enregistrer")),
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 241, 150, 143),
                                      ),
                                    ),
                                    onPressed: () => faireTraitment(
                                        mes: "Voulez-vous supprimer la catégorie ?",
                                        etat: "supprimer",
                                        idCategorie:
                                            listCategorie[val].idCategorie),
                                    icon: const Icon(Icons.clear),
                                    label: const Text("supprimer "),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //
                    ],
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
              FloatingActionButton.extended(
                  onPressed: () => ajouteCategor(),
                  label: const Text('ajoute categorie'),
                  icon: const Icon(Icons.add),
                  backgroundColor: Colors.green)
            ],
          ),
        ),
      ),
    );
  }
}
