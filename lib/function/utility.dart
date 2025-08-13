import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/function/sqlite.dart';

class Utility {
  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> checkConnectionAndSync() async {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      bool online = await isOnline();

      if (online) {
        var box = await Hive.openBox('offline_data');
        var userData = box.get('user_data');

        if (userData != null) {
          var data = jsonDecode(userData);

          final response = await http.post(
            Uri.parse("http://10.0.2.2:8000/users"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": data['email'],
              "password": data['password'],
              "lastname": data['lastname'],
              "username": data['username'],
              "role": data['role'],
            }),
          );

          if (response.statusCode == 200) {
            box.delete('user_data');
          }
        }
      }
    });
  }

  Future<String> generateClientCode() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final result =
        await db.rawQuery('SELECT * FROM client ORDER BY id DESC LIMIT 1');

    String lastCode = '';

    if (result.isNotEmpty) {
      lastCode = result.first['codeClient'] as String? ?? '';
    }

    String numericPart = '0';
    if (lastCode.length >= 3) {
      numericPart = lastCode.substring(3);
    }

    int newNumericPart = int.tryParse(numericPart) ?? 0;
    newNumericPart++;

    String newCode = 'CL_${newNumericPart.toString().padLeft(3, '0')}';
    return newCode;
  }

  String generateReference(int fournisseurId) {
    String dateCommande =
        DateTime.now().toIso8601String().substring(0, 10).replaceAll("-", "");
    String randomCode = _generateRandomString(5);
    return 'Achat/Fournisseur-$fournisseurId-$dateCommande-$randomCode';
  }

  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Future<List<Product>> getFilteredProducts(int? categoryId) async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final List<Map<String, Object?>> produitMaps = await db.query(
      'product',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    return produitMaps.map((produitMap) {
      return Product(
        id: produitMap['id'] as String,
        idProduct: produitMap['idProduct'] as int,
        name: produitMap['name'] as String,
        description: produitMap['description'] as String,
        idCategorie: produitMap['idCategorie'] as int,
        unityId: produitMap['unityId'] as int,
      );
    }).toList();
  }

  String convertirNombreEnLettre(double montant) {
    final List<String> unites = [
      '',
      'un',
      'deux',
      'trois',
      'quatre',
      'cinq',
      'six',
      'sept',
      'huit',
      'neuf',
      'dix',
      'onze',
      'douze',
      'treize',
      'quatorze',
      'quinze',
      'seize',
      'dix-sept',
      'dix-huit',
      'dix-neuf'
    ];

    final List<String> dizaines = [
      '',
      '',
      'vingt',
      'trente',
      'quarante',
      'cinquante',
      'soixante',
      'soixante',
      'quatre-vingt',
      'quatre-vingt'
    ];

    String convertirEntier(int n) {
      if (n < 20) return unites[n];

      if (n < 100) {
        int dizaine = n ~/ 10;
        int unite = n % 10;
        String prefixe = dizaines[dizaine];
        if (dizaine == 7 || dizaine == 9) {
          unite += 10;
        }

        String separateur = (unite == 1 && dizaine != 8) ? ' et ' : '-';
        return prefixe +
            (unite > 0
                ? '$separateur${unites[unite]}'
                : (dizaine == 8 ? 's' : ''));
      }

      if (n < 1000) {
        int centaines = n ~/ 100;
        int reste = n % 100;
        String centaineStr =
            '${centaines > 1 ? '${unites[centaines]} ' : ''}cent';
        if (reste == 0 && centaines > 1) centaineStr += 's';
        return centaineStr + (reste > 0 ? ' ${convertirEntier(reste)}' : '');
      }

      if (n < 1000000) {
        int milliers = n ~/ 1000;
        int reste = n % 1000;
        String milleStr =
            (milliers > 1 ? '${convertirEntier(milliers)} mille' : 'mille');
        return milleStr + (reste > 0 ? ' ${convertirEntier(reste)}' : '');
      }

      if (n < 1000000000) {
        int millions = n ~/ 1000000;
        int reste = n % 1000000;
        String millionStr =
            '${convertirEntier(millions)} million${millions > 1 ? 's' : ''}';
        return millionStr + (reste > 0 ? ' ${convertirEntier(reste)}' : '');
      }

      return 'nombre trop grand';
    }

    int entier = montant.floor();
    return convertirEntier(entier);
  }

  Future<void> signUp(
      String username, String lastname, String email, String password) async {
    final url = Uri.parse(
        'http://127.0.0.1:8000/register'); // Remplace par l'URL de ton API
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'lastname': lastname,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Si la requête est réussie, tu peux traiter la réponse ici
      print('Registration successful');
    } else {
      // Si l'inscription échoue, tu peux afficher une erreur
      print('Registration failed');
    }
  }
}
