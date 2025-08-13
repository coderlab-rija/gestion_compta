import 'package:cloud_firestore/cloud_firestore.dart';

class Unite {
  final String? id;
  final int? idUnity;
  String name;
  String unite;

  Unite({
    this.id,
    this.idUnity,
    required this.name,
    required this.unite,
  });

  factory Unite.fromMap(Map<String, dynamic> json) => Unite(
        id: json["id"],
        idUnity: json["idUnity"],
        name: json["name"],
        unite: json["unite"],
      );

  factory Unite.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Unite(
      id: doc.id,
      idUnity: data['idUnity'],
      name: data['name'] ?? '',
      unite: data['unite'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        "id": id,
        "idUnity": idUnity,
        "name": name,
        "unite": unite,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "idUnity": idUnity,
        "name": name,
        "unite": unite,
      };
}
