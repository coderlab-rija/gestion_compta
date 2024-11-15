import 'package:flutter/material.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/listeFournisseurs.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_body.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.all(1.0),
          child: Center(
              child: Text(
            'Your Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
        ),
      ),
      // Ajout du latéral
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () => _onItemSelected(0),
            ),
            ListTile(
              title: const Text('Stock'),
              onTap: () => _onItemSelected(1),
            ),
            ListTile(
              title: const Text('Fournisseur'),
              onTap: () => _onItemSelected(2),
            ),
            ListTile(
              title: const Text('Facturation'),
              onTap: () => _onItemSelected(3),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () => _onItemSelected(4),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () => _onItemSelected(5),
            ),
          ],
        ),
      ),
      body: const Center(child: Body()),
    );
  }
}
