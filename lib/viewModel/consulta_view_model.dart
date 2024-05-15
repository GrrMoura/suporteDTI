class ConsultaEquipamentoViewModel {
  int? idTipoEquipamento;
  String? numeroSerie;
  String? patrimonioSead;
  String? patrimonioSSP;
  String? descricao;
  Null idFabricante;
  Null idModelo;
  Paginacao? paginacao;
  bool? ocupado = false;

  ConsultaEquipamentoViewModel(
      {this.idTipoEquipamento,
      this.numeroSerie,
      this.patrimonioSead,
      this.idFabricante,
      this.idModelo,
      this.paginacao,
      this.descricao,
      this.patrimonioSSP,
      this.ocupado});

  ConsultaEquipamentoViewModel.fromJson(Map<String, dynamic> json) {
    idTipoEquipamento = json['idTipoEquipamento'];
    numeroSerie = json['numeroSerie'];
    patrimonioSead = json['patrimonioSead'];
    patrimonioSSP = json['patrimonioSsp'];
    idFabricante = json['idFabricante'];
    idModelo = json['idModelo'];
    paginacao = json['paginacao'] != null
        ? Paginacao.fromJson(json['paginacao'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTipoEquipamento'] = idTipoEquipamento;
    data['numeroSerie'] = numeroSerie;
    data['patrimonioSead'] = patrimonioSead;
    data['patrimonioSsp'] = patrimonioSSP;
    data['idFabricante'] = idFabricante;
    data['idModelo'] = idModelo;
    if (paginacao != null) {
      data['paginacao'] = paginacao!.toJson();
    }
    return data;
  }
}

class Paginacao {
  int? limite;
  int? pagina;
  int? totalPaginas;
  int? registros;

  Paginacao({this.limite, this.pagina, this.totalPaginas, this.registros});

  Paginacao.fromJson(Map<String, dynamic> json) {
    limite = json['limite'];
    pagina = json['pagina'];
    totalPaginas = json['totalPaginas'];
    registros = json['registros'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limite'] = limite;
    data['pagina'] = pagina;
    data['totalPaginas'] = totalPaginas;
    data['registros'] = registros;
    return data;
  }
}
