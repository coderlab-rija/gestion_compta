import 'package:flutter/material.dart';
import 'package:my_apk/database/achatFournisseur.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/bonCommandeNeutre.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';
import 'package:my_apk/page/pdf/PDFBonCommande.dart';

class ListBoncommande extends StatefulWidget {
  const ListBoncommande({super.key});

  @override
  State<ListBoncommande> createState() => _ListBoncommandeState();
}

class _ListBoncommandeState extends State<ListBoncommande> {
  late Future<List<AchatFournisseur>> _bonCommandeFuture;
  late Future<List<Category>> _categoryFuture;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _bonCommandeFuture = getbonCommande();
    _categoryFuture = getCategory();
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

    return bonCommandeMaps.map((bonCommandeMap) {
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
  }

  Future<List<Category>> getCategory() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final List<Map<String, Object?>> categoriesMaps =
        await db.query('category');
    return categoriesMaps.map((categoryMap) {
      return Category(
        id: categoryMap['id'] as int,
        name: categoryMap['name'] as String,
        description: categoryMap['description'] as String,
      );
    }).toList();
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
            MaterialPageRoute(builder: (context) => const StockHome()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Supplierhome()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Boncommandeneutre()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ClientHome()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Facturationhome()));
        break;
      case 6:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
        break;
      case 7:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Configurationhome()));
        break;
      case 8:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        break;
    }
  }

  void _showCategoryFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selectionner le categorie"),
          content: FutureBuilder<List<Category>>(
            future: _categoryFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final categories = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Tous"),
                    onTap: () {
                      setState(() {
                        selectedCategoryId = null;
                        _bonCommandeFuture = getbonCommande();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  ...categories.map((category) => ListTile(
                        title: Text(category.name),
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category.id;
                            _bonCommandeFuture = getbonCommande();
                          });
                          Navigator.of(context).pop();
                        },
                      )),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(onItemSelected: _onItemSelected),
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
            final bonCommandes = snapshot.data!;
            return ListView.builder(
              itemCount: bonCommandes.length,
              itemBuilder: (context, index) {
                final response = bonCommandes[index];
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
                              response.productName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.grey),
                              onSelected: (value) {
                                if (value == 'edit') {
                                } else if (value == 'delete') {
                                  _deleteBonCommande(response.id!);
                                } else if (value == 'validate') {
                                } else if (value == 'print') {
                                  PdfGenerator.generateAndPrintPdf([response]);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'validate',
                                  child: ListTile(
                                    leading: Icon(
                                        Icons.add_circle_outline_outlined,
                                        color: Color.fromARGB(255, 2, 96, 8)),
                                    title: Text('Valider achat'),
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'print',
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.print, color: Colors.blue),
                                    title: Text('Imprimer'),
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.edit, color: Colors.orange),
                                    title: Text('Modifier'),
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.delete, color: Colors.red),
                                    title: Text('Supprimer'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "Fournisseur: ${response.fournisseurName}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Reférence: ${response.reference}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Quantité achetée: ${response.quantity}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Prix d'achat: ${(response.prixAchat)} Ar",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Prix total: ${(response.prixAchat * response.quantity).toStringAsFixed(2)} Ar",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Statut du commande: ${response.status}",
                          style: const TextStyle(fontSize: 14),
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

  void _deleteBonCommande(int id) async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    await db.delete('bonCommande', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _bonCommandeFuture = getbonCommande();
    });
  }
}
