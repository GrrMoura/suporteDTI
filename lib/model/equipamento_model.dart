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
  List? alocacoes;
  String? notaFiscal; //TODO: VER O TIPO NO BANCO
  String? idTipoAquisicao; //AQUI TMB
  String? tipoAquisicao;
  String? idUnidadedeAdministrativaDestino; //auqi tmb
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
      this.unidadeAtual});

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
    alocacoes = json['alocacoes'];
    notaFiscal = json['notaFiscal'];
    idTipoAquisicao = json['idTipoAquisicao'];
    tipoAquisicao = json['tipoAquisicao'];
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
