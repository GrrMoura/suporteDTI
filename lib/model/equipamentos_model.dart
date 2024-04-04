class EquipamentosModel {
  final int idEquipamento;
  final int idFabricante;
  final int idTipoEquipamento;
  final int idModelo;
  final int idUnidade;
  final String numeroSerie;
  final String patrimonioSsp;
  final String patrimonioSead;
  final String lotacao;
  final String setor;
  final String descricao;

  EquipamentosModel(
      {required this.descricao,
      required this.idUnidade,
      required this.idEquipamento,
      required this.idFabricante,
      required this.idModelo,
      required this.patrimonioSsp,
      required this.patrimonioSead,
      required this.idTipoEquipamento,
      required this.numeroSerie,
      required this.lotacao,
      required this.setor});

  factory EquipamentosModel.fromJson(Map<String, dynamic> json) =>
      EquipamentosModel(
          patrimonioSsp: json['patrimonioSsp'],
          idModelo: json['idModelo'],
          idTipoEquipamento: json['idTipoEquipamento'],
          numeroSerie: json['numeroSerie'],
          lotacao: json['lotacao'],
          setor: json['setor'],
          descricao: json['descricao'],
          idUnidade: json['IdUnidade'],
          idEquipamento: json['idEquipamento'],
          idFabricante: json['idFabricante'],
          patrimonioSead: json['patrimonioSead']);

  Map<String, dynamic> toJson() => {
        'patrimonioSsp': patrimonioSsp,
        'idModelo': idModelo,
        'idTipoEquipamento': idTipoEquipamento,
        'numeroSerie': numeroSerie,
        "lotacao": lotacao,
        "setor": setor,
        "descricao": descricao,
        "idUnidade": idUnidade,
        "idEquipamento": idEquipamento,
        "idFabricante": idFabricante,
        "patrimonioSead": patrimonioSead,
      };
}
