import 'package:flutter/material.dart';
import 'package:my_apk/database/client.dart';
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

class Editclient extends StatefulWidget {
  final Client client;

  const Editclient({super.key, required this.client});

  @override
  State<Editclient> createState() => _EditClientState();
}

class _EditClientState extends State<Editclient> {
  final TextEditingController clientName = TextEditingController();
  final TextEditingController clientSurname = TextEditingController();
  final TextEditingController clientAdress = TextEditingController();
  final TextEditingController mailAdress = TextEditingController();
  final TextEditingController nif = TextEditingController();
  final TextEditingController stat = TextEditingController();
  final TextEditingController codeClient = TextEditingController();
  final TextEditingController contact = TextEditingController();
  bool isPro = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    clientName.text = widget.client.clientName;
    clientSurname.text = widget.client.clientSurname;
    clientAdress.text = widget.client.clientAdress;
    mailAdress.text = widget.client.mailAdress;
    nif.text = widget.client.nif;
    stat.text = widget.client.stat;
    codeClient.text = widget.client.codeClient;
    isPro = widget.client.pro;
    contact.text = widget.client.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Client")),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField(
                    controller: clientName,
                    label: "Nom du client",
                    icon: Icons.person,
                  ),
                  _buildTextField(
                    controller: clientSurname,
                    label: "Prenom du client",
                    icon: Icons.person,
                  ),
                  _buildTextField(
                    controller: clientAdress,
                    label: "Adresse",
                    icon: Icons.home,
                  ),
                  _buildTextField(
                    controller: contact,
                    label: "Contact",
                    icon: Icons.phone,
                  ),
                  _buildTextField(
                    controller: nif,
                    label: "NIF",
                    icon: Icons.money,
                    readOnly: !isPro,
                    validator: (value) {
                      if (isPro && (value == null || value.isEmpty)) {
                        return "Le NIF est obligatoire pour les clients Pro";
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: stat,
                    label: "STAT",
                    icon: Icons.description,
                    readOnly: !isPro,
                    validator: (value) {
                      if (isPro && (value == null || value.isEmpty)) {
                        return "Le STAT est obligatoire pour les clients Pro";
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: codeClient,
                    label: "Code Client",
                    icon: Icons.code,
                    readOnly: true,
                  ),
                  Row(
                    children: [
                      const Text("Pro: "),
                      Checkbox(
                        value: isPro,
                        onChanged: (bool? value) {
                          setState(() {
                            isPro = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final db = DataBaseHelper();
                          db.updateClient(Client(
                            id: widget.client.id,
                            clientName: clientName.text,
                            clientSurname: clientSurname.text,
                            clientAdress: clientAdress.text,
                            mailAdress: mailAdress.text,
                            contact: contact.text,
                            nif: nif.text,
                            stat: stat.text,
                            codeClient: codeClient.text,
                            pro: isPro,
                          ));
                          Navigator.pop(context, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Client updated successfully"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Update",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple.withOpacity(.2),
      ),
      height: 60,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          labelText: label,
        ),
      ),
    );
  }
}
