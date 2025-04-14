import 'package:flutter/material.dart';
import 'package:my_apk/database/client.dart';
import 'package:my_apk/database/produits.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/function/utility.dart';
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
  final articleNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final dbHelper = DataBaseHelper();
  final utility = Utility();
  var referenceController = TextEditingController();
  var dateController = TextEditingController();

  String? selectedFilePath;

  List<Product> _articles = [];
  List<Client> _clients = [];
  Product? selectedArticle;
  Client? _selectedClient;

  double totalHT = 0;
  double tva = 0;
  double montantTVA = 0;
  double totalTTC = 0;

  @override
  void initState() {
    super.initState();
    _loadArticle();
    _loadClients();
    final dateFormatter = DateFormat('yyyy-MM-dd');
    dateController.text = dateFormatter.format(DateTime.now());

    priceController.addListener(updateTotal);
    quantityController.addListener(updateTotal);
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    referenceController = TextEditingController(text: "FAC_$todayDate-001");
    dateController = TextEditingController(text: todayDate);
  }

  Future<void> _loadClients() async {
    final clients = await dbHelper.getClient();
    setState(() {
      _clients = clients;
      if (_clients.isNotEmpty) {
        _selectedClient = _clients.first;
      }
    });
  }

  Future<void> _loadArticle() async {
    final articles = await dbHelper.getProductUnity();
    setState(() {
      _articles = articles;
      if (_clients.isNotEmpty) {
        _selectedClient = _clients.first;
      }
    });
  }

  Future<void> generatePDF() async {
    if (formKey.currentState?.validate() ?? false) {
      final clientName =
          _selectedClient?.clientName ?? 'Client non selectionner';
      final clientSurname =
          _selectedClient?.clientSurname ?? 'Client non selectionner';
      final description = selectedArticle?.description;
      final quantity = int.tryParse(quantityController.text) ?? 0;
      final price = double.tryParse(priceController.text) ?? 0.0;
      final total = quantity * price;
      final clientAddress =
          _selectedClient?.clientAdress ?? 'Adresse non fournie';

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
                  pw.Column(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.end, // Alignement à droite
                    children: [
                      pw.Text(
                        'Antananarivo, Madagascar',
                        style: const pw.TextStyle(
                            fontSize: 12, color: PdfColors.grey),
                      ),
                      pw.Text(
                        'Le: $currentDate',
                        style: const pw.TextStyle(
                            fontSize: 12, color: PdfColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Nom du client: $clientName $clientSurname',
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
              ),
              pw.Text(
                'Adresse du client: $clientAddress',
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Cher(e), $clientName $clientSurname,',
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
                      pw.Text('$description'),
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

  void _addClient() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController surnameController = TextEditingController();
        final TextEditingController addressController = TextEditingController();
        final TextEditingController nifController = TextEditingController();
        final TextEditingController statController = TextEditingController();
        final TextEditingController contactController = TextEditingController();
        final TextEditingController emailController = TextEditingController();
        final TextEditingController codeClientController =
            TextEditingController();
        bool isPro = false;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Ajouter un client"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isPro,
                          onChanged: (bool? newValue) {
                            setStateDialog(() {
                              isPro = newValue ?? false;
                            });
                          },
                        ),
                        const Text("Client professionnel ?"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<String>(
                      future: utility.generateClientCode(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          codeClientController.text = snapshot.data!;
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Nom",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: surnameController,
                      decoration: const InputDecoration(
                        labelText: "Prénom",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: "Adresse",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Adresse email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contactController,
                      decoration: const InputDecoration(
                        labelText: "Contact",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isPro) ...[
                      TextField(
                        controller: nifController,
                        decoration: const InputDecoration(
                          labelText: "NIF",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: statController,
                        decoration: const InputDecoration(
                          labelText: "STAT",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Annuler"),
                ),
                TextButton(
                  onPressed: () async {
                    if (isPro &&
                        (nifController.text.isEmpty ||
                            statController.text.isEmpty)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Erreur"),
                            content: const Text(
                                "Le NIF et le STAT sont obligatoires pour un client professionnel."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Fermer"),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    final dbHelper = DataBaseHelper();
                    final db = await dbHelper.initDB();
                    await db.insert('client', {
                      'clientName': nameController.text,
                      'clientSurname': surnameController.text,
                      'clientAdress': addressController.text,
                      'nif': isPro ? nifController.text : "",
                      'stat': isPro ? statController.text : "",
                      'contact': contactController.text,
                      'mailAdress': emailController.text,
                      'pro': isPro ? 1 : 0,
                      'codeClient': codeClientController.text,
                      'filePath': selectedFilePath,
                    });
                    _loadClients();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ajouter"),
                ),
              ],
            );
          },
        );
      },
    );
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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Client>(
                        value: _selectedClient,
                        onChanged: (Client? newValue) {
                          setState(() {
                            _selectedClient = newValue;
                            clientNameController.text =
                                newValue?.clientName ?? '';
                          });
                        },
                        items: _clients
                            .map<DropdownMenuItem<Client>>((Client client) {
                          return DropdownMenuItem<Client>(
                            value: client,
                            child: Text(
                                '${client.clientName} ${client.clientSurname}'),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: "Sélectionner un Client",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        _addClient();
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Ajouter',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

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
                    controller: referenceController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.receipt),
                      border: InputBorder.none,
                      labelText: "Référence",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                    controller: dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          dateController.text =
                              "${selectedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.date_range),
                      border: InputBorder.none,
                      labelText: "Date de Facturation",
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Product>(
                        value: selectedArticle,
                        onChanged: (Product? newValue) {
                          setState(() {
                            selectedArticle = newValue;
                            articleNameController.text = newValue?.name ?? '';
                          });
                        },
                        items: _articles
                            .map<DropdownMenuItem<Product>>((Product article) {
                          print(
                              "Article: ${article.name}, Unit: ${article.unityName}");
                          return DropdownMenuItem<Product>(
                            value: article,
                            child: Text(article.name),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: "Sélectionner un Article",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        _addClient();
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Ajouter',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (selectedArticle != null)
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
                      readOnly: true,
                      controller: TextEditingController(
                          text: selectedArticle?.description),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.description),
                        border: InputBorder.none,
                        labelText: "Désignation",
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Quantité
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
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
                    ),

                    // Champ Unité
                    if (selectedArticle != null)
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.deepPurple.withOpacity(.1),
                          ),
                          height: 60,
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: selectedArticle?.unityName ?? ""),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Unité",
                            ),
                          ),
                        ),
                      ),
                  ],
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

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Total HT: ${totalHT.toStringAsFixed(2)} Ar"),
                        const SizedBox(height: 8),
                        const Text("TVA : ${'Non assujetti sin non 20%'}"),
                        const SizedBox(height: 8),
                        Text(
                            "Montant TVA : ${montantTVA.toStringAsFixed(2)} Ar"),
                        const SizedBox(height: 8),
                        Text("Total TTC : ${totalTTC.toStringAsFixed(2)} Ar"),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: ElevatedButton(
                    onPressed: generatePDF,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Générer la Facture'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateTotal() {
    double price = double.tryParse(priceController.text) ?? 0;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    totalHT = price * quantity;
    if (selectedArticle != null) {
      tva = 20;
    } else {
      tva = 0;
    }

    montantTVA = totalHT * tva / 100;
    totalTTC = totalHT + montantTVA;

    setState(() {});
  }
}
