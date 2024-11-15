class Fournisseur {
  final int? id;
  String nomFournisseur;
  String addresseFournisseur;
  String nif;
  String stat;
  String contact;
  String dateCreation;

  Fournisseur({
    this.id,
    required this.nomFournisseur,
    required this.addresseFournisseur,
    required this.nif,
    required this.stat,
    required this.contact,
    required this.dateCreation,
  });

  factory Fournisseur.fromMap(Map<String, dynamic> json) => Fournisseur(
        id: json["id"],
        nomFournisseur: json["nomFournisseur"],
        addresseFournisseur: json["addresseFournisseur"],
        nif: json["nif"],
        stat: json["stat"],
        contact: json["contact"],
        dateCreation: json["dateCreation"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nomFournisseur": nomFournisseur,
        "addresseFournisseur": addresseFournisseur,
        "nif": nif,
        "stat": stat,
        "contact": contact,
        "dateCreation": dateCreation,
      };
}
