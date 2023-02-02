import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:s5/class/categorie.dart';
import 'package:s5/class/client.dart';
import 'package:s5/class/admin.dart';
import 'package:s5/class/artisan.dart';
import 'package:s5/class/image.dart';
import 'package:s5/class/message.dart';
import 'package:s5/class/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Post {
  List<Service> services;
  List<Artisan> artisans;
  Post({this.artisans = const [], this.services = const []});
}

class Etat {
  String etat;
  Etat({required this.etat});
  factory Etat.fromJson(Map<String, dynamic> json) {
    return Etat(etat: json['etat']);
  }
}

String myURL = 'https://lakroune.000webhostapp.com/app/';
String MYURL(String ch) {
  return 'https://lakroune.000webhostapp.com/app/' + ch;
}

String MYURLIMG(String ch) {
  return 'https://lakroune.000webhostapp.com/app/images/' + ch;
}

String UrlImgLoc1(String url) {
  return "assets/img" + url;
}

String UrlImgLoc(String url) {
  return url;
}

mackCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("ss");
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

verifierLaConnexion() async {
  var response = await http.get(Uri.parse(MYURL("verifierLaConnexion.php")));
  var data = jsonDecode(response.body);
  print(data);
  if (data == "connecter") return true;
  return false;
}

queCeQueReserve() async {
  try {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var response =
        await http.post(Uri.parse(MYURL("queCeQueReserve.php")), body: {
      "idUser": peres.getInt("idUser").toString(),
      "idService": peres.getInt("idService").toString(),
    });
    var data = jsonDecode(response.body);
    if (data == "true") return true;
    return false;
  } catch (e) {
    return false;
  }
}

class OptionRechercher {
  final String nom, image, option;
  final int id;
  OptionRechercher(
      {required this.id,
      required this.image,
      required this.nom,
      required this.option});
}

List<OptionRechercher> listOptionRecherche = [
  OptionRechercher(
      id: 1, image: "o2.jpg", nom: "nom service", option: "normal"),
  OptionRechercher(id: 2, image: "2.jpg", nom: "nom l'artisan", option: "artisan"),
  // OptionRechercher(id: 3, image: "o1.png", nom: "prix", option: "prix"),
  OptionRechercher(
      id: 4, image: "1.jpg", nom: "le plus proche", option: "proche"),
];

Client client = Client(
  idUser: 2,
  password: 'password',
  ville: 'ville',
  email: 'email',
  nomUser: 'nomUser',
  numTele: 'numTele',
  photo: 'profile.jpg',
  prenomUser: 'prenomUser',
  type: 'client',
  dateCreation: 'dateCreation',
);

Admin admin = Admin(
  idUser: 3,
  password: 'password',
  ville: 'ville',
  email: 'email',
  nomUser: 'nomUser',
  numTele: 'numTele',
  photo: 'photo',
  prenomUser: 'prenomUser',
  type: 'admin',
  dateCreation: 'dateCreation',
);

Artisan artisan = Artisan(
  idUser: 1,
  password: 'password',
  ville: 'ville',
  email: 'email',
  nomUser: 'nomUser',
  numTele: 'numTele',
  photo: 'photo',
  prenomUser: 'prenomUser',
  type: 'artisan',
  dateCreation: 'dateCreation',
);

Service service = Service(
    idArtisan: 01,
    nomService: 'nomService',
    idService: 01,
    prix: 10,
    idCategorie: 1,
    images: [],
    datePub: 'datePub',
    description: 'kk');

List<Image> listImg1 = [
  Image(source: 'assets/img/1.jpg', idService: 1, idImage: 1),
  Image(source: 'assets/img/2.jpg', idService: 1, idImage: 2),
  Image(source: 'assets/img/3.jpg', idService: 1, idImage: 3),
];
List<Image> listImg2 = [
  Image(source: 'assets/img/2.jpg', idService: 1, idImage: 1),
  Image(source: 'assets/img/4.jpg', idService: 1, idImage: 2),
  Image(source: 'assets/img/5.jpg', idService: 1, idImage: 3),
];
List<Image> listImg3 = [
  Image(source: 'assets/img/3.jpg', idService: 1, idImage: 1),
  Image(source: 'assets/img/7.jpg', idService: 1, idImage: 2),
  Image(source: 'assets/img/5.jpg', idService: 1, idImage: 3),
];
List<Image> listImg4 = [
  Image(source: 'assets/img/4.jpg', idService: 1, idImage: 1),
  Image(source: 'assets/img/4.jpg', idService: 1, idImage: 2),
  Image(source: 'assets/img/5.jpg', idService: 1, idImage: 3),
];
List<Image> listImg5 = [
  Image(source: 'assets/img/5.jpg', idService: 1, idImage: 1),
  Image(source: 'assets/img/7.jpg', idService: 1, idImage: 2),
  Image(source: 'assets/img/5.jpg', idService: 1, idImage: 3),
];
List<Image> listImg6 = [
  Image(source: 'assets/img/6.jpg', idService: 1, idImage: 1),
  Image(source: 'assets/img/4.jpg', idService: 1, idImage: 2),
  Image(source: 'assets/img/5.jpg', idService: 1, idImage: 3),
];
List<Image> listImg7 = [
  Image(source: 'assets/img/7.jpg', idService: 1, idImage: 1),
  Image(source: 'assets/img/7.jpg', idService: 1, idImage: 2),
  Image(source: 'assets/img/5.jpg', idService: 1, idImage: 3),
];

List<Message> listMessage = [
  Message(
      idMessage: 1,
      idUser1: 2,
      idUser2: 3,
      idService: 1,
      dateMessage: "",
      message: "message1"),
  Message(
      idMessage: 2,
      idUser1: 3,
      idUser2: 2,
      idService: 1,
      dateMessage: "",
      message: "message2"),
  Message(
      idMessage: 3,
      idUser1: 2,
      idUser2: 3,
      idService: 1,
      dateMessage: "",
      message: "message3"),
  Message(
      idMessage: 4,
      idUser1: 2,
      idUser2: 3,
      idService: 1,
      dateMessage: "",
      message: "message4"),
  Message(
      idMessage: 5,
      idUser1: 3,
      idUser2: 2,
      idService: 1,
      dateMessage: "",
      message: "message5"),
  Message(
      idMessage: 6,
      idUser1: 3,
      idUser2: 2,
      idService: 1,
      dateMessage: "",
      message: "message6"),
  Message(
      idMessage: 7,
      idUser1: 2,
      idUser2: 3,
      idService: 1,
      dateMessage: "",
      message: "message7"),
  Message(
      idMessage: 8,
      idUser1: 3,
      idUser2: 2,
      idService: 1,
      dateMessage: "",
      message: "message8"),
  Message(
      idMessage: 9,
      idUser1: 2,
      idUser2: 3,
      idService: 1,
      dateMessage: "",
      message: "message9"),
  Message(
      idMessage: 10,
      idUser1: 3,
      idUser2: 2,
      idService: 1,
      dateMessage: "",
      message: "message10"),
  Message(
      idMessage: 11,
      idUser1: 2,
      idUser2: 3,
      idService: 1,
      dateMessage: "",
      message: "message11"),
  Message(
      idMessage: 12,
      idUser1: 3,
      idUser2: 2,
      idService: 1,
      dateMessage: "",
      message: "message12"),
  Message(
      idMessage: 13,
      idUser1: 3,
      idUser2: 2,
      idService: 1,
      dateMessage: "",
      message: "message13"),
  Message(
      idMessage: 14,
      idUser1: 2,
      idUser2: 3,
      idService: 1,
      dateMessage: "",
      message: "message14"),
];
