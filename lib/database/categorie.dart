import 'package:cloud_firestore/cloud_firestore.dart';

class Categorie {
  final String? id;
  final int? idCategorie;
  final String name;
  final String description;

  Categorie({
    this.id,
    this.idCategorie,
    required this.name,
    required this.description,
  });

  factory Categorie.fromMap(Map<String, dynamic> json) => Categorie(
        id: json["id"],
        idCategorie: json["idCategorie"],
        name: json["name"],
        description: json["description"],
      );

  factory Categorie.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Categorie(
      id: doc.id,
      idCategorie: data['idCategorie'],
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        "id": id,
        "idCategorie": idCategorie,
        "name": name,
        "description": description,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "idCategorie": idCategorie,
        "name": name,
        "description": description,
      };
}
