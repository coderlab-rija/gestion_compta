class Categorie {
  final int? id;
  final String nom;
  final String description;

  Categorie({
    this.id,
    required this.nom,
    required this.description,
  });

  factory Categorie.fromMap(Map<String, dynamic> json) => Categorie(
        id: json["id"],
        nom: json["nom"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nom": nom,
        "description": description,
      };
}
