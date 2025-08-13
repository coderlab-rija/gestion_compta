import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_apk/page/home/home.dart';
import 'package:my_apk/page/authentification/login.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassord = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isvisble = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ListTile(
                    title: Text(
                      "Register New Account",
                      style:
                          TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ///USERNAME///
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    height: 60,
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Username is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Username",
                      ),
                    ),
                  ),

                  ///LASTNAME///
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    height: 60,
                    child: TextFormField(
                      controller: lastname,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Lastname is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Lastname",
                      ),
                    ),
                  ),

                  ///MAIL///
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
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
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "Mail",
                      ),
                    ),
                  ),

                  ///PASSWORD///
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    height: 60,
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Passeword is required";
                        }
                        return null;
                      },
                      obscureText: isvisble,
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

                  ///CONFIRM PASSWORD///
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    height: 60,
                    child: TextFormField(
                      controller: confirmPassord,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Passeword is required";
                        } else if (password.text != confirmPassord.text) {
                          return "Password don't match";
                        }
                        return null;
                      },
                      obscureText: isvisble,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Confirm Password",
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
                    height: (45),
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.deepPurple,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(userCredential.user!.uid)
                                .set({
                              'uid': userCredential.user!.uid,
                              'lastname': lastname.text,
                              'username': username.text,
                              'email': email.text,
                              'role': 'admin',
                            });

                            final response = await http.post(
                              Uri.parse("http://10.0.2.2:8000/users"),
                              headers: {"Content-Type": "application/json"},
                              body: jsonEncode({
                                "uid": userCredential.user!.uid,
                                "lastname": lastname.text,
                                "username": username.text,
                                "email": email.text,
                                "role": "admin",
                              }),
                            );

                            if (response.statusCode == 200) {
                              if (kDebugMode) {
                                print(
                                    "Utilisateur inscrit et envoyé au backend avec succès !");
                              }
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            } else {
                              if (kDebugMode) {
                                print(
                                    "Erreur lors de l'envoi au backend : ${response.body}");
                              }
                            }
                          } on FirebaseAuthException catch (e) {
                            if (kDebugMode) {
                              print("Erreur Auth : ${e.code} - ${e.message}");
                            }
                          }
                        }
                      },
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
