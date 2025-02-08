class Product {
  final int? id;
  String name;
  dynamic description;
  int? categoryId;
  int? unityId;
  String? unityName;
  String? categoryName;

  Product({
    this.id,
    required this.name,
    required this.description,
    this.categoryId,
    this.unityId,
    this.unityName,
    this.categoryName,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        categoryId: json["categoryId"],
        unityId: json["unityId"],
        unityName: json["unityName"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "categoryId": categoryId,
        "unityId": unityId,
        "unity": unityName,
        "categoryName": categoryName,
      };
}
