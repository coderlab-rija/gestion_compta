class Utilisateurs {
  final int? id;
  final String name;
  final String surname;
  final String email;
  final String telephone;
  final String droit;
  final String password;

  Utilisateurs({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.telephone,
    required this.droit,
    required this.password,
  });

  factory Utilisateurs.fromMap(Map<String, dynamic> json) => Utilisateurs(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        email: json["email"],
        telephone: json["telephone"],
        droit: json["droit"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "surname": surname,
        "email": email,
        "telephone": telephone,
        "droit": droit,
        "password": password,
      };
}
