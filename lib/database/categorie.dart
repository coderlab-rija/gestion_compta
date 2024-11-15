class Category {
  final int? id;
  final String name;
  final String description;

  Category({
    this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
