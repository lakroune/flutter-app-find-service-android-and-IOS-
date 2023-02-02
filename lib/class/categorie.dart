class Categorie {
  int idCategorie;
  String nomCategorie;
  String imageCategorie;
  Categorie({required this.idCategorie, required this.nomCategorie,required this.imageCategorie});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      idCategorie:int.parse(json['idCategorie']),
      nomCategorie: json['nomCategorie'] ,
      imageCategorie:json['imageCategorie'],
    );
  }
}
