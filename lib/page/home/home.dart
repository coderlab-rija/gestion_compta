import 'package:flutter/material.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/bonCommandeNeutre.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/listBonCommande.dart';
import 'package:my_apk/page/gestion%20de%20stock/inventaires/inventaire.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/listProduct.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Profil(),
    const StockHome(),
    const Supplierhome(),
    const Boncommandeneutre(),
    const ClientHome(),
    const Facturationhome(),
    const Dashboard(),
    const Configurationhome(),
    const LoginScreen(),
    const ListBoncommande(),
    const Listproduct(),
    const Inventaire(),
    const Boncommandeneutre(),
    const ListBoncommande(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? ''
              : _selectedIndex == 1
                  ? 'Inventory Management'
                  : _selectedIndex == 2
                      ? 'Listes des fournisseurs'
                      : _selectedIndex == 3
                          ? 'Achat fournisseurs'
                          : _selectedIndex == 4
                              ? 'Listes des clients'
                              : _selectedIndex == 5
                                  ? 'Facturation'
                                  : _selectedIndex == 6
                                      ? 'Dashboard'
                                      : _selectedIndex == 7
                                          ? 'Configuration'
                                          : _selectedIndex == 8
                                              ? 'Log out'
                                              : _selectedIndex == 9
                                                  ? 'Commandes fournisseurs'
                                                  : _selectedIndex == 10
                                                      ? 'Listes des articles' //OKK//
                                                      : _selectedIndex == 11
                                                          ? 'Mouvement de stock' //OKK//
                                                          : _selectedIndex == 12
                                                              ? 'Faire une achat'
                                                              : 'Lstes des commandes',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: _pages[_selectedIndex],
    );
  }
}
