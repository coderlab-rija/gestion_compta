class Utilisateur {
  final int? id;
  String username;
  String lastname;
  String email;
  String password;

  Utilisateur({
    this.id,
    required this.username,
    required this.lastname,
    required this.email,
    required this.password,
  });

  factory Utilisateur.fromMap(Map<String, dynamic> json) => Utilisateur(
        id: json["id"],
        username: json["username"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "lastname": lastname,
        "email": email,
        "password": password,
      };
}
