import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingProfils extends StatefulWidget {
  const SettingProfils({super.key});

  @override
  State<SettingProfils> createState() => _SettingProfilsState();
}

class _SettingProfilsState extends State<SettingProfils> {
  final TextEditingController username = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          username.text = data['username'] ?? '';
          lastname.text = data['lastname'] ?? '';
          email.text = currentUser.email ?? '';
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    if (formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'username': username.text,
          'lastname': lastname.text,
        });

        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil mis à jour avec succès")),
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

                  /// USERNAME
                  _buildTextField(
                    controller: username,
                    icon: Icons.person,
                    hintText: "Nom d'utilisateur",
                    validatorMsg: "Nom d'utilisateur obligatoire",
                  ),

                  /// LASTNAME
                  _buildTextField(
                    controller: lastname,
                    icon: Icons.person_add,
                    hintText: "Prénom",
                    validatorMsg: "Prénom obligatoire",
                  ),

                  /// EMAIL (non modifiable)
                  _buildTextField(
                    controller: email,
                    icon: Icons.email,
                    hintText: "E-mail",
                    enabled: false,
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    onPressed: _saveChanges,
                    child: const Text("Enregistrer",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    String? validatorMsg,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple.withOpacity(.2),
      ),
      height: 60,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        validator: validatorMsg != null
            ? (value) => value!.isEmpty ? validatorMsg : null
            : null,
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
