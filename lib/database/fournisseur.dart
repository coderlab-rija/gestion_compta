import 'package:cloud_firestore/cloud_firestore.dart';

class Supplier {
  final String? id;
  final int? idSupplier; 
  String fournisseurName;
  String fournisseurAdress;
  String nif;
  String stat;
  String contact;
  String dateCreation;

  Supplier({
    this.id,
    this.idSupplier,
    required this.fournisseurName,
    required this.fournisseurAdress,
    required this.nif,
    required this.stat,
    required this.contact,
    required this.dateCreation,
  });

  factory Supplier.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Supplier(
      id: doc.id,
      idSupplier: data['idSupplier'],
      fournisseurName: data['fournisseurName'] ?? '',
      fournisseurAdress: data['fournisseurAdress'] ?? '',
      nif: data['nif'] ?? '',
      stat: data['stat'] ?? '',
      contact: data['contact'] ?? '',
      dateCreation: data['dateCreation'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        "fournisseurName": fournisseurName,
        "fournisseurAdress": fournisseurAdress,
        "nif": nif,
        "stat": stat,
        "contact": contact,
        "dateCreation": dateCreation,
        "idSupplier": idSupplier,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "idSupplier": idSupplier,
        "fournisseurName": fournisseurName,
        "fournisseurAdress": fournisseurAdress,
        "nif": nif,
        "stat": stat,
        "contact": contact,
        "dateCreation": dateCreation,
      };
}
