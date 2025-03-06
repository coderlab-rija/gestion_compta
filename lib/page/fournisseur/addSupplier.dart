import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/fournisseur.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/bonCommandeNeutre.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/listBonCommande.dart';
import 'package:my_apk/page/gestion%20de%20stock/inventaires/inventaire.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/listProduct.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Addsupplier extends StatefulWidget {
  final Category categorie;
  const Addsupplier({Key? key, required this.categorie}) : super(key: key);

  @override
  State<Addsupplier> createState() => _AjoutFournisseurState();
}

class _AjoutFournisseurState extends State<Addsupplier> {
  final TextEditingController fournisseurName = TextEditingController();
  final TextEditingController fournisseurAdress = TextEditingController();
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
                        "Add supplier",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Supplier Name
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
                      controller: fournisseurName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Supplier Name required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.category),
                        border: InputBorder.none,
                        hintText: "Supplier Name",
                      ),
                    ),
                  ),

                  // Address
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
                      controller: fournisseurAdress,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Address required";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter an exact address";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.format_list_numbered),
                        border: InputBorder.none,
                        hintText: "Address",
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
                          return "NIF required";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter an exact NIF";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.numbers),
                        border: InputBorder.none,
                        hintText: "NIF",
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
                          return "Stat required";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter an exact STAT";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.numbers),
                        border: InputBorder.none,
                        hintText: "STAT",
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
                          return "Contact required";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter a contact";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.contact_phone),
                        border: InputBorder.none,
                        hintText: "Contact",
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
                        hintText: "Creation date",
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
                              .addSupplier(Supplier(
                                  fournisseurName: fournisseurName.text,
                                  fournisseurAdress: fournisseurAdress.text,
                                  nif: nif.text,
                                  stat: stat.text,
                                  contact: contact.text,
                                  dateCreation: dateCreation.text))
                              .then((value) {
                            if (value > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Supplierhome(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Adding failed')),
                              );
                            }
                          });
                        }
                      },
                      child: const Text(
                        "Add supplier",
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
