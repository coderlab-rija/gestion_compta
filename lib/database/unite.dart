class Unite {
  final int? id;
  String nom;

  Unite({
    this.id,
    required this.nom,
  });

  factory Unite.fromMap(Map<String, dynamic> json) => Unite(
        id: json["id"],
        nom: json["nom"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nom": nom,
      };
}
