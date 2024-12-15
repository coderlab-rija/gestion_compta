import 'package:flutter/material.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  State<Historique> createState() => _HistoriqueproduitState();
}

class _HistoriqueproduitState extends State<Historique> {
  List<Map<String, dynamic>> _historiqueList = [];
  bool _isLoading = true;
  String _filterType = 'category';

  @override
  void initState() {
    super.initState();
    _loadHistorique();
  }

  Future<void> _loadHistorique() async {
    final dbHelper = DataBaseHelper();
    List<Map<String, dynamic>> historique;

    if (_filterType == 'category') {
      historique = await dbHelper.getAllHistoriqueCategory();
    } else {
      historique = await dbHelper.getAllHistoriqueProduct();
    }

    setState(() {
      _historiqueList = historique;
      _isLoading = false;
    });
  }

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
          MaterialPageRoute(builder: (context) => const Supplierhome()),
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
        elevation: 0,
        title: DropdownButtonFormField<String>(
          value: _filterType,
          icon: const Icon(Icons.filter_list, color: Colors.white),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'category',
              child: Text('Category History'),
            ),
            DropdownMenuItem(
              value: 'product',
              child: Text('Product History'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _filterType = value ?? 'category';
              _isLoading = true;
            });
            _loadHistorique();
          },
        ),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historiqueList.isEmpty
              ? const Center(
                  child: Text(
                    'No history found.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _historiqueList.length,
                  itemBuilder: (context, index) {
                    final historique = _historiqueList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.history, color: Colors.blue),
                        title: Text(
                          'Action: ${historique['action']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Name: ${historique['categoryName'] ?? historique['produitName']}'),
                            Text('Users: ${historique['username']}'),
                            Text(
                              'Date: ${historique['dateAction']}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
