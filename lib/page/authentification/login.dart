import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_apk/page/home/home.dart';
import 'package:my_apk/page/authentification/signup.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final db = DataBaseHelper();
  bool isvisble = false;
  bool isLoginTrue = false;

  Future<void> login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      if (kDebugMode) {
        print("Utilisateur connecté : ${credential.user?.email}");
      }

      final uid = credential.user!.uid;

      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        final username = data['username'];
        final lastname = data['lastname'];
        final role = data['role'];

        final response = await http.post(
          Uri.parse("http://10.0.2.2:8000/login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "uid": uid,
            "username": username,
            "lastname": lastname,
            "email": credential.user!.email,
            "role": role,
          }),
        );

        if (response.statusCode == 200) {
          if (kDebugMode) {
            print("Connexion backend réussie !");
          }

          if (!mounted) return; // protection contre widget démonté
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          if (kDebugMode) {
            print("Erreur backend : ${response.body}");
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Erreur serveur")),
            );
          }
        }
      } else {
        if (kDebugMode) {
          print("Utilisateur non trouvé.");
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Utilisateur non trouvé")),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          isLoginTrue = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.message}")),
        );
      }

      if (kDebugMode) {
        print("Erreur login : ${e.code} - ${e.message}");
      }
    }
  }

  Future<void> getUtilisateurById(int userId) async {
    final utilisateur = await db.getUtilisateurById(userId);

    if (utilisateur != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', utilisateur.username);
      await prefs.setString('lastname', utilisateur.lastname);
      await prefs.setString('email', utilisateur.email);
    } else {
      print("Error: User not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/6573.jpg",
                    width: 300,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Mail is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.mail),
                        border: InputBorder.none,
                        hintText: "Mail",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple.withOpacity(.2),
                    ),
                    height: 60,
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                      obscureText: !isvisble,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Password",
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              isvisble = !isvisble;
                            });
                          },
                          icon: Icon(
                            isvisble ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
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
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          print("Validation successful");
                          await login();
                        }
                      },
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()),
                          );
                        },
                        child: const Text("SIGN UP"),
                      ),
                    ],
                  ),
                  isLoginTrue
                      ? const Text(
                          "Username or password is incorrect",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
