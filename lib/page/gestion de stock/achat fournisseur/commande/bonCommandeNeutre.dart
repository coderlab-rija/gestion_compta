import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/database/unite.dart';
import 'package:my_apk/database/fournisseur.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/function/utility.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/listBonCommande.dart';
import 'package:my_apk/page/gestion%20de%20stock/inventaires/inventaire.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/listProduct.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';
import 'package:sqflite/sqflite.dart';

class Boncommandeneutre extends StatefulWidget {
  const Boncommandeneutre({Key? key}) : super(key: key);

  @override
  State<Boncommandeneutre> createState() => _BoncommandeState();
}

class _BoncommandeState extends State<Boncommandeneutre> {
  late Future<List<Unite>> _unityFuture;
  late Future<List<Supplier>> _fournisseurFuture;
  late Future<List<Categorie>> _categoryFuture;
  late Future<List<Product>> _produitFuture;
  final dbHelper = DataBaseHelper();
  final utility = Utility();
  List<Map<String, dynamic>> selectedProducts = [];

  int? selectedCategoryId;
  int? selectedUnityId;
  int? selectedFournisseurId;
  int? selectedProduitId;
  TextEditingController quantityController = TextEditingController();
  TextEditingController prixAchatController = TextEditingController();
  TextEditingController prixVenteController = TextEditingController();
  TextEditingController dateCommandeController = TextEditingController();
  String status = "En cours";
  String? selectedPaymentType;

  @override
  void initState() {
    super.initState();
    _unityFuture = dbHelper.getUnity();
    _fournisseurFuture = dbHelper.getFournisseurs();
    _categoryFuture = dbHelper.getCategory();
    _produitFuture = dbHelper.getProduct();
    selectedPaymentType = 'Espèce';
    dateCommandeController.text = DateTime.now().toString().substring(0, 10);
  }

  void _onCategoryChanged(int? newCategoryId) {
    setState(() {
      selectedCategoryId = newCategoryId;
      _produitFuture = utility.getFilteredProducts(newCategoryId);
      selectedProduitId = null; // Réinitialiser le produit sélectionné
    });
  }

  Future<void> _addBonCommande() async {
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter au moins un produit')),
      );
      return;
    }

    if (selectedFournisseurId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un fournisseur')),
      );
      return;
    }

    final db = await DataBaseHelper().initDB();
    String reference = utility.generateReference(selectedFournisseurId!);

    for (var produit in selectedProducts) {
      final produitAvecFournisseur = {
        'produitId': produit['produitId'],
        'quantity': produit['quantity'],
        'prixAchat': produit['prixAchat'],
        'prixVente': produit['prixVente'],
        'dateCommande':
            DateTime.parse(dateCommandeController.text).toIso8601String(),
        'categoryId': selectedCategoryId!,
        'fournisseurId': selectedFournisseurId!,
        'status': status,
        'reference': reference,
      };

      await db.insert('bonCommande', produitAvecFournisseur,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Commande ajoutée avec succès')),
    );
    setState(() {
      selectedProducts.clear();
    });
  }

  void _addProductToList() {
    if (selectedProduitId != null &&
        quantityController.text.isNotEmpty &&
        prixAchatController.text.isNotEmpty) {
      setState(() {
        selectedProducts.add({
          'produitId': selectedProduitId,
          'quantity': int.parse(quantityController.text),
          'prixAchat': double.parse(prixAchatController.text),
          'prixVente': double.tryParse(prixVenteController.text) ?? 0.0,
        });
        quantityController.clear();
        prixAchatController.clear();
        prixVenteController.clear();
      });
    }
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
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dateCommandeController,
              decoration: const InputDecoration(labelText: "Date de commande"),
              readOnly: true,
            ),
            FutureBuilder<List<Categorie>>(
              future: _categoryFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  onChanged: _onCategoryChanged,
                  items: snapshot.data!
                      .map((category) => DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: "Catégorie"),
                );
              },
            ),
            FutureBuilder<List<Product>>(
              future: _produitFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return DropdownButtonFormField<int>(
                  value: selectedProduitId,
                  onChanged: (newValue) =>
                      setState(() => selectedProduitId = newValue),
                  items: snapshot.data!
                      .map((produit) => DropdownMenuItem<int>(
                            value: produit.id,
                            child: Text(produit.name),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: "Produit"),
                );
              },
            ),
            FutureBuilder<List<Unite>>(
              future: _unityFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final unities = snapshot.data!;
                selectedUnityId ??= unities.isNotEmpty ? unities[0].id : null;

                return DropdownButtonFormField<int>(
                  value: selectedUnityId,
                  onChanged: (newValue) {
                    setState(() {
                      selectedUnityId = newValue;
                    });
                  },
                  items: unities.map((unite) {
                    return DropdownMenuItem<int>(
                      value: unite.id,
                      child: Text(unite.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: "Unité de gestion",
                  ),
                );
              },
            ),
            FutureBuilder<List<Supplier>>(
              future: _fournisseurFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final fournisseurs = snapshot.data!;
                selectedFournisseurId ??=
                    fournisseurs.isNotEmpty ? fournisseurs[0].id : null;

                return DropdownButtonFormField<int>(
                  value: selectedFournisseurId,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFournisseurId = newValue;
                    });
                  },
                  items: fournisseurs.map((fournisseur) {
                    return DropdownMenuItem<int>(
                      value: fournisseur.id,
                      child: Text(fournisseur.fournisseurName),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: "Fournisseur",
                  ),
                );
              },
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantité"),
            ),
            TextField(
              controller: prixAchatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Prix d'achat"),
            ),
            TextField(
              controller: prixVenteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Prix de vente"),
            ),
            /*DropdownButtonFormField<String>(
              value: selectedPaymentType,
              onChanged: (newValue) {
                setState(() {
                  selectedPaymentType = newValue;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Bancaire',
                  child: Text('Bancaire'),
                ),
                DropdownMenuItem(
                  value: 'Espèce',
                  child: Text('Espèce'),
                ),
                DropdownMenuItem(
                  value: 'Mobile Money',
                  child: Text('Mobile Money'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Type de paiement',
              ),
            ),*/
            ElevatedButton(
              onPressed: _addProductToList,
              child: const Text("Ajouter Produit"),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                final produit = selectedProducts[index];
                if (kDebugMode) {
                  print(produit);
                }
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(Icons.shopping_cart,
                        color: Theme.of(context).primaryColor),
                    title: Text(
                      "Produit ${produit['produitId']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      "Quantité: ${produit['quantity']} - Prix: ${produit['prixAchat']}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          setState(() => selectedProducts.removeAt(index)),
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: _addBonCommande,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text("Valider la Commande"),
            ),
          ],
        ),
      ),
    );
  }
}
