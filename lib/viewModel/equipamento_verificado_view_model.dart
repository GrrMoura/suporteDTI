class EquipamentoVerificadoViewmodel {
  String? descricao;
  int? idUnidadeAdministrativa;
  int? idEquipamento;
  List<Equipamento> equipamentosLevantados;

  EquipamentoVerificadoViewmodel({
    this.descricao,
    this.idUnidadeAdministrativa,
    this.idEquipamento,
  });

  EquipamentoVerificadoViewmodel.fromJson(Map<String, dynamic> json) {
    descricao = json['descricao'];
    idUnidadeAdministrativa = json['idUnidadeAdministrativa'];
    idEquipamento = json['idEquipamento'];
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'idUnidadeAdministrativa': idUnidadeAdministrativa,
      'idEquipamento': idEquipamento,
    };
  }
}
