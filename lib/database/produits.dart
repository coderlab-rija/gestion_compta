class Product {
  final int? id;
  String name;
  int quantity;
  double price;
  dynamic description;
  int? categoryId;
  String unity;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.description,
    this.categoryId,
    required this.unity,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        description: json["description"],
        categoryId: json["categoryId"],
        unity: json["unity"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "price": price,
        "description": description,
        "categoryId": categoryId,
        "unity": unity,
      };
}
