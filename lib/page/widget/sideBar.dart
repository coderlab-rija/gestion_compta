import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemSelected;

  const Sidebar({Key? key, required this.onItemSelected, String? userRole})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onTap: () => onItemSelected(0),
          ),
          ExpansionTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Stock'),
            children: [
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Articles'),
                onTap: () => onItemSelected(1),
              ),
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Stocks articles'),
                onTap: () => onItemSelected(2),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Gestion fournisseur'),
            onTap: () => onItemSelected(3),
          ),
          ExpansionTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Achat fournisseur'),
            children: [
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Faire une achat'),
                onTap: () => onItemSelected(4),
              ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('Bon de commande'),
                onTap: () => onItemSelected(5),
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Bon de reception'),
                onTap: () => onItemSelected(6),
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Facture'),
                onTap: () => onItemSelected(7),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Gestion client'),
            onTap: () => onItemSelected(8),
          ),
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text('Facturation'),
            onTap: () => onItemSelected(9),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => onItemSelected(10),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuration'),
            onTap: () => onItemSelected(11),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Hisotrique'),
            onTap: () => onItemSelected(12),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () => onItemSelected(13),
          ),
        ],
      ),
    );
  }
}
