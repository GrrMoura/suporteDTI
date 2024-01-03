class EquipamentosModel {
  final int patrimonio;
  final String equipamento;
  final String marcaModelo;
  final String snServiceTag;
  final String qrCode;
  final String lotacao;
  final String setor;

  EquipamentosModel(
      {required this.patrimonio,
      required this.equipamento,
      required this.marcaModelo,
      required this.snServiceTag,
      required this.qrCode,
      required this.lotacao,
      required this.setor});

  factory EquipamentosModel.fromJson(Map<String, dynamic> json) =>
      EquipamentosModel(
          patrimonio: json['patrimonio'],
          equipamento: json['equipamento'],
          marcaModelo: json['marcaModelo'],
          snServiceTag: json['snServiceTag'],
          qrCode: json['qrCode'],
          lotacao: json['lotacao'],
          setor: json['setor']);

  Map<String, dynamic> toJson() => {
        'patrimonio': patrimonio,
        'marcaModelo': marcaModelo,
        'equipamento': equipamento,
        'snServiceTag': snServiceTag,
        "qrCode": qrCode,
        "lotacao": lotacao,
        "setor": setor
      };
}
