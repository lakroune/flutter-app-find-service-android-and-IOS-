import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/service.dart';
import 'package:s5/class/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Artisan extends User {
  List<Service> services;

  Artisan(
      {required int idUser,
      required String password,
      required String ville,
      required String email,
      required String nomUser,
      required String numTele,
      required String photo,
      required String prenomUser,
      required String  dateCreation,
      this.services = const [],
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
             dateCreation:dateCreation,
            type: type);

  factory Artisan.fromJson(Map<String, dynamic> json) {
      return Artisan(
      idUser: int.parse(json['idUser']),
      nomUser: json['nomUser'],
      email: json['email'],
      password: json['password'],
      photo: json['photo']??'profile.jpg',
      type: json['typeUser'],
      numTele: json['numTele']??'',
      prenomUser: json['prenomUser'],
      ville: json['ville']??'',
      dateCreation: json[' dateCreation'],
      
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> CreerService(
      {required String nomService,
      required double prix,
      required int categorie}) async {
    // ignore: unnecessary_null_comparison
    if (nomService == null || prix == null || categorie == null) return;
    var response = await http
        .post(Uri.parse(MYURL('crreService.php')), body: {
      "nomService": ' nomService',
      "prix": prix.toString(),
      "idArtisan": idUser.toString(),
      "idCategorie": categorie.toString(),
    });
    var data = jsonDecode(response.body);
    // ignore: avoid_print
    print(data);
  }

  Future<String> supprimerService({required int idService}) async {
    if (idService == null) return'error';
    var response = await http.post(
        Uri.parse(MYURL('supprimerService.php')),
        body: {
          "idService": idService.toString(),
        });
    var data = jsonDecode(response.body);
    return data;
  }


  Future changerPhotoProfile({ required String nomPhoto,required String image}) async {
    if (nomPhoto == null || image ==null) return;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse(MYURL('modifierImageProfile.php')),
        body: {
          "nom": nomPhoto,
          "image": image,
          "idUser": preferences.getInt("idUser").toString(),
        });
    String data = json.decode(response.body);
    print(data);
    return data;
  }

    Future changerTele({ required String tele,}) async {
    if (tele .length !=10) return;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse(MYURL('modifierTele.php')),
        body: {
          "tele": tele,
          "idUser": preferences.getInt("idUser").toString(),
        });
    String data = json.decode(response.body);
    print(data);
    return data;
  }
    Future changerVile({ required String ville,}) async {
    if (ville.length ==0) return;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(
        Uri.parse(MYURL('modifierVille.php')),
        body: {
          "ville": ville,
          "idUser": preferences.getInt("idUser").toString(),
        });
    String data = json.decode(response.body);
    print(data);
    return data;
  }
}

// ismail lakroune 10/03/2022
////