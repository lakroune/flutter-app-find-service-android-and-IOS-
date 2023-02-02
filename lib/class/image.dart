class Image {
  int idImage;
  String source;
  int idService;
  Image({required this.source, required this.idService, required this.idImage});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      source: json['source'],
      idImage: int.parse(json['idImage']),
      idService: int.parse(json['idService']),
    );
  }
}
// ismail lakroune 03/2022
// ismail lakroune 03/2022
