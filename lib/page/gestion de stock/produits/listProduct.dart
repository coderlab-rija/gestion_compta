import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/database/uniteProduit.dart';
import 'package:my_apk/function/fonction.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/bonCommandeNeutre.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/bonCommandeProduct.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/listBonCommande.dart';
import 'package:my_apk/page/gestion%20de%20stock/inventaires/inventaire.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/editProduct.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Listproduct extends StatefulWidget {
  const Listproduct({super.key});

  @override
  State<Listproduct> createState() => _ListproduitState();
}

class _ListproduitState extends State<Listproduct> {
  Fonction fonction = Fonction();
  late Future<List<Product>> _productFuture;
  late Future<List<Categorie>> _categoryFuture;
  late Future<List<Unite>> _unityFuture;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _productFuture = fonction.getProducts();
    _categoryFuture = fonction.getCategory();
    _unityFuture = fonction.getUnity();
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

  Future<void> _showAddProductDialog() async {
    String name = '';
    String description = '';
    int? idCategorie;
    int? idUnity;
    String? unityName;
    String? categoryName;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Ajouter un produit'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) => name = value,
                      decoration:
                          const InputDecoration(labelText: 'Nom du produit'),
                    ),
                    TextField(
                      onChanged: (value) => description = value,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    FutureBuilder<List<Categorie>>(
                      future: _categoryFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          print("Erreur catégorie: ${snapshot.error}");
                          return const Text(
                              "Erreur de chargement des catégories");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text("Aucune catégorie trouvée");
                        }

                        final categories = snapshot.data!;

                        // ⚠️ Vérifie que categoryId est bien dans la liste, sinon remets-le à null
                        if (idCategorie != null &&
                            !categories
                                .any((cat) => cat.idCategorie == idCategorie)) {
                          idCategorie = null;
                        }

                        return DropdownButton<int>(
                          isExpanded: true,
                          hint: const Text('Sélectionner une catégorie'),
                          value: idCategorie,
                          onChanged: (int? newValue) {
                            setStateDialog(() {
                              idCategorie = newValue;
                              final selected = categories.firstWhere(
                                (element) => element.idCategorie == newValue,
                                orElse: () => Categorie(
                                    idCategorie: -1, name: '', description: ''),
                              );
                              categoryName = selected.name;
                            });
                          },
                          items: categories.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.idCategorie,
                              child: Text(category.name),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    FutureBuilder<List<Unite>>(
                      future: _unityFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text(
                              "Erreur de chargement des catégories");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text("Aucune catégorie trouvée");
                        }

                        final categories = snapshot.data!;
                        if (idUnity != null &&
                            !categories.any((cat) => cat.idUnity == idUnity)) {
                          idUnity = null;
                        }

                        return DropdownButton<int>(
                          isExpanded: true,
                          hint: const Text('Sélectionner une unité'),
                          value: idUnity,
                          onChanged: (int? newValue) {
                            setStateDialog(() {
                              idUnity = newValue;
                              final selected = categories.firstWhere(
                                (element) => element.idUnity == newValue,
                                orElse: () =>
                                    Unite(idUnity: -1, name: '', unite: ''),
                              );
                              unityName = selected.name;
                            });
                          },
                          items: categories.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.idUnity,
                              child: Text(category.name),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () async {
                    if (name.isNotEmpty &&
                        description.isNotEmpty &&
                        idCategorie != null) {
                      try {
                        final user = FirebaseAuth.instance.currentUser;

                        final productData = {
                          'uid': user?.uid ?? "",
                          'name': name,
                          'description': description,
                          'idCategorie': idCategorie,
                          'unityId': idUnity,
                          'unityName': unityName,
                          'categoryName': categoryName,
                          'createdAt': DateTime.now().toIso8601String(),
                        };

                        final response = await http.post(
                          Uri.parse("http://10.0.2.2:8000/products"),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(productData),
                        );

                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Produit ajouté avec succès !")),
                          );
                          Navigator.of(context).pop();

                          if (mounted) {
                            setState(() {
                              _productFuture = fonction.getProducts();
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Erreur backend: ${response.statusCode} - ${response.body}",
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erreur : ${e.toString()}")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Veuillez remplir tous les champs.")),
                      );
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Sidebar(onItemSelected: _onItemSelected),
        body: FutureBuilder<List<Product>>(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Aucune donnée disponible"));
            } else {
              final product = snapshot.data!;
              return ListView.builder(
                itemCount: product.length,
                itemBuilder: (context, index) {
                  final response = product[index];
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
                                response.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.shopping_cart,
                                        color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Boncommandeproduct(
                                                  product: response),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.orange),
                                    onPressed: () {
                                      _editProduct(response);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      _deleteProduct(response.idProduct!);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "Description du produit: ${response.description}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Category du produit: ${response.categoryName}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Unite de géstion: ${response.unityName}",
                            style: const TextStyle(
                              fontSize: 14,
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
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 16,
              right: 5,
              child: FloatingActionButton(
                onPressed: () {
                  _showAddProductDialog();
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ));
  }

  void _editProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Editproduct(product: product),
      ),
    );
  }

  void _deleteProduct(int id) async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    await db.delete('product', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _productFuture = fonction.getProducts();
    });
  }
}
