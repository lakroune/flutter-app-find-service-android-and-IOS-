
import 'package:s5/class/image.dart';
import 'package:http/http.dart' as http;

class Service {
  int idService;
  String nomService;
  String datePub;
  int idArtisan;
  double prix;
  int idCategorie;
  String description;
  List<Image> images;

  Service({
    required this.idArtisan,
    required this.nomService,
    required this.idService,
    required this.prix,
    required this.images,
    required this.datePub,
    required this.idCategorie,
    required this.description,
  });
  factory Service.fromJson(Map<String, dynamic> json) {
    var list = json['images'] as List;
    List<Image> imagesList = list.map((e) => Image.fromJson(e)).toList();
    return Service(
      idService: int.parse(json['idService']),
      nomService: json['nomService'],
      idArtisan: int.parse(json['idArtisan']),
      datePub: json["datePub"],
      idCategorie: int.parse(json['idCategorie']),
      prix: int.parse(json['prix']).toDouble(),
      description:json["description"],
      images: imagesList,
    );
  }
}


// ismail lakroune 03/2022
// ismail lakroune 23/03/2022
// ismail lakroune 1/05/2022
