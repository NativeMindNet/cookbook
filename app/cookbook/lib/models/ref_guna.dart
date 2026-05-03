/// Dashavidha guna poles for food / ingredient tagging (`ref_guna`).
class RefGuna {
  const RefGuna({
    required this.id,
    required this.pairCode,
    required this.pole,
    required this.sanskrit,
    required this.nameRu,
    required this.sortOrder,
  });

  final String id;
  final String pairCode;
  final String pole;
  final String sanskrit;
  final String nameRu;
  final int sortOrder;

  factory RefGuna.fromMap(Map<String, dynamic> m) {
    return RefGuna(
      id: m['id'] as String,
      pairCode: m['pair_code'] as String,
      pole: m['pole'] as String,
      sanskrit: m['sanskrit'] as String,
      nameRu: m['name_ru'] as String,
      sortOrder: (m['sort_order'] as num).toInt(),
    );
  }
}
