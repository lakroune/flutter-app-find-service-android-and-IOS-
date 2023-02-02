// ismail lakroune 
// le 02/2020 à 06/2022 


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:s5/MyScreen/Screen/Accueil.dart';
import 'package:s5/MyScreen/Screen/AjouteService.dart';
import 'package:s5/MyScreen/Screen/BoitMessage.dart';
import 'package:s5/MyScreen/Screen/BoitMessageService.dart';
import 'package:s5/MyScreen/Screen/FristPage.dart';
import 'package:s5/MyScreen/Screen/PageMessage.dart';
import 'package:s5/MyScreen/Screen/ProfilePage.dart';
import 'package:s5/MyScreen/Screen/Racine.dart';
import 'package:s5/MyScreen/Screen/Scree4.dart';
import 'package:s5/MyScreen/Screen/ServiceInfo.dart';
import 'package:s5/MyScreen/Screen/ServiceinfoCategorie.dart';
import 'package:s5/MyScreen/Screen/TroisiemmePageLogin.dart';
import 'package:s5/MyScreen/Screen/TroisiemmePageinscription.dart';
import 'package:s5/MyScreen/Screen/admin/GestionCompte.dart';
import 'package:s5/MyScreen/Screen/admin/gestion%20_categories.dart';
import 'package:s5/MyScreen/Screen/admin/gestion%20des%20service.dart';
import 'package:s5/MyScreen/Screen/inscription.dart';
import 'package:s5/MyScreen/Screen/admin/interfaceAdmin.dart';
import 'package:s5/MyScreen/Screen/pageMessageArtisan.dart';
import 'package:s5/MyScreen/Screen/resurve.dart';
import 'package:s5/MyScreen/Screen/secondPage.dart';
import 'package:s5/src/infouser.dart';
import 'package:s5/src/loginPage.dart';
import 'package:s5/src/welcomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' application intermediation entre les clients et les Artisans ',
      initialRoute: FirstPage.screanRoute,
      routes: {
        "w":(context) => WelcomePage(),
        FirstPage.screanRoute: (context) => const FirstPage(),
        SecondPage.screanRoute: (context) => const SecondPage(),
        Inscription.screanRoute: (context) => const Inscription(),
        LoginPage.screanRoute: (context) =>   LoginPage(),
        PageInscription1.screanRoute: (context) => const PageInscription1(),
        PageLogin1.screanRoute: (context) => const PageLogin1(),
        Screen4.screanRoute: (context) => const Screen4(),
        Racine.screanRoute: (context) => const Racine(),
        Accueil.screanRoute: (context) => const Accueil(),
        AjouteService.screanRoute: (context) => const AjouteService(),
        BoitMessage.screanRoute: (context) => const BoitMessage(),
        InfoService.screanRoute: (context) => const InfoService(),
        ServiceinfoCategorie.screanRoute: (context) =>
            const ServiceinfoCategorie(),
        MyMessage.screanRoute: (context) => const MyMessage(),
        MymessageArtisan.screanRoute: (context) => const MymessageArtisan(),
        BoitMessageService.screanRoute: (context) => const BoitMessageService(),
        ReservePages.screanRoute: (context) => const ReservePages(),
        InterfaceAdmin.screanRoute: (context) => const InterfaceAdmin(),
        GestioService.screanRoute: (context) => const GestioService(),
        GestionCompte.screanRoute: (context) => const GestionCompte(),
        GestionCategorie.screanRoute: (context) => const GestionCategorie(),
        InfoUser.screanRoute:(context) =>  InfoUser(),
        ProfilePage.screanRoute:(context) => const ProfilePage(),
      },
    );
  }
}
