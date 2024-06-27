class LevantamentoModel {
  List<int>? equipamentosLevantados;
  int? idUnidadeAdministrativa;
  int? idUsuario;
  String? dataLevantamento;

  LevantamentoModel({
    this.equipamentosLevantados,
    this.idUnidadeAdministrativa,
    this.idUsuario,
    this.dataLevantamento,
  });

  LevantamentoModel.fromJson(Map<String, dynamic> json) {
    if (json['equipamentosLevantados'] != null) {
      equipamentosLevantados = <int>[];
      json['equipamentosLevantados'].forEach((v) {
        equipamentosLevantados!.add(v);
      });
    }
    idUnidadeAdministrativa = json['idUnidadeAdministrativa'];
    idUsuario = json['idUsuario'];
    dataLevantamento = json['dataLevantamento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (equipamentosLevantados != null) {
      data['equipamentosLevantados'] = equipamentosLevantados;
    }
    data['idUnidadeAdministrativa'] = idUnidadeAdministrativa;
    data['idUsuario'] = idUsuario;
    data['dataLevantamento'] = dataLevantamento;
    return data;
  }
}
