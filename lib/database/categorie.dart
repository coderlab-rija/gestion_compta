class Categorie {
  final int? id;
  final String name;
  final String description;

  Categorie({
    this.id,
    required this.name,
    required this.description,
  });

  factory Categorie.fromMap(Map<String, dynamic> json) => Categorie(
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
