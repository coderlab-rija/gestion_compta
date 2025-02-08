import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class ListTypeproduits extends StatefulWidget {
  const ListTypeproduits({super.key});

  @override
  State<ListTypeproduits> createState() => _ListTypeProduitState();
}

class _ListTypeProduitState extends State<ListTypeproduits> {
  late Future<List<Category>> _categoryFuture;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categoryFuture = fetchCategory();
  }

  Future<List<Category>> fetchCategory() async {
    final dbHelper = DataBaseHelper();
    return await dbHelper.getCategory();
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
            MaterialPageRoute(builder: (context) => const ClientHome()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Facturationhome()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
        break;
      case 6:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Configurationhome()));
        break;
      case 7:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        break;
    }
  }

  void _addProduit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un type de produit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                String name = _nameController.text;
                String description = _descriptionController.text;

                if (name.isNotEmpty && description.isNotEmpty) {
                  final dbHelper = DataBaseHelper();
                  Category newCategory = Category(
                    name: name,
                    description: description,
                  );
                  await dbHelper.addCategory(newCategory);
                  setState(() {
                    _categoryFuture = fetchCategory();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Type de produit ajouté')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Veuillez remplir tous les champs')),
                  );
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _editTypeProduct(Category category) {
    _nameController.text = category.name;
    _descriptionController.text = category.description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier un type de produit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                String name = _nameController.text;
                String description = _descriptionController.text;

                if (name.isNotEmpty && description.isNotEmpty) {
                  final dbHelper = DataBaseHelper();
                  Category updatedCategory = Category(
                    id: category.id,
                    name: name,
                    description: description,
                  );
                  await dbHelper.updateCategory(updatedCategory);
                  setState(() {
                    _categoryFuture = fetchCategory();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Type de produit mis à jour')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Veuillez remplir tous les champs')),
                  );
                }
              },
              child: const Text('Mettre à jour'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listes des types de produits"),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: FutureBuilder<List<Category>>(
        future: _categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune catégorie trouvée"));
          } else {
            final typeProduct = snapshot.data!;
            return ListView.builder(
              itemCount: typeProduct.length,
              itemBuilder: (context, index) {
                final response = typeProduct[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () {
                                    _editTypeProduct(response);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteCategorie(response);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                response.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduit,
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un type de produit',
      ),
    );
  }

  void _deleteCategorie(Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete ${category.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final dbHelper = DataBaseHelper();
                final result = await dbHelper.deleteCategory(category.id!);
                if (result != -1) {
                  setState(() {
                    _categoryFuture = fetchCategory();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category deleted successfully'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error while deleting')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
