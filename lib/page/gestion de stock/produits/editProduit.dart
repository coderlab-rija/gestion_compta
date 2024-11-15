import 'package:flutter/material.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/listeFournisseurs.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Editproduit extends StatefulWidget {
  final Produits produit;

  const Editproduit({super.key, required this.produit});

  @override
  State<Editproduit> createState() => _EditproduitState();
}

class _EditproduitState extends State<Editproduit> {
  final nomProduit = TextEditingController();
  final quantiter = TextEditingController();
  final desccritpion = TextEditingController();
  final prixProduit = TextEditingController();
  final categorieId = TextEditingController();
  final unite = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void _onItemSelected(int index) {
    Navigator.pop(context);
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profil()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StockHome()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Fournisseurhome()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Facturationhome()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-remplir le champ
    nomProduit.text = widget.produit.nom;
    quantiter.text = widget.produit.quantiter.toString();
    prixProduit.text = widget.produit.prixUnitaire.toString();
    desccritpion.text = widget.produit.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Center(
                      child: Text(
                        "Modifier le produit",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ///NAME///
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: nomProduit,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nom du produit obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.category),
                        border: InputBorder.none,
                        hintText: "Nom du produit",
                      ),
                    ),
                  ),

                  ///QUANTITY///
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: quantiter,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Quantité obligatoire";
                        }
                        if (double.tryParse(value) == null) {
                          return "Veuillez entrer un nombre valide";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.format_list_numbered),
                        border: InputBorder.none,
                        hintText: "Quantité",
                      ),
                    ),
                  ),

                  ///PRIX///
                  Container(
                    margin: const EdgeInsets.all(4), // Réduire la marge
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: prixProduit,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Prix obligatoire";
                        }
                        if (double.tryParse(value) == null) {
                          return "Veuillez entrer un prix";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.money),
                        border: InputBorder.none,
                        hintText: "Prix par unité",
                      ),
                    ),
                  ),

                  ///DESCRIPTION///
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: desccritpion,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.description),
                        border: InputBorder.none,
                        hintText: "Description",
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final db = DataBaseHelper();
                          db.updateProduit(Produits(
                            id: widget.produit.id,
                            nom: nomProduit.text,
                            quantiter: int.tryParse(quantiter.text) ?? 0,
                            prixUnitaire:
                                double.tryParse(prixProduit.text) ?? 0.0,
                            description: desccritpion.text,
                            categorieId: widget.produit.categorieId,
                            unite: unite.text,
                          ));
                          Navigator.pop(context, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Produit modifié avec succès"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Modifier",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
