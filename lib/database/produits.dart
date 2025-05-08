import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final int? idProduct;
  String name;
  dynamic description;
  int? idCategorie;
  int? unityId;
  String? unityName;
  String? categoryName;

  Product({
    this.id,
    this.idProduct,
    required this.name,
    required this.description,
    this.idCategorie,
    this.unityId,
    this.unityName,
    this.categoryName,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        idProduct: json["idProduct"],
        name: json["name"],
        description: json["description"],
        idCategorie: json["idCategorie"],
        unityId: json["unityId"],
        unityName: json["unityName"],
        categoryName: json["categoryName"],
      );
  factory Product.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      idProduct: data['idProduct'],
      name: data['name'],
      description: data['description'] ?? '',
      unityId: data['unityId'],
      unityName: data['unityName'],
      categoryName: data['categoryName'],
      idCategorie: data['idCategorie'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        "id": id,
        "name": name,
        "description": description,
        "idCategorie": idCategorie,
        "unityId": unityId,
        "unity": unityName,
        "categoryName": categoryName,
        "idProduct": idProduct,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "categoryId": idCategorie,
        "unityId": unityId,
        "unity": unityName,
        "categoryName": categoryName,
        "idProduct": idProduct,
      };
}
