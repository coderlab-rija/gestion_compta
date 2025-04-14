import 'package:flutter/material.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/database/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProfils extends StatefulWidget {
  final String initialUsername;
  final String initialLastname;
  final String initialEmail;
  final String initialPassword;

  const SettingProfils({
    Key? key,
    required this.initialUsername,
    required this.initialLastname,
    required this.initialEmail,
    required this.initialPassword,
  }) : super(key: key);

  @override
  State<SettingProfils> createState() => _SettingProfilsState();
}

class _SettingProfilsState extends State<SettingProfils> {
  late TextEditingController username;
  late TextEditingController lastname;
  late TextEditingController email;
  final formKey = GlobalKey<FormState>();
  final dbHelper = DataBaseHelper();
  int? userId;

  @override
  void initState() {
    super.initState();
    username = TextEditingController(text: widget.initialUsername);
    lastname = TextEditingController(text: widget.initialLastname);
    email = TextEditingController(text: widget.initialEmail);
    _loadUserData();
  }

  @override
  void dispose() {
    username.dispose();
    lastname.dispose();
    email.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      Utilisateur? utilisateur = await dbHelper.getUtilisateurById(userId!);
      if (utilisateur != null) {
        setState(() {
          username.text = utilisateur.username;
          lastname.text = utilisateur.lastname;
          email.text = utilisateur.email;
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    if (formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? userPassword = prefs.getString('userPassword');
      String? userRole = prefs.getString('role');

      if (userId != null && userPassword != null) {
        Utilisateur utilisateur = Utilisateur(
          id: userId,
          username: username.text,
          lastname: lastname.text,
          email: email.text,
          password: userPassword,
          role: userRole,
        );

        await dbHelper.updateProfil(utilisateur);

        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil modifié avec succès")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Erreur : Impossible de récupérer l'utilisateur connecté")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ListTile(
                    title: Center(
                      child: Text(
                        "Modifier le Profil",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ///USERNAME///
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nom d'utilisateur obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Nom d'utilisateur",
                      ),
                    ),
                  ),

                  ///LASTNAME///
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: lastname,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Prénom obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person_add),
                        border: InputBorder.none,
                        hintText: "Prénom",
                      ),
                    ),
                  ),

                  ///EMAIL///
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: email,
                      enabled: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "E-mail obligatoire";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: "E-mail",
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple,
                    ),
                    child: TextButton(
                      onPressed: _saveChanges,
                      child: const Text(
                        "Enregistrer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
