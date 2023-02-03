import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:s5/MyScreen/MyWidget/MyMenuBar.dart';
import 'package:s5/MyScreen/MyWidget/MyMenuBarAdmin.dart';
import 'package:s5/MyScreen/MyWidget/MyOption.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogo.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogoAsset.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  static const screanRoute = "ProfilePage";

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ImagePicker picker = ImagePicker();
  var numTeleC = TextEditingController();
  var villeC = TextEditingController();
  File? profileImage;
  var nomUser,
      prenomUser,
      usernameUser,
      idUser,
      numTele,
      ville,
      photo,
      nomPhoto,
      image,
      typeUser;
  infoArtisan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs.getInt('idUser');
      nomUser = prefs.getString('nomUser');
      prenomUser = prefs.getString('prenomUser');
      usernameUser = prefs.getString('email');
      typeUser = prefs.getString('type');
      photo = prefs.getString('photo');
      numTele = prefs.getString('numTele');
      ville = prefs.getString("ville");
    });
    // getdata();
  }

  var myservice;
  getdata() async {
    try {
      SharedPreferences peres = await SharedPreferences.getInstance();
      var url = Uri.parse(MYURL('myService.php'));
      var response = await http.post(url, body: {
        "idUser": peres.getInt("idUser").toString(),
      });
      var data = jsonDecode(response.body);
      if (data == "error") return;
      data = data.toList();
      print(data);
      List<Service> myarticle = [];
      for (int i = 0; i < data.length; i++) {
        myarticle.add(Service.fromJson(data[i]));
      }

      setState(() {
        myservice = myarticle;
      });
    } catch (e) {
      messageError("vriefier la connexion");
      setState(() {
        photo = null;
      });
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

  Future getImageProfile() async {
    XFile? pickerFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(pickerFile!.path);
    });
    nomPhoto = profileImage!.path.split("/").last;
    image = base64Encode(profileImage!.readAsBytesSync());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    infoArtisan();
    if(typeUser=="artisan") {
      getdata();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Text(""),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences pere = await SharedPreferences.getInstance();
                if (profileImage != null) {
                  await artisan.changerPhotoProfile(
                      nomPhoto: nomPhoto, image: image);
                  pere.setString("photo", nomPhoto);
                  profileImage=null;
                   Fluttertoast.showToast(
                        msg: "L'image de profile a changé.",
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green);
                  
                }
                if (villeC.text.length > 2) {
                  await artisan.changerVile(ville: villeC.text);
                  pere.setString("ville", villeC.text);
                  villeC.clear();
                  Fluttertoast.showToast(
                      msg: "L'adresse géographique a changé.",
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.green);
                }
                if (numTeleC.text.length > 0) {
                  if (numTeleC.text.length == 10) {
                    await artisan.changerTele(tele: numTeleC.text);
                    pere.setString("numTele", numTeleC.text);
                    numTeleC.clear();
                    Fluttertoast.showToast(
                        msg: "Le numéro de téléphone a changé.",
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "verifier le numéro de telephone",
                      gravity: ToastGravity.TOP);
                }

                infoArtisan();
              },
              icon: Icon(Icons.save))
        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      if (profileImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            File(profileImage!.path),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        )
                      else if (photo != null)
                        ProfileLogo(
                          photo: photo,
                          size: 150,
                          radius: 100,
                        )
                      else
                        const ProfileLogoAsset(photo: "profile.jpg", size: 150),
                      Positioned(
                        bottom: 50,
                        right: 8,
                        child: Stack(
                          children: [
                            IconButton(
                                onPressed: () => getImageProfile(),
                                icon: const Icon(
                                  Icons.add_a_photo,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            nomUser ?? "...",
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            prenomUser == null ? "..." : prenomUser,
                            style: const TextStyle(fontSize: 30),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (numTele != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: TextField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.center,
                    controller: numTeleC,
                    decoration: InputDecoration(
                      hintText: numTele,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  // trailing: const Icon(Icons.change_circle),
                ),
              ),
            if (ville != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.location_history),
                  title: TextField(
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    controller: villeC,
                    decoration: InputDecoration(
                      hintText: ville,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  // trailing: const Icon(Icons.edit_location_alt),
                ),
              ),
            if (usernameUser != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(Icons.mail),
                  title: TextField(
                    keyboardType: TextInputType.none,
                    textAlign: TextAlign.center,
                    enableInteractiveSelection: true,
                    // controller: nomCategorie,
                    decoration: InputDecoration(
                      hintText: usernameUser,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
              ),

            //2 partie

            if (myservice != null  && typeUser=="artisan")
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: [
                        for (int i = 0; i < myservice.length; i++)
                          Card(
                            color: const Color.fromARGB(255, 143, 195, 238),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: ProfileLogo(
                                    photo: photo,
                                    size: 60,
                                  ),
                                  subtitle: Text(myservice[i].nomService),
                                  title: Text(nomUser + " " + prenomUser),
                                  trailing: Mybottonlist(
                                    idService: myservice[i].idService,
                                  ),
                                ),
                                Row(
                                  children: [],
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
                                          width: 360,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Text(myservice[i].datePub),
                                  trailing: Text(
                                      myservice[i].prix.toString() + " Dh"),
                                ),
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
