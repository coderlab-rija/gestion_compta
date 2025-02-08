class Achatfournisseurdetails {
  final int? id;
  final int produitId;
  final int achatFournisseurId;
  final int categoryId;
  final int quantity;
  final double prixAchat;
  final double prixVente;

  Achatfournisseurdetails({
    this.id,
    required this.produitId,
    required this.achatFournisseurId,
    required this.categoryId,
    required this.quantity,
    required this.prixAchat,
    required this.prixVente,
  });

  factory Achatfournisseurdetails.fromMap(Map<String, dynamic> json) =>
      Achatfournisseurdetails(
        id: json["id"] as int?,
        produitId: json["produitId"] as int,
        achatFournisseurId: json["achatFournisseurId"] as int,
        categoryId: json["categoryId"] as int,
        quantity: json["quantity"] as int,
        prixAchat: (json["prixAchat"] as num).toDouble(),
        prixVente: (json["prixVente"] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "produitId": produitId,
        "fournisseurId": achatFournisseurId,
        "categoryId": categoryId,
        "quantity": quantity,
        "prixAchat": prixAchat,
        "prixVente": prixVente,
      };
}
