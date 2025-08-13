import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String? id;
  final int? idClient;
  String clientName;
  String clientSurname;
  String clientAdress;
  String mailAdress;
  String nif;
  String stat;
  String contact;
  bool pro;
  String codeClient;

  Client({
    this.id,
    this.idClient,
    required this.clientName,
    required this.codeClient,
    required this.clientSurname,
    required this.clientAdress,
    required this.mailAdress,
    required this.nif,
    required this.stat,
    required this.contact,
    required this.pro,
  });

  factory Client.fromMap(Map<String, dynamic> json) => Client(
        id: json["id"],
        clientName: json["clientName"],
        clientSurname: json["clientSurname"],
        clientAdress: json["clientAdress"],
        mailAdress: json["mailAdress"],
        nif: json["nif"],
        stat: json["stat"],
        contact: json["contact"],
        pro: json["pro"],
        codeClient: json["codeClient"],
      );
  factory Client.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Client(
      id: doc.id,
      idClient: data['idClient'],
      clientName: data['clientName'] ?? '',
      clientSurname: data['clientSurname'] ?? '',
      clientAdress: data['clientAdress'] ?? '',
      mailAdress: data['mailAdress'] ?? '',
      nif: data['nif'] ?? '',
      stat: data['stat'] ?? '',
      contact: data['contact'] ?? '',
      pro: data['pro'] ?? false,
      codeClient: data['codeClient'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        "idClient": idClient,
        "clientName": clientName,
        "clientSurname": clientSurname,
        "clientAdress": clientAdress,
        "mailAdress": mailAdress,
        "nif": nif,
        "stat": stat,
        "contact": contact,
        "pro": pro,
        "codeClient": codeClient,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "idClient": idClient,
        "clientName": clientName,
        "clientSurname": clientSurname,
        "clientAdress": clientAdress,
        "mailAdress": mailAdress,
        "nif": nif,
        "stat": stat,
        "contact": contact,
        "pro": pro ? 1 : 0,
        "codeClient": codeClient,
      };
}
