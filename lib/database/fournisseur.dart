class Supplier {
  final int? id;
  String fournisseurName;
  String fournisseurAdress;
  String nif;
  String stat;
  String contact;
  String dateCreation;

  Supplier({
    this.id,
    required this.fournisseurName,
    required this.fournisseurAdress,
    required this.nif,
    required this.stat,
    required this.contact,
    required this.dateCreation,
  });

  factory Supplier.fromMap(Map<String, dynamic> json) => Supplier(
        id: json["id"],
        fournisseurName: json["fournisseurName"],
        fournisseurAdress: json["fournisseurAdress"],
        nif: json["nif"],
        stat: json["stat"],
        contact: json["contact"],
        dateCreation: json["dateCreation"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "fournisseurName": fournisseurName,
        "fournisseurAdress": fournisseurAdress,
        "nif": nif,
        "stat": stat,
        "contact": contact,
        "dateCreation": dateCreation,
      };
}
