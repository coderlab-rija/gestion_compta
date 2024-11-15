import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de Bord"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Nombre de colonnes
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: const [
            DashboardCard(
              icon: Icons.people,
              label: "Utilisateurs",
              value: "120",
              color: Colors.blue,
            ),
            DashboardCard(
              icon: Icons.shopping_cart,
              label: "Ventes",
              value: "150",
              color: Colors.green,
            ),
            DashboardCard(
              icon: Icons.attach_money,
              label: "Revenus",
              value: "\$12K",
              color: Colors.orange,
            ),
            DashboardCard(
              icon: Icons.star,
              label: "Avis",
              value: "4.5",
              color: Colors.purple,
            ),
            DashboardCard(
              icon: Icons.show_chart,
              label: "Croissance",
              value: "+12%",
              color: Colors.red,
            ),
            DashboardCard(
              icon: Icons.notifications,
              label: "Notifications",
              value: "8",
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const DashboardCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Dashboard(),
  ));
}
