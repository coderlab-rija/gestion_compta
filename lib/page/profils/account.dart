import 'package:flutter/material.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/listSupplier.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_Pic.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Cette partie liée aux produits a été supprimée
  // late Future<List<Produits>> _produitsFuture;

  @override
  void initState() {
    super.initState();
    // Plus besoin d'initialiser la future pour les produits
    // _produitsFuture = fetchProduits();
  }

  // La fonction de récupération des produits a été supprimée
  // Future<List<Produits>> fetchProduits() async {
  //   final dbHelper = DataBaseHelper();
  //   return await dbHelper.produits();
  // }

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
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter, // Positionner en bas de l'AppBar
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 50.0), // Ajuster la distance du bas
            child: const ProfilPic(), // Image du profil
          ),
        ),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
    );
  }
}
