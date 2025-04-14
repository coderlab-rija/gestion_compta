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
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/bonCommandeNeutre.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/listBonCommande.dart';
import 'package:my_apk/page/gestion%20de%20stock/inventaires/inventaire.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/listProduct.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';
import 'package:sqflite/sqflite.dart';

class Boncommandeproduct extends StatefulWidget {
  final Product product;
  const Boncommandeproduct({Key? key, required this.product}) : super(key: key);

  @override
  State<Boncommandeproduct> createState() => _BoncommandeState();
}

class _BoncommandeState extends State<Boncommandeproduct> {
  late Future<List<Unite>> _unityFuture;
  late Future<List<Supplier>> _fournisseurFuture;
  final dbHelper = DataBaseHelper();
  final utility = Utility();

  TextEditingController quantityController = TextEditingController();
  TextEditingController prixAchatController = TextEditingController();
  TextEditingController prixVenteController = TextEditingController();
  TextEditingController dateCommandeController = TextEditingController();

  int? selectedCategoryId;
  int? selectedUnityId;
  int? selectedFournisseurId;
  String status = "En cours";
  String? selectedPaymentType;

  @override
  void initState() {
    super.initState();
    _unityFuture = dbHelper.getUnity();
    _fournisseurFuture = dbHelper.getFournisseurs();

    dateCommandeController.text = DateTime.now().toString().substring(0, 10);
    selectedCategoryId = widget.product.categoryId;
    selectedUnityId = widget.product.unityId;
    selectedFournisseurId = null;
    selectedPaymentType = 'Espèce';
  }

  Future<List<Categorie>> getCategory() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final List<Map<String, Object?>> categoriesMaps =
        await db.query('category');
    return categoriesMaps.map((categoryMap) {
      return Categorie(
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

  Future<void> _addBonCommande() async {
    if (quantityController.text.isEmpty ||
        prixAchatController.text.isEmpty ||
        prixVenteController.text.isEmpty ||
        selectedCategoryId == null ||
        selectedUnityId == null ||
        selectedFournisseurId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    String reference = utility.generateReference(selectedFournisseurId!);

    final newCommande = {
      'produitId': widget.product.id ?? 0,
      'quantity': int.parse(quantityController.text),
      'prixAchat': double.parse(prixAchatController.text),
      'prixVente': double.parse(prixVenteController.text),
      'dateCommande':
          DateTime.parse(dateCommandeController.text).toIso8601String(),
      'categoryId': selectedCategoryId!,
      'fournisseurId': selectedFournisseurId!,
      'status': status,
      'reference': reference,
    };

    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    await db.insert(
      'bonCommande',
      newCommande,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Commande ajoutée avec succès')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bon de commande"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _addBonCommande,
          ),
        ],
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: widget.product.name,
              decoration: const InputDecoration(
                labelText: "Produit",
                enabled: false,
              ),
            ),
            TextFormField(
              initialValue: widget.product.categoryName,
              decoration: const InputDecoration(
                labelText: "Catégorie",
                enabled: false,
              ),
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
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantité"),
            ),
            TextFormField(
              controller: prixAchatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Prix d'achat"),
            ),
            TextFormField(
              controller: prixVenteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Prix de vente"),
            ),
            TextFormField(
              controller: dateCommandeController,
              decoration: const InputDecoration(labelText: "Date de commande"),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _addBonCommande();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListBoncommande()),
                  );
                },
                child: const Text("Ajouter le bon de commande"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
