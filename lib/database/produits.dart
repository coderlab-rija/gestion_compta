class Produits {
  final int? id;
  String nom;
  int quantiter;
  double prixUnitaire;
  dynamic description;
  int? categorieId;
  String unite;

  Produits({
    this.id,
    required this.nom,
    required this.quantiter,
    required this.prixUnitaire,
    required this.description,
    this.categorieId,
    required this.unite,
  });

  factory Produits.fromMap(Map<String, dynamic> json) => Produits(
        id: json["id"],
        nom: json["nom"],
        quantiter: json["quantiter"],
        prixUnitaire: json["prixUnitaire"],
        description: json["description"],
        categorieId: json["categorieId"],
        unite: json["unite"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nom": nom,
        "quantiter": quantiter,
        "prixUnitaire": prixUnitaire,
        "description": description,
        "categorieId": categorieId,
        "unite": unite,
      };
}
