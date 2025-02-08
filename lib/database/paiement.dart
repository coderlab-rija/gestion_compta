class PaiementMode {
  final int? id;
  String mode;
  String code;
  String operateur;
  String numero;

  PaiementMode({
    this.id,
    required this.mode,
    required this.code,
    required this.operateur,
    required this.numero,
  });

  factory PaiementMode.fromMap(Map<String, dynamic> json) => PaiementMode(
        id: json["id"],
        mode: json["mode"],
        code: json["code"],
        operateur: json["operateur"],
        numero: json["numero"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "mode": mode,
        "code": code,
        "operateur": operateur,
        "numero": numero,
      };
}
