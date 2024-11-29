import 'package:flutter/material.dart';
import 'package:my_apk/page/dashboard/dashboard.dart';
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
                        fontSize: 30,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue),
                  ),
                  pw.Text(
                    'Date: $currentDate',
                    style:
                        const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Lieu: Antananarivo, Madagascar',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.black),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Cher(e) $clientName,',
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
              ),
              pw.Text(
                'Nous vous remercions pour votre achat.',
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Description',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue)),
                      pw.Text('Quantité',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue)),
                      pw.Text('Prix Unitaire',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue)),
                      pw.Text('Total',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue)),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(description),
                      pw.Text('$quantity'),
                      pw.Text('${price.toStringAsFixed(2)} ar'),
                      pw.Text('${total.toStringAsFixed(2)} ar'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total à Payer: ${total.toStringAsFixed(2)} ar',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                        color: PdfColors.red),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Merci pour votre achat. Nous espérons vous revoir bientôt.',
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Pour toute question, contactez-nous',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.blue),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            ),
            ListTile(
              title: const Text('Facturation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Facturationhome()),
                );
              },
            ),
            ListTile(
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom du client
                Container(
                  margin: const EdgeInsets.all(4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.1),
                  ),
                  height: 60,
                  child: TextFormField(
                    controller: clientNameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: "Nom du Client",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nom du client';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Description de l'article
                Container(
                  margin: const EdgeInsets.all(4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.1),
                  ),
                  height: 60,
                  child: TextFormField(
                    controller: itemDescriptionController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.description),
                      border: InputBorder.none,
                      hintText: "Description de l'Article",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Quantité
                Container(
                  margin: const EdgeInsets.all(4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.1),
                  ),
                  height: 60,
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.plus_one),
                      border: InputBorder.none,
                      hintText: "Quantité",
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
                ),
                const SizedBox(height: 16),

                // Prix unitaire
                Container(
                  margin: const EdgeInsets.all(4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.deepPurple.withOpacity(.1),
                  ),
                  height: 60,
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.monetization_on),
                      border: InputBorder.none,
                      hintText: "Prix Unitaire",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un prix';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Veuillez entrer un prix valide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    onPressed: generatePDF,
                    child: const Text('Générer la Facture'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
