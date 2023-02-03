import 'package:flutter/material.dart';
import 'package:s5/MyScreen/MyWidget/MyMenuBarAdmin.dart';
import 'package:s5/MyScreen/Screen/admin/GestionCompte.dart';
import 'package:s5/MyScreen/Screen/admin/gestion%20_categories.dart';
import 'package:s5/MyScreen/Screen/admin/gestion%20des%20service.dart';

class InterfaceAdmin extends StatefulWidget {
  static const screanRoute = "InterfaceAdmin";

  const InterfaceAdmin({Key? key}) : super(key: key);

  @override
  State<InterfaceAdmin> createState() => _InterfaceAdminState();
}

class _InterfaceAdminState extends State<InterfaceAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: const MenuBarAdmin(),
      ),
      body: ListView(
        children: [
          TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, GestionCompte.screanRoute),
              child:const Mycard(text: "Gestion des comptes")),
          TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, GestioService.screanRoute),
              child: const Mycard(text: "Gestion des services")),
          TextButton(
            onPressed: () => Navigator.pushNamed(context,GestionCategorie.screanRoute),
            child: const Mycard(text: "Gestion  des categories"),
          ),
        ],
      ),
    );
  }
}

class Mycard extends StatelessWidget {
  const Mycard({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 91, 150, 250),
      elevation: 0,
      child: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: TextCard(text: text)),
          ],
        ),
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  const TextCard({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }
}
