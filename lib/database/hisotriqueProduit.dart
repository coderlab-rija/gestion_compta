class Hisotriqueproduct {
  final int? id;
  final String action;
  final String produitId;
  final String produitName;
  final String username;
  final String dateAction;

  Hisotriqueproduct({
    this.id,
    required this.action,
    required this.produitId,
    required this.produitName,
    required this.username,
    required this.dateAction,
  });

  factory Hisotriqueproduct.fromMap(Map<String, dynamic> json) =>
      Hisotriqueproduct(
        id: json["id"],
        action: json["action"],
        produitId: json["produitId"],
        produitName: json["produitName"],
        username: json["username"],
        dateAction: json["dateAction"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "action": action,
        "produitId": produitId,
        "produitName": produitName,
        "username": username,
        "dateAction": dateAction,
      };
}
