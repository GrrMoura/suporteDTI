class EquipamentoModel {
  int? idEquipamento;
  String? descricao;
  int? idFabricante;
  int? idModelo;
  String? modelo;
  int? idTipoEquipamento;

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
  bool? comAssistenciaEmAberto;
  bool? assistenciaMenos60Dias;
  String? numeroRegistro;
  String? numeroLacre;
  bool? selecionado;

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
      this.assistenciaMenos60Dias,
      this.comAssistenciaEmAberto,
      this.selecionado,
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
    notaFiscal = json['notaFiscal'];
    idTipoAquisicao = json['idTipoAquisicao'];
    unidadeAtual = json['unidadeAtual'];
    idUnidadedeAdministrativaDestino = json['idUnidadeAdministrativaDestino'];
    descricaoUnidadeDestino = json['DescricaoUnidadeDestino'];
    numeroRegistro = json['numeroRegistro'];
    numeroLacre = json['numeroLacre'];
    if (json['alocacoes'] != null || json['alocacoes'] == []) {
      alocacoes = [];
      json['alocacoes'].forEach((v) {
        alocacoes!.add(Alocacoes.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'idEquipamento': idEquipamento,
      'descricao': descricao,
      'idModelo': idModelo,
      'modelo': modelo,
      'tipoEquipamento': tipoEquipamento,
      'dataCompra': dataCompra,
      'numeroSerie': numeroSerie,
      'numeroSerieSo': numeroSerieSo,
      'enderecoIp': enderecoIp,
      'patrimonioSead': patrimonioSead,
      'patrimonioSsp': patrimonioSsp,
      'descricaoSo': descricaoSo,
      'fabricante': fabricante,
      'comAssistenciaEmAberto': comAssistenciaEmAberto,
      'assistenciaMenos60Dias': assistenciaMenos60Dias,
      'alocacoes': alocacoes?.map((e) => e.toJson()).toList() ?? [],
      'notaFiscal': notaFiscal,
      'numeroLacre': numeroLacre,
      'selecionado': selecionado,
    };
  }
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
