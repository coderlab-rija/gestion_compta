import 'package:flutter/material.dart';
import 'package:my_apk/database/fournisseur.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/listeFournisseurs.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Editfournisseurs extends StatefulWidget {
  final Fournisseur fournisseur;

  const Editfournisseurs({super.key, required this.fournisseur});

  @override
  State<Editfournisseurs> createState() => _EditFournisseurState();
}

class _EditFournisseurState extends State<Editfournisseurs> {
  final nomFournisseur = TextEditingController();
  final addresseFournisseur = TextEditingController();
  final nif = TextEditingController();
  final stat = TextEditingController();
  final contact = TextEditingController();
  final dateCreation = TextEditingController();
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
    nomFournisseur.text = widget.fournisseur.nomFournisseur;
    addresseFournisseur.text = widget.fournisseur.addresseFournisseur;
    nif.text = widget.fournisseur.nif;
    stat.text = widget.fournisseur.stat;
    contact.text = widget.fournisseur.contact;
    dateCreation.text = widget.fournisseur.dateCreation;
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
                        "Modifier le fournisseur",
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
                      controller: nomFournisseur,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nom du produit obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.text_format),
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
                      controller: addresseFournisseur,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.home),
                        border: InputBorder.none,
                        hintText: "Quantité",
                      ),
                    ),
                  ),

                  ///NIF///
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
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.money),
                        border: InputBorder.none,
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
                      controller: stat,
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
                          db.updateFournisseur(Fournisseur(
                            id: widget.fournisseur.id,
                            nomFournisseur: nomFournisseur.text,
                            addresseFournisseur: addresseFournisseur.text,
                            nif: nif.text,
                            stat: stat.text,
                            contact: contact.text,
                            dateCreation: dateCreation.text,
                          ));
                          Navigator.pop(context, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Fournisseur modifié avec succès"),
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
