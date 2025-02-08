import 'package:flutter/material.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/bonCommandeNeutre.dart';
import 'package:my_apk/page/gestion%20de%20stock/categories/listCategory.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Addcategory extends StatefulWidget {
  const Addcategory({super.key});

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  final nameCategorie = TextEditingController();
  final description = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
            MaterialPageRoute(builder: (context) => const Boncommandeneutre()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ClientHome()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Facturationhome()));
        break;
      case 6:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
        break;
      case 7:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Configurationhome()));
        break;
      case 8:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a Category')),
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
                  const Text(
                    "Add a category",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    child: TextFormField(
                      controller: nameCategorie,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Category Name is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.category),
                        border: InputBorder.none,
                        hintText: "Category Name",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    child: TextFormField(
                      controller: description,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
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
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final db = DataBaseHelper();
                          int categoryId = await db.addCategory(Category(
                            name: nameCategorie.text,
                            description: description.text,
                          ));

                          if (categoryId > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Category added successfully!')),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Listcategory()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to add category')),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Add",
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
