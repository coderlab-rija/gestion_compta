import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/database/unite.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class Listproduct extends StatefulWidget {
  const Listproduct({super.key});

  @override
  State<Listproduct> createState() => _ListproduitState();
}

class _ListproduitState extends State<Listproduct> {
  late Future<List<Product>> _productFuture;
  late Future<List<Categorie>> _categoryFuture;
  final dbHelper = DataBaseHelper();
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _productFuture = getProduct();
    _categoryFuture = dbHelper.getCategory();
  }

  Future<void> setActionProductInSharedPreferences(String action) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('product_action', action);
  }

  Future<List<Product>> getProduct() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();

    final List<Map<String, Object?>> productsMaps;
    if (selectedCategoryId != null) {
      productsMaps = await db.rawQuery('''
      SELECT product.id, product.name, product.description, product.unityId, category.id, category.name as categoryName
      FROM product
      JOIN category ON product.categoryId = category.id
      WHERE product.categoryId = ?
    ''', [selectedCategoryId]);
    } else {
      productsMaps = await db.rawQuery('''
      SELECT product.id, product.name, product.description, product.unityId, category.id as categoryId, category.name as categoryName , unity.name as unityName
      FROM product
      JOIN category ON product.categoryId = category.id
      JOIN unity ON product.unityId = unity.id
    ''');
    }

    return productsMaps.map((productMap) {
      return Product(
        id: productMap['id'] as int,
        name: productMap['name'] as String,
        description: productMap['description'] as String,
        unityName: productMap['unityName'] as String,
        unityId: productMap['unityId'] as int,
        categoryId: productMap['categoryId'] as int,
        categoryName: productMap['categoryName'] as String,
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
    int? categoryId;
    int? unityId;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Ajouter un produit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => name = value,
                decoration: const InputDecoration(labelText: 'Nom du produit'),
              ),
              TextField(
                onChanged: (value) => description = value,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              FutureBuilder<List<Categorie>>(
                future: _categoryFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final categories = snapshot.data!;
                  return DropdownButton<int>(
                    hint: const Text('Selectioner le categorie'),
                    value: categoryId,
                    onChanged: (int? newValue) {
                      setState(() {
                        categoryId = newValue;
                      });
                    },
                    items: categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                  );
                },
              ),
              FutureBuilder<List<Unite>>(
                future: dbHelper.getUnity(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final unities = snapshot.data!;
                  return DropdownButton<int>(
                    hint: const Text('Select un unité'),
                    value: unityId,
                    onChanged: (int? newValue) {
                      setState(() {
                        unityId = newValue;
                      });
                    },
                    items: unities.map((unite) {
                      return DropdownMenuItem<int>(
                        value: unite.id,
                        child: Text(unite.name),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    categoryId != null &&
                    unityId != null) {
                  final dbHelper = DataBaseHelper();
                  final db = await dbHelper.initDB();
                  await db.insert('product', {
                    'name': name,
                    'description': description,
                    'categoryId': categoryId,
                    'unityId': unityId,
                  });
                  setState(() {
                    _productFuture = getProduct();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
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
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No products found"));
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
                                      _deleteProduct(response.id!);
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
                onPressed: _showAddProductDialog,
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
      _productFuture = getProduct();
    });
  }
}
