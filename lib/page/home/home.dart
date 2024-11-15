import 'package:flutter/material.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/listeFournisseurs.dart';
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
    const Fournisseurhome(),
    const Facturationhome(),
    const Dashboard(),
    const LoginScreen(),
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
                  ? 'Gestion des Inventaires'
                  : _selectedIndex == 2
                      ? 'Gestion des Fournisseurs'
                      : _selectedIndex == 3
                          ? 'Facturation'
                          : _selectedIndex == 4
                              ? 'Tableau de bord'
                              : 'Se déconnecter',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: _pages[_selectedIndex],
    );
  }
}
