import 'dart:convert';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:s5/class/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Client extends User {
  Client(
      {required int idUser,
      required String password,
      required String ville,
      required String email,
      required String nomUser,
      required String numTele,
      required String photo,
      required String prenomUser,
      required String dateCreation,
      required String type})
      : super(
            idUser: idUser,
            password: password,
            ville: ville,
            email: email,
            nomUser: nomUser,
            numTele: numTele,
            photo: photo,
            prenomUser: prenomUser,
            dateCreation: dateCreation,
            type: type);

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      idUser: int.parse(json['idUser']),
      nomUser: json['nomUser'],
      email: json['email'],
      password: json['password'],
      photo: json['photo'] ?? "profile.jpg",
      type: json['typeUser'],
      numTele: json['numTele'] ?? "",
      prenomUser: json['prenomUser'],
      ville: json['ville'] ?? "",
      dateCreation: json['dateCreation'],
    );
  }
  creeCompte(
      {required String nom,
      required String prenom,
      required String email,
      required String password}) async {
    if (nom.length <= 1 ||
        prenom.length <= 1 ||
        email.length <= 6 ||
        password.length < 6) {
      return "errorSaisi";
    }
    var response = await http.post(Uri.parse(MYURL('creeCompte.php')), body: {
      "nomUser": nom,
      "prenomUser": prenom,
      "email": email,
      "password": password,
    });
    var data = jsonDecode(response.body);
    if (data == "error") return "email existe";
    return await seConnecter(email: email, password: password);
  }

  Future<void> toArtisan() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(MYURL('toArtisan.php')), body: {
      "idUser": preferences.getInt('idUser').toString(),
    });
    var data = jsonDecode(response.body);
    print(data);
  }

  Future envoyerMessage(
      {required String message, required int idService}) async {
    if (message.length <= 1 || idService == null) return "errorSaisi";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response =
        await http.post(Uri.parse(MYURL('envoyerMessage.php')), body: {
      "message": message,
      "idService": idService.toString(),
      "idClient": preferences.getInt("idUser").toString(),
    });
    var data = jsonDecode(response.body);
    print(data);
    return data;
  }

  Future<void> evaluerService(
      {required int idService,
      required int nombreEtoile,
      required String comantaire}) async {
    if (nombreEtoile == 0 || idService == 0 || comantaire.length < 2) return;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response =
        await http.post(Uri.parse(MYURL('evaluerService.php')), body: {
      "nombreEtoile": nombreEtoile.toString(),
      "idService": idService.toString(),
      "idClient": preferences.getInt("idUser").toString(),
      "comantaire": comantaire,
    });
  }

  Future<List<Service>> rechercherService(
      {required String nomService, required String categorie}) async {
    if (nomService.isEmpty || categorie.isEmpty) return [];
    var response =
        await http.post(Uri.parse(MYURL('rechercherService')), body: {
      "nomService": nomService,
      "categorie": categorie,
    });
    var data = jsonDecode(response.body).toList();
    List<Service> service = [];
    for (int i = 0; i < data.lenght; i++) {
      service.add(Service.fromJson(data[i]));
    }
    return service;
  }

  Future<List<Service>> getService() async {
    var response = await http.get(Uri.parse(MYURL('getServices.php')));
    var data = jsonDecode(response.body).toList();
    List<Service> services = [];
    if (data == null) {
      return [];
    }
    for (int i = 0; i < data.lenght; i++) {
      services.add(Service.fromJson(data[i]));
    }
    return services;
  }

  Future seConnecter({required String email, required String password}) async {
    if (email.length < 6 || password.length <= 5) return "nonValide";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(MYURL('login.php'));
    final response = await http.post(url, body: {
      "email": email,
      "password": password,
    });
    var data = json.decode(response.body);
    if (data != "error") {
      var data = json.decode(response.body).toList();
      prefs.setInt('idUser', int.parse(data[0]["idUser"]));
      prefs.setString('nomUser', data[0]["nomUser"]);
      prefs.setString('prenomUser', data[0]["prenomUser"]);
      prefs.setString('email', data[0]["email"]);
      prefs.setString('password', data[0]["password"]);
      prefs.setString('typeUser', data[0]["typeUser"]);
      prefs.setString('photo', data[0]["photo"] ?? 'profile.jpg');
      prefs.setString('numTele', data[0]["numTele"] ?? '');
      prefs.setString('ville', data[0]["ville"] ?? '');
      return "seconnecter";
    }
    return "error";
  }

  selectionService(int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("idServiceM", val);
    return "ok";  
  }

  deconnecter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('idUser', 0);
    prefs.setString('nomUser', '');
    prefs.setString('prenomUser', '');
    prefs.setString('email', '');
    prefs.setString('password', '');
    prefs.setString('typeUser', '');
    prefs.setString('photo', 'profile.jpg');
    prefs.setString('numTele', '');
    prefs.setString('ville', '');
  }

  saveService({required int idService}) async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var response =
        await http.post(Uri.parse(MYURL("sauvegardeService.php")), body: {
      "idClient": peres.getInt("idUser").toString(),
      "idService": idService.toString(),
    });
    var data = jsonDecode(response.body);
    print(data);
  }

  
  reserveService({required int idService}) async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var response = await http
        .post(Uri.parse(MYURL("reserveService.php")), body: {
      "idClient": peres.getInt("idUser").toString(),
      "idService": idService.toString(),
    });
    var data = jsonDecode(response.body);
    return data;
  }

  anullerSaveService({required int idService}) async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var response = await http
        .post(Uri.parse(MYURL("annulerSauvegardeService.php")), body: {
      "idClient": peres.getInt("idUser").toString(),
      "idService": idService.toString(),
    });
    print(idService);
    var data = jsonDecode(response.body);
    print(data);
  }
}



// // ismail lakroune 10/03/2022