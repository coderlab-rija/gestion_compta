import 'package:flutter/material.dart';
import 'package:my_apk/database/paiement.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Paiement extends StatefulWidget {
  const Paiement({super.key});

  @override
  State<Paiement> createState() => _PaiementState();
}

class _PaiementState extends State<Paiement> {
  late Future<List<PaiementMode>> _paiementFuture;
  String selectedMode = "Bancaire"; // Default mode
  String selectedOperateur = "Telma"; // Default operator for Mobile Money
  final codeController = TextEditingController();
  final numeroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _paiementFuture = fetchPaiement();
  }

  Future<List<PaiementMode>> fetchPaiement() async {
    final dbHelper = DataBaseHelper();
    return await dbHelper.getPaiment();
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

  void _addPaiement() {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un mode de paiement'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedMode,
                  decoration:
                      const InputDecoration(labelText: "Mode de paiement"),
                  items: const [
                    DropdownMenuItem(
                        value: "Bancaire", child: Text("Bancaire")),
                    DropdownMenuItem(
                        value: "Mobile Money", child: Text("Mobile Money")),
                    DropdownMenuItem(value: "Espèce", child: Text("Espèce")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedMode = value!;
                      // Reset fields when mode changes
                      selectedOperateur =
                          selectedMode == "Mobile Money" ? "Telma" : "N/A";
                      numeroController.clear();
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (selectedMode == "Mobile Money")
                  DropdownButtonFormField<String>(
                    value: selectedOperateur,
                    decoration: const InputDecoration(labelText: "Opérateur"),
                    items: const [
                      DropdownMenuItem(value: "Telma", child: Text("Telma")),
                      DropdownMenuItem(value: "Orange", child: Text("Orange")),
                      DropdownMenuItem(value: "Airtel", child: Text("Airtel")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedOperateur = value!;
                      });
                    },
                  ),
                const SizedBox(height: 16),
                if (selectedMode == "Mobile Money")
                  TextFormField(
                    controller: numeroController,
                    decoration: const InputDecoration(labelText: "Numéro"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Le numéro est requis.";
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: "Code"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le code est requis.";
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
                  final dbHelper = DataBaseHelper();
                  await dbHelper.AddPaiement(
                    PaiementMode(
                      mode: selectedMode,
                      code: codeController.text,
                      operateur: selectedMode == "Mobile Money"
                          ? selectedOperateur
                          : "N/A",
                      numero: selectedMode == "Mobile Money"
                          ? numeroController.text
                          : "N/A",
                    ),
                  );
                  setState(() {
                    _paiementFuture = fetchPaiement();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Mode de paiement ajouté avec succès."),
                    ),
                  );
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
        title: const Text("Listes des paiements"),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: FutureBuilder<List<PaiementMode>>(
        future: _paiementFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun paiement trouvé."));
          } else {
            final paiement = snapshot.data!;
            return ListView.builder(
              itemCount: paiement.length,
              itemBuilder: (context, index) {
                final response = paiement[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      response.mode,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(response.operateur),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPaiement,
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un nouveau mode de paiement',
      ),
    );
  }
}
