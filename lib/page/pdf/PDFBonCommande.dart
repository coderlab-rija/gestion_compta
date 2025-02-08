import 'package:my_apk/database/achatFournisseur.dart';
import 'package:printing/printing.dart';
import 'package:my_apk/page/pdf/PDFTemplateBonCommande.dart';

class PdfGenerator {
  static Future<void> generateAndPrintPdf(
      List<AchatFournisseur> commandes) async {
    final pdf = PdfTemplateBonCommande.generate(commandes);

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }
}
