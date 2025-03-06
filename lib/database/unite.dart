class Unite {
  final int? id;
  String name;
  String unite;

  Unite({
    this.id,
    required this.name,
    required this.unite,
  });

  factory Unite.fromMap(Map<String, dynamic> json) => Unite(
        id: json["id"],
        name: json["name"],
        unite: json["unite"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "unite": unite,
      };
}
