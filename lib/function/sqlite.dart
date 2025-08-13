import 'dart:async';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:my_apk/database/achatFournisseur.dart';
import 'package:my_apk/database/client.dart';
import 'package:my_apk/database/fournisseur.dart';
import 'package:my_apk/database/hisotriqueCategory.dart';
import 'package:my_apk/database/hisotriqueProduit.dart';
import 'package:my_apk/database/paiement.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/uniteProduit.dart';
import 'package:my_apk/database/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'rija-base43.db');
    if (kDebugMode) {
      print('Database path: $path');
    }
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE utilisateur (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, lastname TEXT, email TEXT UNIQUE, password TEXT)',
        );

        await db.execute(
          'CREATE TABLE product (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT, categoryId INTEGER, unityId INTEGER, FOREIGN KEY(categoryId) REFERENCES category(id), FOREIGN KEY(unityId) REFERENCES unity(id))',
        );

        await db.execute(
          'CREATE TABLE category (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT)',
        );

        await db.execute(
          'CREATE TABLE unity (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, unite TEXT NOT NULL)',
        );

        await db.execute(
          'CREATE TABLE fournisseur (id INTEGER PRIMARY KEY AUTOINCREMENT, fournisseurName TEXT NOT NULL, fournisseurAdress TEXT, nif TEXT, stat TEXT, contact TEXT, dateCreation TEXT)',
        );

        await db.execute(
          'CREATE TABLE paiementMode (id INTEGER PRIMARY KEY AUTOINCREMENT, mode TEXT NOT NULL, code TEXT NOT NULL, operateur TEXT, numero TEXT)',
        );

        await db.execute(
          'CREATE TABLE bonReception (id INTEGER PRIMARY KEY AUTOINCREMENT, achatFournisseurId TEXT NOT NULL, dateReception TEXT NOT NULL, referenceReception TEXT)',
        );

        await db.execute('CREATE TABLE client ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'clientName TEXT NOT NULL, '
            'clientSurname TEXT NOT NULL, '
            'clientAdress TEXT NOT NULL, '
            'mailAdress TEXT NOT NULL, '
            'nif TEXT, '
            'stat TEXT, '
            'contact TEXT, '
            'pro INTEGER DEFAULT 0, ' // 0 = false, 1 = true
            'codeClient TEXT NOT NULL UNIQUE)');

        await db.execute('''
          CREATE TABLE historique_categorie (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            action TEXT NOT NULL,
            categoryId TEXT NOT NULL,
            categoryName TEXT NOT NULL,
            username TEXT NOT NULL,
            dateAction TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE historique_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            action TEXT NOT NULL,
            produitId TEXT NOT NULL,
            produitName TEXT NOT NULL,
            username TEXT NOT NULL,
            dateAction TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE bonCommande (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fournisseurId INTEGER NOT NULL,
            produitId INTEGER NOT NULL,
            categoryId INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            prixAchat REAL NOT NULL,
            prixVente REAL NOT NULL,
            dateCommande TEXT NOT NULL,
            status TEXT NOT NULL,
            reference TEXT NOT NULL,
            FOREIGN KEY (fournisseurId) REFERENCES fournisseur(id),
            FOREIGN KEY (produitId) REFERENCES product(id),
            FOREIGN KEY (categoryId) REFERENCES category(id)
          )
        ''');
      },
    );
  }

  Future<int?> login(Utilisateur utilisateur) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
      "SELECT * FROM utilisateur WHERE email = ? AND password = ?",
      [utilisateur.email, utilisateur.password],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }

  Future<int> signUp(Utilisateur utilisateur) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'utilisateur',
        utilisateur.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<void> signUps(
      String username, String lastname, String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/register');
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
      if (kDebugMode) {
        print('Registration successful');
      }
    } else {
      if (kDebugMode) {
        print('Registration failed');
      }
    }
  }

  Future<List<Utilisateur>> getUsers() async {
    final db = await initDB();
    final List<Map<String, Object?>> usersMaps = await db.query('utilisateur');

    return usersMaps.map((userMap) {
      return Utilisateur(
        id: userMap['id'] as int,
        username: userMap['username'] as String,
        lastname: userMap['lastname'] as String,
        email: userMap['email'] as String,
        password: userMap['password'] as String,
      );
    }).toList();
  }

  Future<Utilisateur?> getUtilisateurById(int userId) async {
    final db = await initDB();
    final List<Map<String, Object?>> userMaps = await db.query(
      'utilisateur',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (userMaps.isNotEmpty) {
      return Utilisateur(
        id: userMaps[0]['id'] as int,
        username: userMaps[0]['username'] as String,
        lastname: userMaps[0]['lastname'] as String,
        email: userMaps[0]['email'] as String,
        password: userMaps[0]['password'] as String,
      );
    }

    return null;
  }

  Future<void> updateProfil(Utilisateur utilisateur) async {
    final db = await initDB();
    await db.update(
      'utilisateur',
      utilisateur.toMap(),
      where: 'id = ?',
      whereArgs: [utilisateur.id],
    );
  }

  //////////////////////////////////category///////////////////////////////////////////

  Future<List<Categorie>> getCategory() async {
    final db = await initDB();
    final List<Map<String, Object?>> categoriesMaps =
        await db.query('category');

    return categoriesMaps.map((categoryMap) {
      return Categorie(
        id: categoryMap['id'] as String,
        idCategorie: categoryMap['idCategorie'] as int,
        name: categoryMap['name'] as String,
        description: categoryMap['description'] as String,
      );
    }).toList();
  }

  Future<int> addCategory(Categorie category) async {
    try {
      final Database db = await initDB();
      int categoryId = await db.insert(
        'category',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (categoryId != -1) {
        final prefs = await SharedPreferences.getInstance();
        String username = prefs.getString('username') ?? 'Unknown';
        final historique = HistoriqueCategory(
          action: 'insertion',
          categoryId: categoryId.toString(),
          categoryName: category.name,
          username: username,
          dateAction: DateTime.now().toIso8601String(),
        );
        await db.insert(
          'historique_categorie',
          historique.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return categoryId;
    } catch (e) {
      print("Error adding category: $e");
      return -1;
    }
  }

  Future<void> addHistoryEntry(
      String action, String categoryId, String categoryName) async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Unknown';

    final Database db = await initDB();
    await db.insert('historique_categorie', {
      'action': action,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'username': username,
      'dateAction': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllHistoriqueCategory() async {
    final Database db = await initDB();
    return await db.query(
      'historique_categorie',
      orderBy: 'dateAction DESC',
    );
  }

  Future<void> updateCategory(Categorie category) async {
    final db = await initDB();

    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );

    String action = await getActionFromSharedPreferences();
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Unknown';

    final historique = HistoriqueCategory(
      action: action,
      categoryId: category.id.toString(),
      categoryName: category.name,
      username: username,
      dateAction: DateTime.now().toIso8601String(),
    );

    await db.insert(
      'historique_categorie',
      historique.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteCategory(int id) async {
    try {
      final Database db = await initDB();
      return await db.delete(
        'categorie',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return -1;
    }
  }

  Future<String> getActionFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('category_action') ?? 'unknown';
  }

  //////////////////////////////////product///////////////////////////////////////////

  Future<int> addProduct(Product product) async {
    try {
      final Database db = await initDB();
      int productId = await db.insert(
        'product',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (productId != -1) {
        final prefs = await SharedPreferences.getInstance();
        String username = prefs.getString('username') ?? 'Unknown';

        final historique = Hisotriqueproduct(
          action: 'insertion',
          produitId: productId.toString(),
          produitName: product.name,
          username: username,
          dateAction: DateTime.now().toIso8601String(),
        );

        await db.insert(
          'historique_products',
          historique.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return productId;
    } catch (e) {
      print("Error adding product: $e");
      return -1;
    }
  }

  Future<void> addProductEntry(
      String action, String produitId, String produitName) async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Unknown';

    final Database db = await initDB();
    await db.insert('historique_products', {
      'action': action,
      'produitId': produitId,
      'produitName': produitName,
      'username': username,
      'dateAction': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateProduct(Product product) async {
    final db = await initDB();
    await db.update(
      'product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );

    String action = await getActionProductFromSharedPreferences();

    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Unknown';

    final historique = Hisotriqueproduct(
      action: action,
      produitId: product.id.toString(),
      produitName: product.name,
      username: username,
      dateAction: DateTime.now().toIso8601String(),
    );

    await db.insert(
      'historique_products',
      historique.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllHistoriqueProduct() async {
    final Database db = await initDB();
    return await db.query(
      'historique_products',
      orderBy: 'dateAction DESC',
    );
  }

  /*Future<List<Unite>> getUnite() async {
    final db = await initDB();
    final List<Map<String, Object?>> uniteMaps = await db.query('unite');

    return uniteMaps.map((uniteMaps) {
      return Unite(
        id: uniteMaps['id'] as int,
        name: uniteMaps['name'] as String,
        unite: uniteMaps['unite'] as String,
      );
    }).toList();
  }*/

  Future<int> deleteProduct(int id) async {
    try {
      final Database db = await initDB();
      return await db.delete(
        'produits',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return -1;
    }
  }

  Future<String> getActionProductFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('product_action') ?? 'unknown';
  }

  //////////////////////////////////supplier///////////////////////////////////////////

  Future<List<Supplier>> getSupplier() async {
    final db = await initDB();
    final List<Map<String, Object?>> fournisseurMaps =
        await db.query('fournisseur');

    return fournisseurMaps.map((fournisseurMaps) {
      return Supplier(
        id: fournisseurMaps['id'] as String,
        fournisseurName: fournisseurMaps['fournisseurName'] as String,
        fournisseurAdress: fournisseurMaps['fournisseurAdress'] as String,
        nif: fournisseurMaps['nif'] as String,
        stat: fournisseurMaps['stat'] as String,
        contact: fournisseurMaps['contact'] as String,
        dateCreation: fournisseurMaps['dateCreation'] as String,
      );
    }).toList();
  }

  Future<int> addSupplier(Supplier supplier) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'fournisseur',
        supplier.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    final db = await initDB();
    await db.update(
      'fournisseur',
      supplier.toMap(),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  /////////////////////////Client////////////////////////////////////////////

  Future<int> AddClient(Client client) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'client',
        client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }



  Future<void> updateClient(Client client) async {
    final db = await initDB();
    await db.update(
      'client',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  //////////////////////////////////unity///////////////////////////////////////////

  Future<int> AddUnity(Unite unite) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'unity',
        unite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }

  /*Future<List<Unite>> getUnity() async {
    final db = await initDB();
    final List<Map<String, Object?>> clientMaps = await db.query('unity');

    return clientMaps.map((clientMaps) {
      return Unite(
        id: clientMaps['id'] as int,
        name: clientMaps['name'] as String,
        unite: clientMaps['unite'] as String,
      );
    }).toList();
  }*/

  Future<void> updateUnity(Unite unite) async {
    final db = await initDB();
    await db.update(
      'unity',
      unite.toMap(),
      where: 'id = ?',
      whereArgs: [unite.id],
    );
  }

  Future<int> deleteUnity(int id) async {
    try {
      final Database db = await initDB();
      return await db.delete(
        'unity',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return -1;
    }
  }

  //////////////////////////////////paiement///////////////////////////////////////////

  Future<int> AddPaiement(PaiementMode paiement) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'paiementMode',
        paiement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<List<PaiementMode>> getPaiment() async {
    final db = await initDB();
    final List<Map<String, Object?>> paiementMaps =
        await db.query('paiementMode');

    return paiementMaps.map((paiementMaps) {
      return PaiementMode(
        id: paiementMaps['id'] as int,
        mode: paiementMaps['mode'] as String,
        code: paiementMaps['code'] as String,
        operateur: paiementMaps['operateur'] as String,
        numero: paiementMaps['numero'] as String,
      );
    }).toList();
  }

  //////////////////////////////////paiement///////////////////////////////////////////

  Future<int> AddBonCommande(AchatFournisseur achatFournisseur) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'bonCommande',
        achatFournisseur.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<List<AchatFournisseur>> getbonCommande() async {
    final db = await initDB();
    final List<Map<String, Object?>> bonCommandeMaps =
        await db.query('bonCommande');

    return bonCommandeMaps.map((bonCommandeMaps) {
      return AchatFournisseur(
        id: bonCommandeMaps['id'] as int,
        fournisseurId: bonCommandeMaps['fournisseurId'] as int,
        produitId: bonCommandeMaps['produitId'] as int,
        categoryId: bonCommandeMaps['categoryId'] as int,
        quantity: bonCommandeMaps['quantity'] as int,
        prixAchat: bonCommandeMaps['prixAchat'] as double,
        prixVente: bonCommandeMaps['prixVente'] as double,
        dateCommande: bonCommandeMaps['dateCommande'] as String,
        status: bonCommandeMaps['status'] as String,
        productName: bonCommandeMaps['productName'] as String,
        fournisseurName: bonCommandeMaps['fournisseurName'] as String,
        categoryName: bonCommandeMaps['categoryName'] as String,
        reference: bonCommandeMaps['reference'] as String,
      );
    }).toList();
  }
}
