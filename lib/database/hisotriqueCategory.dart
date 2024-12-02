class HistoriqueCategory {
  final int? id;
  final String action;
  final String categoryId;
  final String categoryName;
  final String username;
  final String dateAction;

  HistoriqueCategory({
    this.id,
    required this.action,
    required this.categoryId,
    required this.categoryName,
    required this.username,
    required this.dateAction,
  });

  factory HistoriqueCategory.fromMap(Map<String, dynamic> json) =>
      HistoriqueCategory(
        id: json["id"],
        action: json["action"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        username: json["username"],
        dateAction: json["dateAction"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "action": action,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "username": username,
        "dateAction": dateAction,
      };
}
