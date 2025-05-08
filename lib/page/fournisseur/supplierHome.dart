import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_apk/database/fournisseur.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/fournisseur/editSupplier.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/bonCommandeNeutre.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/listBonCommande.dart';
import 'package:my_apk/page/gestion%20de%20stock/inventaires/inventaire.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/listProduct.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/facturation/facturationHome.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Supplierhome extends StatefulWidget {
  const Supplierhome({super.key});

  @override
  State<Supplierhome> createState() => _ListSupplierState();
}

class _ListSupplierState extends State<Supplierhome> {
  late Future<List<Supplier>> _supplierFuture;

  @override
  void initState() {
    super.initState();
    _supplierFuture = getSupplier();
  }

  Future<List<Supplier>> getSupplier() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid == null) {
        throw Exception("Utilisateur non connecté");
      }

      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/fournisseurs/user?uid=$uid"),
        headers: {
          "Content-Type": "application/json",
          "X-User-UID": uid,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> suppliersData = responseData['supplier'];

        return suppliersData.map((supplier) {
          return Supplier(
            id: supplier['id'],
            fournisseurName: supplier['fournisseurName'],
            fournisseurAdress: supplier['fournisseurAdress'],
            nif: supplier['nif'],
            stat: supplier['stat'],
            contact: supplier['contact'],
            dateCreation: supplier['dateCreation'],
          );
        }).toList();
      } else {
        throw Exception('Erreur backend : ${response.body}');
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération des fournisseurs: $e");
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

  void _addFournisseur() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController addressController = TextEditingController();
        final TextEditingController nifController = TextEditingController();
        final TextEditingController statController = TextEditingController();
        final TextEditingController contactController = TextEditingController();
        final TextEditingController dateController = TextEditingController();

        return AlertDialog(
          title: const Text("Ajouter un fournisseur"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nom du fournisseur",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: "Adresse",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nifController,
                  decoration: InputDecoration(
                    labelText: "NIF",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: statController,
                  decoration: InputDecoration(
                    labelText: "STAT",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contactController,
                  decoration: InputDecoration(
                    labelText: "Contact",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "Date de création",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        dateController.text =
                            "${selectedDate.toLocal()}".split(' ')[0];
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final clientData = {
                    'fournisseurName': nameController.text,
                    'fournisseurAdress': addressController.text,
                    'nif': nifController.text,
                    'stat': statController.text,
                    'contact': contactController.text,
                    'dateCreation': dateController.text,
                    'createdAt': FieldValue.serverTimestamp(),
                  };

                  await FirebaseFirestore.instance
                      .collection("fournisseurs")
                      .add(clientData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Fournisseur ajouté avec succès !")),
                  );

                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur : ${e.toString()}")),
                  );
                }

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  final fournisseurCollection =
                      FirebaseFirestore.instance.collection('fournisseurs');
                  final querySnapshot = await fournisseurCollection.get();
                  final currentCount = querySnapshot.size;

                  final supplierData = {
                    'uid': user?.uid ?? "",
                    'fournisseurName': nameController.text,
                    'fournisseurAdress': addressController.text,
                    'nif': nifController.text,
                    'stat': statController.text,
                    'contact': contactController.text,
                    'dateCreation': dateController.text,
                    'createdAt': DateTime.now().toIso8601String(),
                    "idSupplier": currentCount + 1,
                  };

                  final response = await http.post(
                    Uri.parse("http://10.0.2.2:8000/fournisseurs"),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(supplierData),
                  );

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Fournisseur ajouté avec succès !")),
                    );
                    Navigator.of(context).pop();

                    if (mounted) {
                      setState(() {
                        _supplierFuture = getSupplier();
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Erreur backend: ${response.statusCode} - ${response.body}")),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erreur : ${e.toString()}")),
                  );
                }
              },
              child: const Text("Add"),
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
      body: FutureBuilder<List<Supplier>>(
        future: _supplierFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun fournisseur trouvé"));
          } else {
            final fournisseurs = snapshot.data!;
            return ListView.builder(
              itemCount: fournisseurs.length,
              itemBuilder: (context, index) {
                final fournisseur = fournisseurs[index];
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
                              fournisseur.fournisseurName,
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
                                    _showDetails(context, fournisseur);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Editsupplier(supplier: fournisseur),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          _supplierFuture = getSupplier();
                                        });
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text("NIF: ${fournisseur.nif}"),
                        const SizedBox(height: 5),
                        Text("STAT: ${fournisseur.stat}"),
                        const SizedBox(height: 5),
                        Text("Adresse: ${fournisseur.fournisseurAdress}"),
                        const SizedBox(height: 5),
                        Text("Contact: ${fournisseur.contact}"),
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
              onPressed: _addFournisseur,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, Supplier fournisseur) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(fournisseur.fournisseurName),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Adresse: ${fournisseur.fournisseurAdress}'),
              Text('NIF: ${fournisseur.nif}'),
              Text('Stat: ${fournisseur.stat}'),
              Text('Contact: ${fournisseur.contact}'),
              Text('Date de création: ${fournisseur.dateCreation}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
