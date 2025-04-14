import 'dart:async';
import 'dart:math';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/function/sqlite.dart';

class Utility {
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
        id: produitMap['id'] as int,
        name: produitMap['name'] as String,
        description: produitMap['description'] as String,
        categoryId: produitMap['categoryId'] as int,
        unityId: produitMap['unityId'] as int,
      );
    }).toList();
  }
}
