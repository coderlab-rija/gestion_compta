import 'dart:async';
import 'package:my_apk/database/fournisseur.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/database/categorie.dart';
import 'package:my_apk/database/unite.dart';
import 'package:my_apk/database/users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'FISCACompte.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE utilisateur (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, lastname TEXT, email TEXT UNIQUE, password TEXT)',
        );

        await db.execute(
          'CREATE TABLE product (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, quantity INTEGER NOT NULL, price REAL NOT NULL, description TEXT, categoryId INTEGER, unity TEXT NOT NULL, FOREIGN KEY(categoryId) REFERENCES category(id))',
        );

        await db.execute(
          'CREATE TABLE category (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT)',
        );

        await db.execute(
          'CREATE TABLE fournisseur (id INTEGER PRIMARY KEY AUTOINCREMENT, nomFournisseur TEXT NOT NULL, addresseFournisseur TEXT, nif TEXT, stat TEXT, contact TEXT, dateCreation TEXT)',
        );

        await db.execute(
          'CREATE TABLE unite (id INTEGER PRIMARY KEY AUTOINCREMENT, nomFournisseur TEXT NOT NULL)',
        );
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

  Future<List<Utilisateur>> getUtilisateur() async {
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

  Future<List<Category>> getCategory() async {
    final db = await initDB();
    final List<Map<String, Object?>> categoriesMaps =
        await db.query('category');

    return categoriesMaps.map((categoryMap) {
      return Category(
        id: categoryMap['id'] as int,
        name: categoryMap['name'] as String,
        description: categoryMap['description'] as String,
      );
    }).toList();
  }

  Future<int> addCategory(Category category) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'category',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<void> updateCategory(Category category) async {
    final db = await initDB();
    await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<List<Unite>> getUnite() async {
    final db = await initDB();
    final List<Map<String, Object?>> uniteMaps = await db.query('unite');

    return uniteMaps.map((uniteMaps) {
      return Unite(
        id: uniteMaps['id'] as int,
        nom: uniteMaps['nom'] as String,
      );
    }).toList();
  }

  Future<List<Fournisseur>> getFournisseur() async {
    final db = await initDB();
    final List<Map<String, Object?>> fournisseurMaps =
        await db.query('fournisseur');

    return fournisseurMaps.map((fournisseurMaps) {
      return Fournisseur(
        id: fournisseurMaps['id'] as int,
        nomFournisseur: fournisseurMaps['nomFournisseur'] as String,
        addresseFournisseur: fournisseurMaps['addresseFournisseur'] as String,
        nif: fournisseurMaps['nif'] as String,
        stat: fournisseurMaps['stat'] as String,
        contact: fournisseurMaps['contact'] as String,
        dateCreation: fournisseurMaps['dateCreation'] as String,
      );
    }).toList();
  }

  Future<int> addProduct(Product produit) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> categorieExistante = await db.query(
      'category',
      where: 'id = ?',
      whereArgs: [produit.categoryId],
    );

    if (categorieExistante.isEmpty) {
      return -1;
    }
    return await db.insert(
      'product',
      produit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct(Product product) async {
    final db = await initDB();
    await db.update(
      'product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> ajoutFournisseur(Fournisseur fournisseur) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'fournisseur',
        fournisseur.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<void> updateFournisseur(Fournisseur fournisseur) async {
    final db = await initDB();
    await db.update(
      'fournisseur',
      fournisseur.toMap(),
      where: 'id = ?',
      whereArgs: [fournisseur.id],
    );
  }

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

  Future<int> deleteCategorie(int id) async {
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

  Future<void> logOut() async {
    final Database db = await initDB();
    await db.delete('session');
  }

  // Future<List<Produits>> getProduits() async {
  //   final db = await initDB();
  //   final List<Map<String, Object?>> productsMaps = await db.query('produits');

  //   return productsMaps.map((productMap) {
  //     return Produits(
  //       id: productMap['id'] as int,
  //       nom: productMap['nom'] as String,
  //       prixUnitaire: productMap['prixUnitaire'] as double,
  //       quantiter: productMap['quantiter'] as int,
  //       description: productMap['description'] as String,
  //     );
  //   }).toList();
  // }

  // Future<int> ajoutProduit(Produits produit) async {
  //   try {
  //     final Database db = await initDB();
  //     return await db.insert(
  //       'produits',
  //       produit.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   } catch (e) {
  //     return -1;
  //   }
  // }
}
