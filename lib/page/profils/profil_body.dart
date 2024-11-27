import 'package:flutter/material.dart';
import 'package:my_apk/database/users.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/profils/profil_Pic.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/profils/setting_profils.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/facturation/facturationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/widget/sideBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_apk/function/sqlite.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String userName = '';
  String lastname = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      DataBaseHelper dbHelper = DataBaseHelper();
      Utilisateur? utilisateur = await dbHelper.getUtilisateurById(userId);

      if (utilisateur != null) {
        setState(() {
          userName = utilisateur.username;
          lastname = utilisateur.lastname;
          userEmail = utilisateur.email;
        });
      }
    }
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        // appBar: AppBar(),
        drawer: Sidebar(onItemSelected: _onItemSelected),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const ProfilPic(),
              const SizedBox(height: 20),
              if (userName.isNotEmpty && userEmail.isNotEmpty) ...[
                Text(
                  lastname,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  userEmail,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingProfils(
                        initialUsername: userName,
                        initialLastname: lastname,
                        initialEmail: userEmail,
                      ),
                    ),
                  );
                  if (result == true) {
                    _loadUserData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Modifier le profil"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
