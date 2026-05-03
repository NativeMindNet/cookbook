/// Organoleptic mouthfeel tags (`ref_mouthfeel`).
class RefMouthfeel {
  const RefMouthfeel({
    required this.id,
    required this.nameRu,
    required this.sortOrder,
  });

  final String id;
  final String nameRu;
  final int sortOrder;

  factory RefMouthfeel.fromMap(Map<String, dynamic> m) {
    return RefMouthfeel(
      id: m['id'] as String,
      nameRu: m['name_ru'] as String,
      sortOrder: (m['sort_order'] as num).toInt(),
    );
  }
}
