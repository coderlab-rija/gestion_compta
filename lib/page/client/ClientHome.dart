import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_apk/database/client.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/client/editClient.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  late Future<List<Client>> _clientFuture;
  bool? isProFilter;
  String? selectedFilePath;

  @override
  void initState() {
    super.initState();
    _clientFuture = getClient();
  }

  Future<String> _generateClientCode() async {
    DataBaseHelper dbHelper = DataBaseHelper();
    String clientCode = await dbHelper.generateClientCode();
    return clientCode;
  }

  Future<List<Client>> getClient() async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    final List<Map<String, Object?>> clientMaps;

    if (isProFilter != null) {
      clientMaps = await db.query(
        'client',
        where: 'pro = ?',
        whereArgs: [isProFilter == true ? 1 : 0],
      );
    } else {
      clientMaps = await db.query('client');
    }

    return clientMaps.map((clientMap) {
      return Client(
        id: clientMap['id'] as int,
        clientName: clientMap['clientName'] as String,
        clientSurname: clientMap['clientSurname'] as String,
        clientAdress: clientMap['clientAdress'] as String,
        mailAdress: clientMap['mailAdress'] as String,
        nif: clientMap['nif'] as String,
        stat: clientMap['stat'] as String,
        contact: clientMap['contact'] as String,
        pro: (clientMap['pro'] as int) == 1,
        codeClient: clientMap['codeClient'] as String,
        filePath: clientMap['filePath'] as String?,
      );
    }).toList();
  }

  void _showProFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Filtrer par type de client"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Tous les clients"),
                onTap: () {
                  setState(() {
                    isProFilter = null;
                    _clientFuture = getClient();
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Clients professionnels"),
                onTap: () {
                  setState(() {
                    isProFilter = true;
                    _clientFuture = getClient();
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Clients non professionnels"),
                onTap: () {
                  setState(() {
                    isProFilter = false;
                    _clientFuture = getClient();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        selectedFilePath = file.path;
      });
      if (kDebugMode) {
        print("Fichier sélectionné : ${file.path}");
      }
    } else {
      if (kDebugMode) {
        print("Aucun fichier sélectionné.");
      }
    }
  }

  Future<void> updateClientFilePath(int clientId, String filePath) async {
    final dbHelper = DataBaseHelper();
    final db = await dbHelper.initDB();
    await db.update(
      'client',
      {'filePath': filePath},
      where: 'id = ?',
      whereArgs: [clientId],
    );
  }

  void requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      if (kDebugMode) {
        print("L'accès au stockage est accordé.");
      }
    } else {
      if (kDebugMode) {
        print("L'accès au stockage a été refusé.");
      }
    }
  }

  void _openDocument(String filePath) async {
    if (filePath.endsWith(".pdf")) {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        if (kDebugMode) {
          print("Échec de l'ouverture du fichier : ${result.message}");
        }
      } else {
        if (kDebugMode) {
          print("Fichier ouvert avec succès.");
        }
      }
    } else {
      if (kDebugMode) {
        print("Type de fichier non supporté pour l'ouverture.");
      }
    }
  }

  void _addClient() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController surnameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController nifController = TextEditingController();
    final TextEditingController statController = TextEditingController();
    final TextEditingController contactController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController codeClientController = TextEditingController();
    bool isPro = false;
    final generatedCode = await _generateClientCode();
    codeClientController.text = generatedCode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
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

                    setState(() {
                      _clientFuture = getClient();
                    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Client>>(
        future: _clientFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun client trouvé"));
          } else {
            final clients = snapshot.data!;
            if (kDebugMode) {
              print("Liste des clients :");
            }
            for (var client in clients) {
              if (kDebugMode) {
                print(
                    "${client.clientName} ${client.clientSurname} - ${client.mailAdress} - ${client.filePath}");
              }
            }
            return ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      "${client.clientName} ${client.clientSurname}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${client.mailAdress}"),
                        Text("Contact: ${client.contact}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*client.pro
                            ? const Icon(Icons.business, color: Colors.blue)
                            : const Icon(Icons.person, color: Colors.grey),*/
                        if (client.filePath != null &&
                            client.filePath!.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.visibility,
                                color: Colors.green),
                            onPressed: () {
                              if (client.filePath != null &&
                                  client.filePath!.isNotEmpty) {
                                _openDocument(client.filePath!);
                              } else {
                                if (kDebugMode) {
                                  print("Aucun fichier trouvé pour ce client.");
                                }
                              }
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color.fromARGB(255, 248, 134, 248)),
                          onPressed: () {
                            try {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Editclient(client: client),
                                ),
                              ).then((shouldUpdate) {
                                if (shouldUpdate == true) {
                                  setState(() {
                                    _clientFuture = getClient();
                                  });
                                }
                              });
                            } catch (e) {
                              if (kDebugMode) {
                                print("Erreur de navigation: $e");
                              }
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.upload_file,
                              color: Colors.green),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();

                            if (result != null) {
                              String filePath = result.files.single.path!;
                              updateClientFilePath(client.id!, filePath);
                              if (kDebugMode) {
                                print("Fichier sélectionné : $filePath");
                              }
                            } else {
                              if (kDebugMode) {
                                print("Aucun fichier sélectionné.");
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _showDetails(context, client);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 5,
            child: FloatingActionButton(
              onPressed: _addClient,
              child: const Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 5,
            child: FloatingActionButton(
              onPressed: _showProFilterDialog,
              child: const Icon(Icons.filter_alt),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, Client client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${client.clientName} ${client.clientSurname}"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Adresse: ${client.clientAdress}"),
              Text("Email: ${client.mailAdress}"),
              Text("NIF: ${client.nif}"),
              Text("Statut: ${client.stat}"),
              Text("Contact: ${client.contact}"),
              Text("Code client: ${client.codeClient}"),
              Text(client.pro
                  ? "Client professionnel"
                  : "Client non professionnel"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }
}
