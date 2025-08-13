import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_apk/page/fournisseur/supplierHome.dart';
import 'package:my_apk/page/profils/profil_Pic.dart';
import 'package:my_apk/page/profils/profil_home.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
import 'package:my_apk/page/gestion%20de%20stock/achat%20fournisseur/facturation/facturationHome.dart';
import 'package:my_apk/page/gestion%20de%20stock/stockHome.dart';
import 'package:my_apk/page/authentification/login.dart';
import 'package:my_apk/page/profils/setting_profils.dart';
import 'package:my_apk/page/widget/sideBar.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String userName = '';
  String lastname = '';
  String userEmail = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await getUserDataFromFirestore(user.uid);

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur de récupération des données utilisateur : $e");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getUserDataFromFirestore(String uid) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        String userNameFromFirestore =
            "${data?['username'] ?? ''} ${data?['lastname'] ?? ''}".trim();
        String emailFromFirestore = data?['email'] ?? 'Email non disponible';

        setState(() {
          userName = userNameFromFirestore;
          email = emailFromFirestore;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur de récupération des données : $e");
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
        drawer: Sidebar(onItemSelected: _onItemSelected),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const ProfilPic(),
              const SizedBox(height: 20),
              if (isLoading) ...[
                const CircularProgressIndicator(),
              ] else if (userName.isNotEmpty && email.isNotEmpty) ...[
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingProfils(),
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
