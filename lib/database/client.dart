class Client {
  final int? id;
  String clientName;
  String clientSurname;
  String clientAdress;
  String mailAdress;
  String nif;
  String stat;
  String contact;
  bool pro;
  String codeClient;
  String? filePath;

  Client({
    this.id,
    required this.clientName,
    required this.codeClient,
    required this.clientSurname,
    required this.clientAdress,
    required this.mailAdress,
    required this.nif,
    required this.stat,
    required this.contact,
    required this.pro,
    this.filePath,
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
        filePath: json["filePath"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "clientName": clientName,
        "clientSurname": clientSurname,
        "clientAdress": clientAdress,
        "mailAdress": mailAdress,
        "nif": nif,
        "stat": stat,
        "contact": contact,
        "pro": pro,
        "codeClient": codeClient,
        "filePath": filePath,
      };
}
