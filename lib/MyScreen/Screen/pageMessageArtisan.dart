import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:s5/class/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MymessageArtisan extends StatefulWidget {
  static const screanRoute = "MymessageArtisan";
  const MymessageArtisan({Key? key}) : super(key: key);
  @override
  _MymessageArtisanState createState() => _MymessageArtisanState();
}

class _MymessageArtisanState extends State<MymessageArtisan> {
  final messageController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  String? messageText;
  int? idService, idUser, idClient;

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getInt("idUser");
      idClient = preferences.getInt("idClient");
      idService = preferences.getInt("idServiceM");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: _fireStore
                          .collection('messages$idClient$idService')
                          .orderBy("time")
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<CardMessage> listemessage = [];

                        final messages = snapshot.data!.docs.reversed;
                        for (var message in messages) {
                          final mes = message.get('message');
                          final temp = message.get('time');
                          final mesaut = message.get('idUser');

                          final cellmessage = CardMessage(
                            email: mesaut.toString(),
                            text: mes,
                            ismy: idUser == mesaut,
                            time: temp ?? Timestamp.now(),
                          );
                          listemessage.add(cellmessage);
                        }
                        return Expanded(
                          child: ListView(
                            reverse: true,
                            children: listemessage,
                          ),
                        );
                      }),
                  if (idClient != null)
                    Container(
                    
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.blueAccent, width: 3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              onChanged: (value) {
                                messageText = value.toString();
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                hintText: ".....",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (messageController.text != "") {
                                _fireStore
                                    .collection('messages$idClient$idService')
                                    .add({
                                  'idUser': idUser,
                                  "idService": idService,
                                  'message': messageText,
                                  'time': FieldValue.serverTimestamp(),
                                });
                                client.envoyerMessage(
                                    idService: idService!,
                                    message: messageText!);
                              }
                              messageController.clear();
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class CardMessage extends StatelessWidget {
  const CardMessage(
      {required this.email,
      required this.text,
      required this.ismy,
      required this.time});
  final String text;
  final String email;
  final bool ismy;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            ismy ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            time.toDate().hour.toString() +
                ":" +
                time.toDate().minute.toString(),
            style: TextStyle(fontSize: 10),
          ),
          Material(
            color: ismy ? Colors.blue : Colors.grey,
            borderRadius: ismy
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(text),
            ),
          )
        ],
      ),
    );
  }
}
