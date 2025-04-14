import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:my_apk/database/achatFournisseur.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/gestion%20de%20stock/inventaires/inventaire.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/listProduct.dart';
import 'package:my_apk/page/pdf/PDFBonCommande.dart';
import 'package:my_apk/page/widget/sideBar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_apk/page/pdf/PDFBonReception.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/bonCommandeNeutre.dart';
import 'package:my_apk/page/profils/profil_home.dart';

class ListBoncommande extends StatefulWidget {
  const ListBoncommande({super.key});

  @override
  State<ListBoncommande> createState() => _ListBoncommandeState();
}

class _ListBoncommandeState extends State<ListBoncommande> {
  late Future<List<AchatFournisseur>> _bonCommandeFuture;

  @override
  void initState() {
    super.initState();
    _bonCommandeFuture = getbonCommande();
  }

  String generateReceptionReference(String referenceCommande) {
    String dateCommande = referenceCommande.split('-')[2];
    String randomCode = _generateRandomString(5);

    return 'Bon-Reception-${referenceCommande.split('-')[1]}-$dateCommande-$randomCode';
  }

  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Future<List<AchatFournisseur>> getbonCommande() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final List<Map<String, Object?>> bonCommandeMaps = await db.rawQuery('''
    SELECT 
      bonCommande.id, bonCommande.fournisseurId, bonCommande.produitId, bonCommande.categoryId, 
      bonCommande.quantity, bonCommande.prixAchat, bonCommande.prixVente, bonCommande.dateCommande, 
      bonCommande.status, product.name as productName, fournisseur.fournisseurName as fournisseurName, 
      category.name as categoryName, bonCommande.reference
    FROM bonCommande
    JOIN product ON bonCommande.produitId = product.id
    JOIN fournisseur ON bonCommande.fournisseurId = fournisseur.id
    JOIN category ON bonCommande.categoryId = category.id
  ''');

    var bonCommandes = bonCommandeMaps.map((bonCommandeMap) {
      return AchatFournisseur(
        id: bonCommandeMap['id'] as int,
        fournisseurId: bonCommandeMap['fournisseurId'] as int,
        produitId: bonCommandeMap['produitId'] as int,
        categoryId: bonCommandeMap['categoryId'] as int,
        quantity: bonCommandeMap['quantity'] as int,
        prixAchat: bonCommandeMap['prixAchat'] as double,
        prixVente: bonCommandeMap['prixVente'] as double,
        dateCommande: bonCommandeMap['dateCommande'] as String,
        status: bonCommandeMap['status'] as String,
        productName: bonCommandeMap['productName'] as String,
        fournisseurName: bonCommandeMap['fournisseurName'] as String,
        categoryName: bonCommandeMap['categoryName'] as String,
        reference: bonCommandeMap['reference'] as String,
      );
    }).toList();

    bonCommandes.sort((a, b) {
      final dateComparison = a.dateCommande.compareTo(b.dateCommande);
      if (dateComparison != 0) {
        return dateComparison;
      }
      return a.fournisseurName.compareTo(b.fournisseurName);
    });

    return bonCommandes;
  }

  Future<void> _deleteAchat(int id) async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    await db.delete(
      'bonCommande',
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {
      _bonCommandeFuture = getbonCommande();
    });
  }

  Future<void> _validateCommande(String reference) async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();

    await db.update(
      'bonCommande',
      {'status': 'valider'},
      where: 'reference = ?',
      whereArgs: [reference],
    );

    final List<Map<String, Object?>> bonCommandeMaps = await db.rawQuery('''
    SELECT id, dateCommande, reference
    FROM bonCommande
    WHERE reference = ?
  ''', [reference]);

    for (var bonCommande in bonCommandeMaps) {
      String referenceReception =
          generateReceptionReference(bonCommande['reference'] as String);
      final reception = {
        'achatFournisseurId': bonCommande['id'],
        'dateReception': bonCommande['dateCommande'],
        'referenceReception': referenceReception,
      };

      await db.insert(
        'bonReception',
        reception,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    final List<Map<String, Object?>> bonReceptionMaps =
        await db.rawQuery('SELECT * FROM bonReception');
    print("Contenu de la table bonReception :");
    for (var row in bonReceptionMaps) {
      print(row);
    }

    setState(() {
      _bonCommandeFuture = getbonCommande();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bon de commande $reference validé avec succès"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onItemSelected(int index) {
    Navigator.pop(context);
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Profil()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Listproduct()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Inventaire()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Supplierhome()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Boncommandeneutre()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ListBoncommande()));
        break;
      case 6:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ClientHome()));
        break;
      case 7:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Facturationhome()));
        break;
      case 8:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
        break;
      case 9:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Configurationhome()));
        break;
      case 10:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Inventaire()));
        break;
      case 11:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(onItemSelected: (index) {}),
      body: FutureBuilder<List<AchatFournisseur>>(
        future: _bonCommandeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No bon de commande found"));
          } else {
            //final bonCommandes = snapshot.data!;
            final bonCommandes =
                snapshot.data!.where((b) => b.status != 'valider').toList();

            if (bonCommandes.isEmpty) {
              return const Center(
                child: Text(
                  "Aucun bon de commande à valider",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              );
            }
            final groupedBonCommandes =
                groupBy(bonCommandes, (AchatFournisseur b) => b.reference);

            return ListView.builder(
              itemCount: groupedBonCommandes.keys.length,
              itemBuilder: (context, index) {
                final reference = groupedBonCommandes.keys.elementAt(index);
                final produits = groupedBonCommandes[reference]!;
                double total = 0.0;
                for (var produit in produits) {
                  total += produit.prixAchat * produit.quantity;
                }

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              reference,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'valider') {
                                  _validateCommande(reference);
                                } else if (value == 'imprimer' &&
                                    produits[0].status == 'valider') {
                                  PDFBonReception pdfBonReception =
                                      PDFBonReception();
                                  pdfBonReception.generatePdf(produits);
                                } else if (value == 'imprimer' &&
                                    produits[0].status == 'En cours') {
                                  Pdfboncommande pdfBonCommande =
                                      Pdfboncommande();
                                  pdfBonCommande.generatePdf(produits);
                                } else if (value == 'supprimer' &&
                                    produits[0].status != 'valider') {
                                  _deleteAchat(produits[0].id!);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem<String>(
                                  value: 'valider',
                                  child: Text('Reception'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'imprimer',
                                  child: Text('Imprimer'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'supprimer',
                                  enabled: produits[0].status != 'valider',
                                  child: Text(
                                    'Supprimer',
                                    style: TextStyle(
                                      color: produits[0].status == 'valider'
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Fournisseur: ${produits[0].fournisseurName}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Status: ${produits[0].status}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...produits.map((produit) {
                          double prixTotal =
                              produit.prixAchat * produit.quantity;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nom du produit: ${produit.productName}",
                              ),
                              Text(
                                "Quantité: ${produit.quantity}",
                              ),
                              Text(
                                "Prix unitaire: ${produit.prixAchat} Ar",
                              ),
                              Text(
                                "Prix total: ${prixTotal.toStringAsFixed(2)} Ar",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Statuts: ${produit.status}",
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                        Text(
                          "Prix total de l'achat: ${total.toStringAsFixed(2)} Ar",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
