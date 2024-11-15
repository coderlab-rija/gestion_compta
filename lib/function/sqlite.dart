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
    final path = join(databasePath, 'gestionComptable.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE utilisateur (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, lastname TEXT, email TEXT UNIQUE, password TEXT)',
        );

        await db.execute(
          'CREATE TABLE produits (id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT NOT NULL, quantiter INTEGER NOT NULL, prixUnitaire REAL NOT NULL, description TEXT, categorieId INTEGER, unite TEXT NOT NULL, FOREIGN KEY(categorieId) REFERENCES categorie(id))',
        );

        await db.execute(
          'CREATE TABLE categorie (id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT NOT NULL, description TEXT)',
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

  Future<List<Categorie>> getCategorie() async {
    final db = await initDB();
    final List<Map<String, Object?>> categoriesMaps =
        await db.query('categorie');

    return categoriesMaps.map((categoryMap) {
      return Categorie(
        id: categoryMap['id'] as int,
        nom: categoryMap['nom'] as String,
        description: categoryMap['description'] as String,
      );
    }).toList();
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

  Future<int> ajoutProduit(Produits produit) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> categorieExistante = await db.query(
      'categorie',
      where: 'id = ?',
      whereArgs: [produit.categorieId],
    );

    if (categorieExistante.isEmpty) {
      return -1;
    }
    return await db.insert(
      'produits',
      produit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> ajoutCategorie(Categorie categorie) async {
    try {
      final Database db = await initDB();
      return await db.insert(
        'categorie',
        categorie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
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

  Future<void> updateProfil(Utilisateur utilisateur) async {
    final db = await initDB();
    await db.update(
      'utilisateur',
      utilisateur.toMap(),
      where: 'id = ?',
      whereArgs: [utilisateur.id],
    );
  }

  Future<void> updateProduit(Produits produits) async {
    final db = await initDB();
    await db.update(
      'produits',
      produits.toMap(),
      where: 'id = ?',
      whereArgs: [produits.id],
    );
  }

  Future<void> updateCategorie(Categorie categorie) async {
    final db = await initDB();
    await db.update(
      'categorie',
      categorie.toMap(),
      where: 'id = ?',
      whereArgs: [categorie.id],
    );
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

  Future<int> deleteProduit(int id) async {
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

  Future<void> deconnexion() async {
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
