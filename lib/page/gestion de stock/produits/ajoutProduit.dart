import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/listeFournisseurs.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/listeProduit.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Ajoutproduit extends StatefulWidget {
  final Categorie categorie;
  const Ajoutproduit({Key? key, required this.categorie}) : super(key: key);

  @override
  State<Ajoutproduit> createState() => _AjoutproduitState();
}

class _AjoutproduitState extends State<Ajoutproduit> {
  final TextEditingController nomProduit = TextEditingController();
  final TextEditingController quantiter = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController prixProduit = TextEditingController();
  final TextEditingController categorieId = TextEditingController();
  final TextEditingController unite = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Sidebar(onItemSelected: _onItemSelected), // Sidebar ajoutée
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
                        "Ajouter un produit",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nom du produit
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

                  // Quantité
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

                  // unite
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
                      controller: unite,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.text_fields_sharp),
                        border: InputBorder.none,
                        hintText: "Unité",
                      ),
                    ),
                  ),
                  // Prix
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
                      controller: prixProduit,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Prix obligatoire";
                        }
                        if (double.tryParse(value) == null) {
                          return "Veuillez entrer un prix valide";
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

                  // Description
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
                      controller: description,
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
                          db
                              .ajoutProduit(Produits(
                                  nom: nomProduit.text,
                                  quantiter: int.tryParse(quantiter.text) ?? 0,
                                  prixUnitaire:
                                      double.tryParse(prixProduit.text) ?? 0.0,
                                  description: description.text,
                                  categorieId: widget.categorie.id,
                                  unite: unite.text))
                              .then((value) {
                            if (value > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Listeproduit(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Échec de l\'ajout')),
                              );
                            }
                          });
                        }
                      },
                      child: const Text(
                        "Ajouter produit",
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
