import 'package:flutter/material.dart';
import 'package:my_apk/database/client.dart';
import 'package:my_apk/function/sqlite.dart';
import 'package:my_apk/page/client/editClient.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  late Future<List<Client>> _clientFuture;
  bool? isProFilter;

  @override
  void initState() {
    super.initState();
    _clientFuture = getClient();
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

  void _addClient() {
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
                    TextField(
                      controller: codeClientController,
                      decoration: const InputDecoration(
                        labelText: "Code client",
                        border: OutlineInputBorder(),
                      ),
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
                    TextField(
                      controller: contactController,
                      decoration: const InputDecoration(
                        labelText: "Contact",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        const Text("Client professionnel?"),
                      ],
                    ),
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
                      'nif': nifController.text,
                      'stat': statController.text,
                      'contact': contactController.text,
                      'mailAdress': emailController.text,
                      'pro': isPro ? 1 : 0,
                      'codeClient': codeClientController.text,
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
                        client.pro
                            ? const Icon(Icons.business, color: Colors.blue)
                            : const Icon(Icons.person, color: Colors.grey),
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
                              print("Erreur de navigation: $e");
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
