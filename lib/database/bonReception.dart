class Bonreception {
  final int? id;
  final int achatFournisseurId;
  final String dateReception;
  final String referenceReception;

  Bonreception({
    this.id,
    required this.achatFournisseurId,
    required this.dateReception,
    required this.referenceReception,
  });

  factory Bonreception.fromMap(Map<String, dynamic> json) => Bonreception(
        id: json["id"],
        achatFournisseurId: json["achatFournisseurId"] as int,
        dateReception: json["dateReception"] as String,
        referenceReception: json["referenceReception"] as String,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "achatFournisseurId": achatFournisseurId,
        "dateReception": dateReception,
        "referenceReception": referenceReception,
      };
}
