import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s5/MyScreen/Screen/Scree4.dart';
import 'package:s5/MyScreen/Screen/login.dart';
import 'package:s5/class/post.dart';

class PageInscription1 extends StatefulWidget {
    static const screanRoute = "PageInscription1";
  const PageInscription1({Key? key}) : super(key: key);

  @override
  State<PageInscription1> createState() => _PageInscription1State();
}

class _PageInscription1State extends State<PageInscription1> {
  TextEditingController email = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController nomUser = TextEditingController();
  TextEditingController prenomUser = TextEditingController();
  suivant() async {
    var resultat = await client.creeCompte(
        nom: nomUser.text,
        prenom: prenomUser.text,
        email: email.text,
        password: password1.text);
    if (resultat == "email existe") {
      Fluttertoast.showToast(msg: "email existe", gravity: ToastGravity.CENTER);
    } else if (resultat == "seconnecter") {
      Navigator.pushNamed(context, Screen4.screanRoute);
    } else if (resultat == "errorSaisi") {
      Fluttertoast.showToast(
          msg: "remplir tout les champs",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: Center(
            child: Text(
          "inscription ",
          style: TextStyle(fontSize: 27, color: Colors.white),
        )),
      ),
      body: ListView(
        children: [
          const Image(
            image: AssetImage("assets/img/7.png"),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nomUser,
                    decoration: const InputDecoration(
                      label: Text(
                        'nom',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: 'nom',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: prenomUser,
                    decoration: const InputDecoration(
                        label: Text(
                          'prenom',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        hintText: 'prenom'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: email,
                    decoration: const InputDecoration(
                        label: Text(
                          'e-mail',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        hintText: 'example@email.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: password1,
                    decoration: const InputDecoration(
                        label: Text(
                          'mot de pass',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: '6 caratere'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: password2,
                    decoration: const InputDecoration(
                        label: Text(
                          'confermer',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: '6 caratere'),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, LoginPage.screanRoute),
                          child: const Padding(
                            padding: EdgeInsets.all(30),
                            child: Text("<- login",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => suivant(),
                          child: const Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "suivant ->",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
