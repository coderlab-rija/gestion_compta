import 'package:flutter/material.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/client/ClientHome.dart';
import 'package:my_apk/page/configuration/configurationHome.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/bonCommandeNeutre.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/commande/listBonCommande.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/inventaires/inventaire.dart';
import 'package:my_apk/page/gestion%20de%20stock/produits/listProduct.dart';
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Boncommandeneutre()));
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Configurationhome()));
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.all(1.0),
          child: Center(
              child: Text(
            'Votre profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
        ),
      ),
      // Ajout du latéral
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/image_side_bar.png"),
                ),
              ),
              child: Text(''),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () => _onItemSelected(0),
            ),
            ExpansionTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Stock'),
              children: [
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Articles'),
                  onTap: () => _onItemSelected(1),
                ),
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Stocks articles'),
                  onTap: () => _onItemSelected(2),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestion fournisseur'),
              onTap: () => _onItemSelected(3),
            ),
            ExpansionTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Achat fournisseur'),
              children: [
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Faire une achat'),
                  onTap: () => _onItemSelected(4),
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text('Bon de commande'),
                  onTap: () => _onItemSelected(5),
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: const Text('Bon de reception'),
                  onTap: () => _onItemSelected(6),
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: const Text('Facture'),
                  onTap: () => _onItemSelected(7),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestion client'),
              onTap: () => _onItemSelected(8),
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Facturation'),
              onTap: () => _onItemSelected(9),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => _onItemSelected(10),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuration'),
              onTap: () => _onItemSelected(11),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Hisotrique'),
              onTap: () => _onItemSelected(12),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () => _onItemSelected(13),
            ),
          ],
        ),
      ),
      body: const Center(child: Body()),
    );
  }
}
