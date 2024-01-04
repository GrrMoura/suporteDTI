class EquipamentosHistoricoModel {
  final int? id;
  final String? tipo;
  final String? patrimonio;
  final String? marca;
  final String? tag;
  final String? lotacao;

  EquipamentosHistoricoModel(
      {this.id,
      this.tipo,
      this.patrimonio,
      this.marca,
      this.tag,
      this.lotacao});

  EquipamentosHistoricoModel.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        tipo = item["tipo"],
        patrimonio = item["patrimonio"],
        marca = item["marca"],
        tag = item["tag"],
        lotacao = item["lotacao"];

  Map<String, Object> toMap() {
    return {
      'id': id!,
      'tipo': tipo!,
      'patrimonio': patrimonio!,
      'marca': marca!,
      'tag': tag!,
      'lotacao': lotacao!
    };
  }
}
