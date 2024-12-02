import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/editProduct.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
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
  late Future<List<Category>> _categoryFuture;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _productFuture = getProduct();
    _categoryFuture = getCategory();
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
      productsMaps = await db.query(
        'product',
        where: 'categoryId = ?',
        whereArgs: [selectedCategoryId],
      );
    } else {
      productsMaps = await db.query('product');
    }

    return productsMaps.map((productMap) {
      return Product(
        id: productMap['id'] as int,
        name: productMap['name'] as String,
        price: productMap['price'] as double,
        quantity: productMap['quantity'] as int,
        description: productMap['description'] as String,
        categoryId: productMap['categoryId'] as int,
        unity: productMap['unity'] as String,
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
          title: const Text("Select a category"),
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
                    title: const Text("All categories"),
                    onTap: () {
                      setState(() {
                        selectedCategoryId = null;
                        _productFuture = getProduct();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  ...categories.map((category) => ListTile(
                        title: Text(category.name),
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category.id;
                            _productFuture = getProduct();
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
        title: const Text("List of all products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showCategoryFilterDialog,
          ),
        ],
      ),
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
                                  icon: const Icon(Icons.info,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _showDetails(context, response);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () async {
                                    await setActionProductInSharedPreferences(
                                        'Product updated');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Editproduct(product: response),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          _productFuture = getProduct();
                                        });
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteProduct(response);
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
                              "Quantity: ${response.quantity} ${response.unity}",
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
                              "Price: ${response.price} Ar",
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
                              response.description,
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

  void _showDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Product details"),
          content: Text(
            "Name: ${product.name}\nQuantity: ${product.quantity} ${product.unity}\nPrice: ${product.price} Ar\nDescription: ${product.description}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm deletion"),
          content: Text("Are you sure you want to delete? ${product.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final dbHelper = DataBaseHelper();
                final db = await dbHelper.initDB();
                await db.delete('product',
                    where: 'id = ?', whereArgs: [product.id]);
                Navigator.of(context).pop();
                setState(() {
                  _productFuture = getProduct();
                });
              },
              child: const Text("Deleted"),
            ),
          ],
        );
      },
    );
  }
}
