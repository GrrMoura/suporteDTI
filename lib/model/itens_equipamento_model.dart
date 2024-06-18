import 'package:suporte_dti/model/paginacao_model.dart';

class ItensEquipamentoModels {
  List<ItemEquipamento> equipamentos = [];
  PaginacaoModels? paginacao;

  ItensEquipamentoModels({required this.equipamentos, this.paginacao});

  ItensEquipamentoModels.fromJson(Map<String, dynamic> json) {
    if (json['cadastrados'] != null) {
      equipamentos = [];
      json['cadastrados'].forEach((v) {
        equipamentos.add(ItemEquipamento.fromJson(v));
      });
    }
    paginacao = json['paginacao'] != null
        ? PaginacaoModels.fromJson(json['paginacao'])
        : PaginacaoModels(limite: 20, pagina: 1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (equipamentos != []) {
      data['cadastrados'] = equipamentos.map((v) => v.toJson()).toList();
    }
    if (paginacao != null) {
      data['paginacao'] = paginacao?.toJson();
    }
    return data;
  }
}

class ItemEquipamento {
  int? idEquipamento;
  String? numeroSerie;
  String? patrimonioSead;
  String? patrimonioSsp;
  String? descricao;
  String? fabricante;
  String? modelo;
  String? tipoEquipamento;
  int? idFabricante;
  int? idModelo;

  ItemEquipamento({
    this.idEquipamento,
    this.numeroSerie,
    this.patrimonioSead,
    this.idFabricante,
    this.idModelo,
    this.modelo,
    this.descricao,
    this.fabricante,
    this.patrimonioSsp,
    this.tipoEquipamento,
  });

  ItemEquipamento.fromJson(Map<String, dynamic> json) {
    patrimonioSsp = json['patrimonioSsp'];
    idEquipamento = json['idEquipamento'];
    descricao = json['descricao'];
    fabricante = json['fabricante'];
    modelo = json['modelo'];
    tipoEquipamento = json['tipoEquipamento'];
    numeroSerie = json['numeroSerie'];
    patrimonioSead = json['patrimonioSead'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEquipamento'] = idEquipamento;
    data['numeroSerie'] = numeroSerie;
    data['patrimonioSead'] = patrimonioSead;
    data['patrimonioSsp'] = patrimonioSsp;
    data['idFabricante'] = idFabricante;
    data['idModelo'] = idModelo;

    return data;
  }

  Map<String, dynamic> toDb() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEquipamento'] = idEquipamento;
    data['numeroSerie'] = numeroSerie;
    data['patrimonioSead'] = patrimonioSead;
    data['patrimonioSsp'] = patrimonioSsp;
    data['idFabricante'] = idFabricante;
    data['descricao'] = descricao;
    data['fabricante'] = fabricante;
    data['modelo'] = modelo;
    data['tipoEquipamento'] = tipoEquipamento;

    return data;
  }

  Map<String, dynamic> toJsonOnlyId() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEquipamento'] = idEquipamento;
    return data;
  }
}
