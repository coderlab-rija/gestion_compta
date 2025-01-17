import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/listeFournisseurs.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/editProduit.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Listeproduit extends StatefulWidget {
  const Listeproduit({super.key});

  @override
  State<Listeproduit> createState() => _ListeproduitState();
}

class _ListeproduitState extends State<Listeproduit> {
  late Future<List<Produits>> _produitsFuture;
  late Future<List<Categorie>> _categoriesFuture;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _produitsFuture = getProduits();
    _categoriesFuture = getCategories();
  }

  Future<List<Produits>> getProduits() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final List<Map<String, Object?>> productsMaps;

    if (selectedCategoryId != null) {
      productsMaps = await db.query(
        'produits',
        where: 'categorieId = ?',
        whereArgs: [selectedCategoryId],
      );
    } else {
      productsMaps = await db.query('produits');
    }

    return productsMaps.map((productMap) {
      return Produits(
        id: productMap['id'] as int,
        nom: productMap['nom'] as String,
        prixUnitaire: productMap['prixUnitaire'] as double,
        quantiter: productMap['quantiter'] as int,
        description: productMap['description'] as String,
        categorieId: productMap['categorieId'] as int,
        unite: productMap['unite'] as String,
      );
    }).toList();
  }

  Future<List<Categorie>> getCategories() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final List<Map<String, Object?>> categoriesMaps =
        await db.query('categorie');
    return categoriesMaps.map((categoryMap) {
      return Categorie(
        id: categoryMap['id'] as int,
        nom: categoryMap['nom'] as String,
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
            MaterialPageRoute(builder: (context) => const Fournisseurhome()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Facturationhome()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
        break;
      case 5:
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
          title: const Text("Sélectionner une catégorie"),
          content: FutureBuilder<List<Categorie>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final categories = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("Toutes les catégories"),
                    onTap: () {
                      setState(() {
                        selectedCategoryId = null;
                        _produitsFuture = getProduits();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  ...categories.map((category) => ListTile(
                        title: Text(category.nom),
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category.id;
                            _produitsFuture = getProduits();
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
      appBar: AppBar(
        title: const Text("Liste de toutes les produits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showCategoryFilterDialog,
          ),
        ],
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: FutureBuilder<List<Produits>>(
        future: _produitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun produit trouvé"));
          } else {
            final produits = snapshot.data!;
            return ListView.builder(
              itemCount: produits.length,
              itemBuilder: (context, index) {
                final produit = produits[index];
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
                              produit.nom,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.info,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _showDetails(context, produit);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Editproduit(produit: produit),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          _produitsFuture = getProduits();
                                        });
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteProduct(produit);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.inventory, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text(
                              "Quantité: ${produit.quantiter} ${produit.unite}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.money, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text(
                              "Prix unitaire: ${produit.prixUnitaire} Ar",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text(
                              produit.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
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

  void _showDetails(BuildContext context, Produits produit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Détails du produit"),
          content: Text(
            "Nom: ${produit.nom}\nQuantité: ${produit.quantiter} ${produit.unite}\nPrix: ${produit.prixUnitaire} Ar\nDescription: ${produit.description}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(Produits produit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmer la suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer ${produit.nom}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                final dbHelper = DataBaseHelper();
                final db = await dbHelper.initDB();
                await db.delete('produits',
                    where: 'id = ?', whereArgs: [produit.id]);
                Navigator.of(context).pop();
                setState(() {
                  _produitsFuture = getProduits();
                });
              },
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }
}
