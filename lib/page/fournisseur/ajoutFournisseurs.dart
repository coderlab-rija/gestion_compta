import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/fournisseur.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/listeFournisseurs.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Ajoutfournisseurs extends StatefulWidget {
  final Category categorie;
  const Ajoutfournisseurs({Key? key, required this.categorie})
      : super(key: key);

  @override
  State<Ajoutfournisseurs> createState() => _AjoutFournisseurState();
}

class _AjoutFournisseurState extends State<Ajoutfournisseurs> {
  final TextEditingController nomFournisseur = TextEditingController();
  final TextEditingController addresseFournisseur = TextEditingController();
  final TextEditingController nif = TextEditingController();
  final TextEditingController stat = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController dateCreation = TextEditingController();
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
                      controller: nomFournisseur,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nom du fournisseur obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.category),
                        border: InputBorder.none,
                        hintText: "Nom du fournisseur",
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
                      controller: addresseFournisseur,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Addresse obligatoire";
                        }
                        if (double.tryParse(value) == null) {
                          return "Veuillez entrer une addresse obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.format_list_numbered),
                        border: InputBorder.none,
                        hintText: "Addresse",
                      ),
                    ),
                  ),

                  // NIF
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
                      controller: nif,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nif obligatoire";
                        }
                        if (double.tryParse(value) == null) {
                          return "Veuillez entrer un nif obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.numbers),
                        border: InputBorder.none,
                        hintText: "Prix par unité",
                      ),
                    ),
                  ),

                  // STAT
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
                      controller: stat,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Stat obligatoire";
                        }
                        if (double.tryParse(value) == null) {
                          return "Veuillez entrer un stat obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.numbers),
                        border: InputBorder.none,
                        hintText: "Prix par unité",
                      ),
                    ),
                  ),

                  // CONTACT
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
                      controller: contact,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Contact obligatoire";
                        }
                        if (double.tryParse(value) == null) {
                          return "Veuillez entrer un contact";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.contact_phone),
                        border: InputBorder.none,
                        hintText: "Prix par unité",
                      ),
                    ),
                  ),

                  // DATE
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
                      controller: dateCreation,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.dataset),
                        border: InputBorder.none,
                        hintText: "Date de création",
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
                              .ajoutFournisseur(Fournisseur(
                                  nomFournisseur: nomFournisseur.text,
                                  addresseFournisseur: addresseFournisseur.text,
                                  nif: nif.text,
                                  stat: stat.text,
                                  contact: contact.text,
                                  dateCreation: dateCreation.text))
                              .then((value) {
                            if (value > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Fournisseurhome(),
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
