import 'package:flutter/material.dart';
import 'package:my_apk/database/fournisseur.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/fournisseur/editSupplier.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Supplierhome extends StatefulWidget {
  const Supplierhome({super.key});

  @override
  State<Supplierhome> createState() => _ListSupplierState();
}

class _ListSupplierState extends State<Supplierhome> {
  late Future<List<Supplier>> _fournisseurFuture;

  @override
  void initState() {
    super.initState();
    _fournisseurFuture = getSupplier();
  }

  Future<List<Supplier>> getSupplier() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final List<Map<String, Object?>> fournisseurMaps =
        await db.query('fournisseur');
    return fournisseurMaps.map((fournisseurMap) {
      return Supplier(
        id: fournisseurMap['id'] as int,
        fournisseurName: (fournisseurMap['fournisseurName'] ?? '') as String,
        fournisseurAdress:
            (fournisseurMap['fournisseurAdress'] ?? '') as String,
        nif: (fournisseurMap['nif'] ?? '') as String,
        stat: (fournisseurMap['stat'] ?? '') as String,
        contact: (fournisseurMap['contact'] ?? '') as String,
        dateCreation: (fournisseurMap['dateCreation'] ?? '') as String,
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
            MaterialPageRoute(builder: (context) => const ClientHome()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Facturationhome()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
        break;
      case 6:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Configurationhome()));
        break;
      case 7:
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
                final dbHelper = DataBaseHelper();
                final db = await dbHelper.initDB();
                await db.insert('fournisseur', {
                  'fournisseurName': nameController.text,
                  'fournisseurAdress': addressController.text,
                  'nif': nifController.text,
                  'stat': statController.text,
                  'contact': contactController.text,
                  'dateCreation': dateController.text,
                });
                setState(() {
                  _fournisseurFuture = getSupplier();
                });
                Navigator.of(context).pop();
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
          future: _fournisseurFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No suppliers found"));
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
                                          builder: (context) => Editsupplier(
                                              supplier: fournisseur),
                                        ),
                                      ).then((value) {
                                        if (value == true) {
                                          setState(() {
                                            _fournisseurFuture = getSupplier();
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
                          Text("Addresse: ${fournisseur.fournisseurAdress}"),
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
        ));
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
