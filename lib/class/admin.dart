import 'dart:convert';
import 'package:s5/class/client.dart';
import 'package:s5/class/post.dart';
import 'package:s5/class/user.dart';
import 'package:http/http.dart' as http;

class Admin extends User {
  Admin({
    required int idUser,
    required String password,
    required String ville,
    required String email,
    required String nomUser,
    required String numTele,
    required String photo,
    required String prenomUser,
    required String dateCreation,
    required String type,
  }) : super(
            idUser: idUser,
            password: password,
            ville: ville,
            email: email,
            nomUser: nomUser,
            numTele: numTele,
            dateCreation: dateCreation,
            photo: photo,
            prenomUser: prenomUser,
            type: 'admin');

  ajouteCategorie(
      {required String nomCategorie,
      required String nomImage,
      required String image}) async {
    if (nomCategorie == "" || image == "" || nomCategorie == "") return;
    var response =
        await http.post(Uri.parse(MYURL("ajouteCategorie.php")), body: {
      "nomCategorie": nomCategorie,
      "image": image,
      "nomImage": nomImage,
    });
    var data = jsonDecode(response.body);
    print("data");
  }

  suppremeCategorie({required int idCategorie}) async {
    if (idCategorie == null) return;
    var response =
        await http.post(Uri.parse(MYURL("supprimerCategorie.php")), body: {
      "idCategorie": idCategorie.toString(),
    });
    var data = jsonDecode(response.body);
    print(data);
  }

  modifieCategorie(
      {required String nomCategorie,
      required int idCategorie,
      required String nomImage,
      required String image}) async {
    var response =
        await http.post(Uri.parse(MYURL("modifierCategorie.php")), body: {
      "nomCategorie": nomCategorie,
      "idCategorie": idCategorie.toString(),
      "image": image,
      "nomImage": nomImage,
    });
    var data = jsonDecode(response.body);
    print(data);
  }

  getCategorie() async {
    var response = await http.get(Uri.parse(MYURL("getCategorie.php")));
    var data = jsonDecode(response.body);
    return data;
  }

  accepterService({required int idService}) async {
    if (idService == null) return;
    var response =
        await http.post(Uri.parse(MYURL("accepterService.php")), body: {
      "idService": idService.toString(),
    });
    var data = jsonDecode(response.body);
    print(data);
  }

  refuserService({required int idService}) async {
    if (idService == null) return;
    var response =
        await http.post(Uri.parse(MYURL("refuserService.php")), body: {
      "idService": idService.toString(),
    });
    var data = jsonDecode(response.body);
    print(data);
  }

  accepterUser({required int idUser}) async {
    if (idUser == null) return;
    var response = await http.post(Uri.parse(MYURL('accepterUser.php')), body: {
      "idUser": idUser.toString(),
    });
    var data = jsonDecode(response.body);
    print(data);
  }

  refuserUser({required int idUser}) async {
    if (idUser == null) return;
    var response =
        await http.post(Uri.parse(MYURL('supprimerUser.php')), body: {
      "idUser": idUser.toString(),
    });
    var data = jsonDecode(response.body);
    print(data);
  }

  Future<List<Client>> listClient() async {
    var response = await http.post(Uri.parse(MYURL('listUser.php')), body: {
      "typeUser": "client",
    });
    var data = jsonDecode(response.body).toList();
    print(data);
    List<Client> clients = [];
    for (int i = 0; i < data.lenght; i++) {
      clients.add(Client.fromJson(data[i]));
    }
    return clients;
  }
}

// ismail lakroune 10/03/2022