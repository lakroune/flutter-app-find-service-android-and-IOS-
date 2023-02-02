import 'dart:convert';
import 'package:s5/class/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Message {
  int idMessage;
  int idUser1;
  int idUser2;
  int idService;
  String message;
  String dateMessage;

  Message({
    required this.idMessage,
    required this.idUser1,
    required this.idUser2,
    required this.idService,
    required this.dateMessage,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      idMessage: int.parse(json['idMessage']),
      idUser1: int.parse(json['idUser1']),
      idUser2: int.parse(json['idUser2']),
      idService: int.parse(json['idService']),
      dateMessage: json['dateMessage'],
      message: json['message'],
    );
  }

 Future<List<Message>> getMessage() async {
    SharedPreferences peres = await SharedPreferences.getInstance();
    var url = Uri.parse(MYURL('getMessage.php'));
    final response = await http.post(url, body: {
      "idClient": (peres.getInt("idCilent")).toString(),
      "idService": (peres.getInt("idService")).toString(),
    });
    var data = jsonDecode(response.body).toList();
    List<Message> message = [];
    for (int i = 0; i < data.length; i++) {
      message.add(Message.fromJson(data[i]));
    }
    return message;
  }
  
}
