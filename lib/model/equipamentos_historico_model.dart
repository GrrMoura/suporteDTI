class EquipamentosHistoricoModel {
  final int id;
  final String tipo;
  final String patrimonio;
  final String marca;
  final String tag;

  EquipamentosHistoricoModel({
    required this.id,
    required this.tipo,
    required this.patrimonio,
    required this.marca,
    required this.tag,
  });

  EquipamentosHistoricoModel.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        tipo = item["tipo"],
        patrimonio = item["patrimonio"],
        marca = item["marca"],
        tag = item["tag"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'tipo': patrimonio,
      'patriomonio': patrimonio,
      'marca': marca,
      'tag': tag
    };
  }
}
