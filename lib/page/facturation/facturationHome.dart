import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class Facturationhome extends StatefulWidget {
  const Facturationhome({super.key});

  @override
  State<Facturationhome> createState() => _FacturationhomeState();
}

class _FacturationhomeState extends State<Facturationhome> {
  final clientNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> generatePDF() async {
    if (formKey.currentState?.validate() ?? false) {
      final clientName = clientNameController.text;
      final description = itemDescriptionController.text;
      final quantity = int.tryParse(quantityController.text) ?? 0;
      final price = double.tryParse(priceController.text) ?? 0.0;
      final total = quantity * price;

      final dateFormatter = DateFormat('dd/MM/yyyy');
      final currentDate = dateFormatter.format(DateTime.now());

      final pdf = pw.Document();

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Facture',
                    style: pw.TextStyle(
                        fontSize: 30, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Date: $currentDate',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Lieu: Antananarivo, Madagascar',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Cher(e) $clientName,',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Nous vous remercions pour votre achat.',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Description',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Quantité',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Prix Unitaire',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(description),
                      pw.Text('$quantity'),
                      pw.Text('${price.toStringAsFixed(2)}\ ar'),
                      pw.Text('${total.toStringAsFixed(2)}\ ar'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total à Payer: ${total.toStringAsFixed(2)}\ ar',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Merci pour votre achat. Nous espérons vous revoir bientôt.',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Pour toute question, contactez-nous à support@exemple.com',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          );
        },
      ));

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    }
  }

  @override
  void dispose() {
    clientNameController.dispose();
    itemDescriptionController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Générer une Facture en PDF"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Détails de la facture",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Nom du client
                TextFormField(
                  controller: clientNameController,
                  decoration: const InputDecoration(
                    labelText: "Nom du client",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom du client';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description de l'article
                TextFormField(
                  controller: itemDescriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description de l'article",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la description de l\'article';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Quantité
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantité",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la quantité';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Veuillez entrer un nombre valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Prix unitaire
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Prix unitaire",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le prix';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Veuillez entrer un prix valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: generatePDF,
                  child: const Text("Générer la facture en PDF"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
