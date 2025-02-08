class Unite {
  final int? id;
  String name;

  Unite({
    this.id,
    required this.name,
  });

  factory Unite.fromMap(Map<String, dynamic> json) => Unite(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
