import 'package:my_apk/database/achatFournisseur.dart';
import 'package:my_apk/function/utility.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFBonReception {
  Future<void> generatePdf(List<AchatFournisseur> produits) async {
    Utility utility = Utility();
    final pdf = pw.Document();
    final total = produits.fold(
        0.0, (sum, produit) => sum + produit.prixAchat * produit.quantity);

    final totalEnLettre = utility.convertirNombreEnLettre(total);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Bon de Reception",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Fournisseur : ${produits[0].fournisseurName}"),
              pw.Text("Référence : ${produits[0].reference}"),
              pw.Text("Date : ${produits[0].dateCommande}"),
              pw.Text("Statut : ${produits[0].status}"),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text("Produit",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Quantité",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Prix Unitaire",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Total",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  ...produits.map(
                    (produit) => pw.TableRow(
                      children: [
                        pw.Text(produit.productName),
                        pw.Text(produit.quantity.toString()),
                        pw.Text("${produit.prixAchat} Ar"),
                        pw.Text(
                            "${(produit.prixAchat * produit.quantity).toStringAsFixed(2)} Ar"),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "Somme totale: ${produits.fold(0.0, (sum, produit) => sum + produit.prixAchat * produit.quantity).toStringAsFixed(2)} Ar",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                "Somme totale de $totalEnLettre Ariary",
                style: const pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Merci pour votre commande!",
                style:
                    pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
