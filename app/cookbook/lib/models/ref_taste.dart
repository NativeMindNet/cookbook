/// Ayurvedic shad rasa + app-only taste tags (`ref_taste`).
class RefTaste {
  const RefTaste({
    required this.id,
    required this.kind,
    this.sanskrit,
    required this.nameRu,
    required this.sortOrder,
  });

  final String id;
  final String kind;
  final String? sanskrit;
  final String nameRu;
  final int sortOrder;

  factory RefTaste.fromMap(Map<String, dynamic> m) {
    return RefTaste(
      id: m['id'] as String,
      kind: m['kind'] as String,
      sanskrit: m['sanskrit'] as String?,
      nameRu: m['name_ru'] as String,
      sortOrder: (m['sort_order'] as num).toInt(),
    );
  }
}
