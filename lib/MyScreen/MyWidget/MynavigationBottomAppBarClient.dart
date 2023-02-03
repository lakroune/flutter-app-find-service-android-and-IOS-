import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:s5/MyScreen/MyWidget/MyMenuBar.dart';
import 'package:s5/MyScreen/Screen/Accueil.dart';
import 'package:s5/MyScreen/Screen/PAgeSauvegarder.dart';
import 'package:s5/MyScreen/Screen/interfaceMessage.dart';

class MyNavicationClient extends StatefulWidget {
  const MyNavicationClient({Key? key}) : super(key: key);

  @override
  State<MyNavicationClient> createState() => _MyNavicationClientState();
}

class _MyNavicationClientState extends State<MyNavicationClient> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    SafeArea(top: true, child: Accueil()),
    MyChat(),
    SauvegardPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: const Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: MenuBar(),
        ),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
          //   child: Icon(Icons.notification_add),
          // )
        ],
        elevation: 0,
      ),
      backgroundColor: Colors.blueAccent,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        height: 46,
        items: const <Widget>[
          Icon(Icons.home),
          Icon(Icons.forum),
          Icon(Icons.favorite),
        ],
        onTap: (_selectedIndex) {
          setState(() {
            _onItemTapped(_selectedIndex);
          });
        },
      ),
    );
  }
}
