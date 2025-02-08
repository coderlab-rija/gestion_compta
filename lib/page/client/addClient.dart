import 'package:flutter/material.dart';
import 'package:my_apk/database/client.dart';
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

class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  State<AddClient> createState() => _AjoutClientState();
}

class _AjoutClientState extends State<AddClient> {
  final TextEditingController clientName = TextEditingController();
  final TextEditingController clientSurname = TextEditingController();
  final TextEditingController clientAdress = TextEditingController();
  final TextEditingController mailAdress = TextEditingController();
  final TextEditingController nif = TextEditingController();
  final TextEditingController stat = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController codeClient = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPro = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
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
                  // const ListTile(
                  //   title: Center(
                  //     child: Text(
                  //       "Add client",
                  //       style: TextStyle(
                  //           fontSize: 40, fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  // Nom
                  buildTextField(
                      controller: clientName,
                      hintText: "Nom",
                      icon: Icons.person),
                  // Prénom
                  buildTextField(
                      controller: clientSurname,
                      hintText: "Prénom",
                      icon: Icons.person_outline),
                  // Adresse
                  buildTextField(
                      controller: clientAdress,
                      hintText: "Adresse",
                      icon: Icons.home),
                  // E-mail
                  buildTextField(
                      controller: mailAdress,
                      hintText: "E-mail",
                      icon: Icons.email),
                  // NIF
                  buildTextField(
                      controller: nif, hintText: "NIF", icon: Icons.numbers),
                  // STAT
                  buildTextField(
                      controller: stat, hintText: "STAT", icon: Icons.info),
                  // Contact
                  buildTextField(
                      controller: contact,
                      hintText: "Contact",
                      icon: Icons.contact_phone),
                  // Code client
                  buildTextField(
                      controller: codeClient,
                      hintText: "Code Client",
                      icon: Icons.code),

                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text("Client professionnel ?"),
                    value: isPro,
                    onChanged: (value) {
                      setState(() {
                        isPro = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  // Bouton pour ajouter le client
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
                          db.AddClient(Client(
                            clientName: clientName.text,
                            clientSurname: clientSurname.text,
                            clientAdress: clientAdress.text,
                            mailAdress: mailAdress.text,
                            nif: nif.text,
                            stat: stat.text,
                            contact: contact.text,
                            codeClient: codeClient.text,
                            pro: isPro,
                          )).then((value) {
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
                        "Add client",
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

  Widget buildTextField(
      {required TextEditingController controller,
      required String hintText,
      required IconData icon}) {
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
        validator: (value) {
          if (value!.isEmpty) {
            return "$hintText obligatoire";
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
