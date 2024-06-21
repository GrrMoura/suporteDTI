class EquipamentoModel {
  int? idEquipamento;
  int? idFabricante;
  int? idModelo;
  int? idTipoEquipamento;
  String? modelo;
  String? tipoEquipamento;
  String? dataCompra;

  String? numeroNotafiscal;
  String? numeroSerie;
  String? numeroSerieSo;
  String? enderecoIp;
  String? patrimonioSead;
  String? patrimonioSsp;
  String? descricaoSo;
  String? fabricante;
  List<Alocacoes>? alocacoes;
  String? notaFiscal;
  int? idTipoAquisicao;
  String? tipoAquisicao;
  int? idUnidadedeAdministrativaDestino;
  String? unidadeAtual;
  String? descricaoUnidadeDestino;
  String? descricao;
  String? numeroRegistro;
  String? numeroLacre;

  EquipamentoModel(
      {this.descricao,
      this.numeroRegistro,
      this.numeroLacre,
      this.descricaoUnidadeDestino,
      this.idUnidadedeAdministrativaDestino,
      this.idEquipamento,
      this.idFabricante,
      this.idModelo,
      this.idTipoAquisicao,
      this.tipoAquisicao,
      this.fabricante,
      this.modelo,
      this.enderecoIp,
      this.tipoEquipamento,
      this.dataCompra,
      this.numeroNotafiscal,
      this.numeroSerie,
      this.numeroSerieSo,
      this.patrimonioSsp,
      this.patrimonioSead,
      this.descricaoSo,
      this.idTipoEquipamento,
      this.alocacoes,
      this.unidadeAtual,
      this.notaFiscal});

  EquipamentoModel.fromJson(Map<String, dynamic> json) {
    idEquipamento = json['idEquipamento'];
    descricao = json['descricao'];
    idFabricante = json['idFabricante'];
    idModelo = json['idModelo'];
    idTipoEquipamento = json['idTipoEquipamento'];
    modelo = json['modelo'];
    tipoEquipamento = json['tipoEquipamento'];
    dataCompra = json['dataCompra'];
    numeroNotafiscal = json['numeroNotaFiscal'];
    numeroSerie = json['numeroSerie'];
    numeroSerieSo = json['numeroSerieSo'];
    enderecoIp = json['enderecoIp'];
    patrimonioSead = json['patrimonioSead'];
    patrimonioSsp = json['patrimonioSsp'];
    descricaoSo = json['descricaoSo'];
    fabricante = json['fabricante'];
    if (json['alocacoes'] != null || json['alocacoes'] == []) {
      alocacoes = [];
      json['alocacoes'].forEach((v) {
        alocacoes!.add(Alocacoes.fromJson(v));
      });
    }
    notaFiscal = json['notaFiscal'];
    idTipoAquisicao = json['idTipoAquisicao'];

    unidadeAtual = json['unidadeAtual'];
    idUnidadedeAdministrativaDestino = json['idUnidadeAdministrativaDestino'];
    descricaoUnidadeDestino = json['DescricaoUnidadeDestino'];
    numeroRegistro = json['numeroRegistro'];
    numeroLacre = json['numeroLacre'];
  }
  // Map<String, dynamic> toJson() => {
  //       'patrimonioSsp': patrimonioSsp,
  //       'idModelo': idModelo,
  //       'idTipoEquipamento': idTipoEquipamento,
  //       'numeroSerie': numeroSerie,
  //       "alocacoes": alocacoes,
  //       "unidadeAtual": unidadeAtual,
  //       "descricao": descricao,
  //       "idUnidadedeAdministrativaDestino": idUnidadedeAdministrativaDestino,
  //       "idEquipamento": idEquipamento,
  //       "idFabricante": idFabricante,
  //       "patrimonioSead": patrimonioSead,
  //     };
}

class Alocacoes {
  String? unidadeAdministrativa;
  String? dataAlocacao;
  String? usuarioAlocacao;
  String? dataDesalocacao;
  String? usuarioDesalocacao;

  Alocacoes(
      {this.unidadeAdministrativa,
      this.dataAlocacao,
      this.usuarioAlocacao,
      this.dataDesalocacao,
      this.usuarioDesalocacao});

  Alocacoes.fromJson(Map<String, dynamic> json) {
    unidadeAdministrativa = json['unidadeAdministrativa'];
    dataAlocacao = json['dataAlocacao'];
    usuarioAlocacao = json['usuarioAlocacao'];
    dataDesalocacao = json['dataDesalocacao'];
    usuarioDesalocacao = json['usuarioDesalocacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unidadeAdministrativa'] = unidadeAdministrativa;
    data['dataAlocacao'] = dataAlocacao;
    data['usuarioAlocacao'] = usuarioAlocacao;
    data['dataDesalocacao'] = dataDesalocacao;
    data['usuarioDesalocacao'] = usuarioDesalocacao;
    return data;
  }
}
