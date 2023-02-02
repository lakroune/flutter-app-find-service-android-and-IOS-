class Evaluer {
  int idClient;
  int nombreEtoile;
  String comantaire;
  String nomUser;
  String prenomUser;
  String photo;
  Evaluer({
    required this.comantaire,
    required this.idClient,
    required this.nombreEtoile,
    required this.nomUser,
    required this.photo,
    required this.prenomUser,
  });

  factory Evaluer.fromJson(Map<String, dynamic> json) {
    return Evaluer(
      comantaire: json['comantaire'],
      idClient: int.parse(json['idClient']),
      nombreEtoile: int.parse(json['nombreEtoile']),
      nomUser: json['nomUser'],
      prenomUser: json['prenomUser'],
      photo: json['photo']??"profile.jpg",
    );
  }
}

