class Busyness {
  final String busyness;
  Busyness({
    required this.busyness,
  });

  factory Busyness.fromJson(Map<String, dynamic> json) {
    return Busyness(
      busyness: json['busyness'],
    );
  }
}
