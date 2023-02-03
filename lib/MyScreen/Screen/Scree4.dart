import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogoAsset.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../class/client.dart';
import '../../class/post.dart';

class Screen4 extends StatefulWidget {
   static const screanRoute = "Screen4";
  
  const Screen4({Key? key}) : super(key: key);

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  TextEditingController numTele = TextEditingController();
  TextEditingController ville = TextEditingController();
  ImagePicker picker = ImagePicker();
  var monCompte;
  var imageFile;
  getData() async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var response =
        await http.post(Uri.parse(MYURL("getInformationMonCompte.php")), body: {
      "idUser": peres.getInt("idUser").toString(),
    });
    var data = jsonDecode(response.body);
    if (data == null) return;
    print(data);
    Client clt = Client.fromJson(data);
    setState(() {
      monCompte = clt;
    });
  }

  sendinfo() async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    if (numTele.text == '' || ville.text == '' || imageFile == null) return false;

    var nomImage = "", image = "";
    setState(() {
      if (imageFile != null) {
        nomImage = imageFile!.path.split("/").last;
        image = base64Encode(imageFile!.readAsBytesSync());
      }
    });
    var response =
        await http.post(Uri.parse(MYURL("sendInfoCompte.php")), body: {
      "idUser": peres.getInt("idUser").toString(),
      "image": image,
      "nomImage": nomImage,
      "numTele": numTele.text,
      "ville": ville.text,
    });
    var data = jsonDecode(response.body);
    print(data);
    if (data == "success") return true;
    if (data == "error") return false;
  }

  Future getImageProfile() async {
    XFile? pickerFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickerFile!.path);
    });
  }

  valide() async {
    if (await sendinfo() == false) {
      Fluttertoast.showToast(msg: "remplir tout les champs");
    } else if (await sendinfo() == true) {
      Navigator.pushNamed(context, FirstPage.screanRoute);
    }
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blueAccent,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    if (imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          File(imageFile!.path),
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      ProfileLogoAsset(photo: "profile.jpg", size: 150),
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
                if (monCompte != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            monCompte.nomUser,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            monCompte.prenomUser ?? "",
                            style: const TextStyle(fontSize: 30),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: TextField(
                  controller: numTele,
                  decoration: const InputDecoration(
                      label: Text(
                        'numéro Tele',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      hintText: ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: TextField(
                  controller: ville,
                  decoration: const InputDecoration(
                      label: Text(
                        'ville',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      hintText: 'ville'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 157, 196, 160),
                    ),
                  ),
                  label: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("valider"),
                  ),
                  onPressed: () => valide(),
                  icon: const Icon(Icons.upload),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
