class AchatFournisseur {
  final int? id;
  final int produitId;
  final int fournisseurId;
  final int categoryId;
  final int quantity;
  final double prixAchat;
  final double prixVente;
  final String dateCommande;
  final String status;
  final String productName;
  final String fournisseurName;
  final String categoryName;
  final String reference;

  AchatFournisseur({
    this.id,
    required this.produitId,
    required this.fournisseurId,
    required this.categoryId,
    required this.quantity,
    required this.prixAchat,
    required this.prixVente,
    required this.dateCommande,
    this.status = 'En cours',
    required this.productName,
    required this.fournisseurName,
    required this.categoryName,
    required this.reference,
  });

  factory AchatFournisseur.fromMap(Map<String, dynamic> json) =>
      AchatFournisseur(
        id: json["id"] as int?,
        produitId: json["produitId"] as int,
        fournisseurId: json["fournisseurId"] as int,
        categoryId: json["categoryId"] as int,
        quantity: json["quantity"] as int,
        prixAchat: (json["prixAchat"] as num).toDouble(),
        prixVente: (json["prixVente"] as num).toDouble(),
        dateCommande: json["dateCommande"] as String,
        status: json["status"] as String,
        productName: json["productName"] as String,
        fournisseurName: json["fournisseurName"] as String,
        categoryName: json["categoryName"] as String,
        reference: json["reference"] as String,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "produitId": produitId,
        "fournisseurId": fournisseurId,
        "categoryId": categoryId,
        "quantity": quantity,
        "prixAchat": prixAchat,
        "prixVente": prixVente,
        "dateCommande": dateCommande,
        "status": status,
        "productName": productName,
        "fournisseurName": fournisseurName,
        "categoryName": categoryName,
        "reference": reference,
      };
}
