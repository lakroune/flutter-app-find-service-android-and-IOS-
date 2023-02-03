import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s5/MyScreen/Screen/Racine.dart';
import 'package:s5/class/post.dart';

class LoginPage extends StatefulWidget {
   static const screanRoute = "LoginPage";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  valider() async {
    var resultat =
        await client.seConnecter(email: email.text, password: password.text);
    if (resultat == "nonValide") {
      Fluttertoast.showToast(
        msg: "email ou mot de pass non valider",
        gravity: ToastGravity.CENTER,
      );
    } else if (resultat == "seconnecter") {
      Navigator.popAndPushNamed(context, Racine.screanRoute);
    } else if (resultat == "error") {
      Fluttertoast.showToast(
        msg: "votre compte  n'existe pas",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          elevation: 0,
          title: const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              const Center(child: Image(image: AssetImage("assets/img/9.png"))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                      label: Text(
                        'email',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      hintText: 'exemple@email.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: password,
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
                      hintText: '6 caractere'),
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
                  onPressed: () => valider(),
                  icon: const Icon(Icons.lock_open),
                ),
              ),
            ],
          ),
        ));
  }
  
}
