import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemSelected;

  const Sidebar({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/image_side_bar.png"))),
            child: Text(''),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () => onItemSelected(0),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Gestion de Stock'),
            onTap: () => onItemSelected(1),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Gestion des Fournisseurs'),
            onTap: () => onItemSelected(2),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Facturation'),
            onTap: () => onItemSelected(3),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Tableau de bord'),
            onTap: () => onItemSelected(4),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Se déconnecter'),
            onTap: () => onItemSelected(5),
          ),
        ],
      ),
    );
  }
}
