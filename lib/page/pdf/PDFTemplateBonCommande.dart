import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:my_apk/database/achatFournisseur.dart';

class PdfTemplateBonCommande {
  static pw.Document generate(List<AchatFournisseur> commandes) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Bon de Commande",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "Date: ${DateTime.now().toString().split(' ')[0]}",
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          pw.Table.fromTextArray(
            headers: [
              'Produit',
              'Fournisseur',
              'Catégorie',
              'Référence',
              'Quantité',
              'Prix Achat (Ar)',
              'Prix Total (Ar)',
              'Statut',
            ],
            data: commandes.map((commande) {
              return [
                commande.productName,
                commande.fournisseurName,
                commande.categoryName,
                commande.reference,
                commande.quantity.toString(),
                commande.prixAchat.toStringAsFixed(2),
                (commande.prixAchat * commande.quantity).toStringAsFixed(2),
                commande.status,
              ];
            }).toList(),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.teal,
            ),
            cellHeight: 25,
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1),
              5: const pw.FlexColumnWidth(2),
              6: const pw.FlexColumnWidth(2),
              7: const pw.FlexColumnWidth(1.5),
            },
            border: pw.TableBorder.all(
              color: PdfColors.grey,
              width: 0.5,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Généré automatiquement par l'application MyAPK.",
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
        ],
      ),
    );

    return pdf;
  }
}
