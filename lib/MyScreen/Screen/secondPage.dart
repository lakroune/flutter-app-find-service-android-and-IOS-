import 'package:flutter/material.dart';
import 'package:s5/MyScreen/Screen/Accueil.dart';
import 'package:s5/MyScreen/Screen/TroisiemmePageinscription.dart';
import 'package:s5/MyScreen/Screen/login.dart';

class SecondPage extends StatefulWidget {
    static const screanRoute = "SecondPage";

  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: const [
                    Image(image: AssetImage("assets/img/2.png")),
                    SizedBox(
                      height: 60,
                      child: Center(
                          child: Text(
                        "cree un compte",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      )),
                    ),
                    SizedBox(
                      height: 100,
                      child: Center(
                          child: Text(
                        "Nous allons vous aider à créer un compte\n en quelques étapes simples ",
                        style: TextStyle(fontSize: 16),
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, Accueil.screanRoute),
                      child: const Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          "<- Accueil",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, PageInscription1.screanRoute),
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
      ),
    );
  }
}
