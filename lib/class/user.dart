abstract class User {
  int idUser;
  String nomUser;
  String prenomUser;
  String photo;
  String email;
  String password;
  String ville;
  String type;
  String numTele;
  String dateCreation;

  User({
    required this.idUser,
    required this.password,
    required this.ville,
    required this.email,
    required this.nomUser,
    required this.numTele,
    required this.photo,
    required this.prenomUser,
    required this.type,
    required this.dateCreation,
  });
}
