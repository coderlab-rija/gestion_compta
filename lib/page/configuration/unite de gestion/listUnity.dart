import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_apk/database/uniteProduit.dart';
import 'package:my_apk/function/fonction.dart';
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

class Listunity extends StatefulWidget {
  const Listunity({super.key});

  @override
  State<Listunity> createState() => _ListunityState();
}

class _ListunityState extends State<Listunity> {
  Fonction fonction = Fonction();
  late Future<List<Unite>> _unityFuture;

  @override
  void initState() {
    super.initState();
    _unityFuture = fonction.getUnity();
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

  void _showEditPopup(Unite unity) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: unity.name);
    final uniteController = TextEditingController(text: unity.unite);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier l'unité"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: "Nom de l'unité"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le nom est requis";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: uniteController,
                  decoration: const InputDecoration(labelText: "Unité"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Unité requis";
                    }
                    return null;
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
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  fonction.updateUnity(unity.idUnity!, nameController.text,
                      uniteController.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Unité modifiée avec succès.")),
                  );
                }
              },
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    );
  }

  void _addUnity() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final uniteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter une nouvelle unité'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: "Nom de l'unité"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le nom est requis";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: uniteController,
                  decoration: const InputDecoration(labelText: "Unité"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "L'unité est requise";
                    }
                    return null;
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
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    final clientCollection =
                        FirebaseFirestore.instance.collection('unite');
                    final querySnapshot = await clientCollection.get();
                    final currentCount = querySnapshot.size;

                    final unityData = {
                      'uid': user?.uid ?? "",
                      'name': nameController.text,
                      'unite': uniteController.text,
                      'createdAt': DateTime.now().toIso8601String(),
                      "idUnity": currentCount + 1,
                    };

                    final response = await http.post(
                      Uri.parse("http://10.0.2.2:8000/unite"),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode(unityData),
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Unité ajouté avec succès !")),
                      );
                      Navigator.of(context).pop();

                      if (mounted) {
                        setState(() {
                          _unityFuture = fonction.getUnity();
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur : ${e.toString()}")),
                    );
                  }
                }
              },
              child: const Text("Ajouter"),
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
        title: const Text("Listes des unités"),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: FutureBuilder<List<Unite>>(
        future: _unityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune unité trouvée."));
          } else {
            final unity = snapshot.data!;
            return ListView.builder(
              itemCount: unity.length,
              itemBuilder: (context, index) {
                final response = unity[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //List//
                        Text(
                          response.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          response.unite,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showEditPopup(response),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUnity(response),
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
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 5,
            child: FloatingActionButton(
              onPressed: _addUnity,
              tooltip: 'Ajouter une nouvelle unité',
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteUnity(Unite unity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmer la suppression"),
          content: Text("Voulez-vous supprimer l'unité ${unity.name} ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler"),
            ),
            /*TextButton(
              onPressed: () async {
                final dbHelper = DataBaseHelper();
                final result = await dbHelper.deleteUnity(unity.id!);
                if (result != -1) {
                  setState(() {
                    _unityFuture = fetchUnity();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Unité supprimée avec succès.')),
                  );
                }
              },
              child: const Text("Supprimer"),
            ),*/
          ],
        );
      },
    );
  }
}
