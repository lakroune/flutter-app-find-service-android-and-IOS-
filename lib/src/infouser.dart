import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:s5/MyScreen/MyWidget/ProfileLogoAsset.dart';
import 'package:s5/MyScreen/Screen/Accueil.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/class/client.dart';
import 'package:s5/class/post.dart';
import 'package:s5/src/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widget/bezierContainer.dart';

class InfoUser extends StatefulWidget {
  static const screanRoute = "InfoUser";
  InfoUser({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Accueil.screanRoute);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Accueil',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return TextButton(
      onPressed: () => valide(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 204, 175, 132),
                  Color.fromARGB(255, 143, 138, 134)
                ])),
        child: Text(
          'valider',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'creer un compte',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              's’inscrire ',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'L',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)),
          children: [
            TextSpan(
              text: 'OG',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'IN',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
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
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "numero tele",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  controller: numTele,
                  obscureText: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "ville",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  controller: ville,
                  obscureText: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true))
            ],
          ),
        )
      ],
    );
  }

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
    if (numTele.text == '' || ville.text == '' || imageFile == null)
      return false;

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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      // Container(
                      //   padding: EdgeInsets.symmetric(vertical: 10),
                      //   alignment: Alignment.centerRight,
                      //   child: Text('Forgot Password ?',
                      //       style: TextStyle(
                      //           fontSize: 14, fontWeight: FontWeight.w500)),
                      // ),
                      // _divider(),
                      // _facebookButton(),
                      SizedBox(height: height * .055),
                      // _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));
  }
}
