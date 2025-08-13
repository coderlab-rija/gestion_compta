import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/database/uniteProduit.dart';

class Fonction {
  Future<List<Categorie>> getCategory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid == null) {
        throw Exception("Utilisateur non connecté");
      }

      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/category/user?uid=$uid"),
        headers: {
          "Content-Type": "application/json",
          "X-User-UID": uid,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['category'] is! List) {
          return [];
        }
        final List<dynamic> categoryData = responseData['category'];

        return categoryData.map((category) {
          return Categorie(
              id: category['id'],
              idCategorie: category['idCategorie'],
              name: category['name'],
              description: category['description']);
        }).toList();
      } else {
        throw Exception('Erreur backend : ${response.body}');
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération des clients: $e");
    }
  }

  Future<List<Unite>> getUnity() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid == null) {
        throw Exception("Utilisateur non connecté");
      }

      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/unite/user?uid=$uid"),
        headers: {
          "Content-Type": "application/json",
          "X-User-UID": uid,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['unite'] is! List) {
          return [];
        }
        final List<dynamic> unityData = responseData['unite'];

        return unityData.map((unite) {
          return Unite(
              id: unite['id'],
              idUnity: unite['idUnity'],
              name: unite['name'],
              unite: unite['unite']);
        }).toList();
      } else {
        throw Exception('Erreur backend : ${response.body}');
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération des clients: $e");
    }
  }

  Future<void> updateUnity(int idUnity, String name, String unite) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) throw Exception("Utilisateur non connecté");

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8000/unite/$idUnity"),
      headers: {
        "Content-Type": "application/json",
        "X-User-UID": uid,
      },
      body: jsonEncode({
        "name": name,
        "unite": unite,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Échec de la mise à jour : ${response.body}");
    }
  }

  Future<List<Product>> getProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid == null) {
      throw Exception('Utilisateur non connecté');
    }

    final Uri url = Uri.parse('http://10.0.2.2:8000/products/user?uid=$uid');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'X-User-UID': uid,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> products = responseData['products'];
 
      return products.map((products) {
        return Product(
          id: products['id'],
          idProduct: products['idProduct'],
          name: products['name'],
          description: products['description'],
          unityId: products['unityId'],
          unityName: products['unityName'],
          idCategorie: products['idCategorie'],
          categoryName: products['categoryName'],
        );
      }).toList();
    } else {
      throw Exception(
          'Erreur lors de la récupération des produits: ${response.statusCode}');
    }
  }
}
