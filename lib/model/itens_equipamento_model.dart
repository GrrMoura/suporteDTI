import 'package:suporte_dti/model/paginacao_model.dart';

class ItensEquipamentoModels {
  List<ItemEquipamento>? equipamentos;
  PaginacaoModels? paginacao;

  ItensEquipamentoModels({this.equipamentos, this.paginacao});

  ItensEquipamentoModels.fromJson(Map<String, dynamic> json) {
    if (json['identificacoesCriminais'] != null) {
      equipamentos = [];
      json['identificacoesCriminais'].forEach((v) {
        equipamentos?.add(ItemEquipamento.fromJson(v));
      });
    }
    paginacao = json['paginacao'] != null
        ? PaginacaoModels.fromJson(json['paginacao'])
        : PaginacaoModels(limite: 20, pagina: 1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (equipamentos != null) {
      data['identificacoesCriminais'] =
          equipamentos?.map((v) => v.toJson()).toList();
    }
    if (paginacao != null) {
      data['paginacao'] = paginacao?.toJson();
    }
    return data;
  }
}

class ItemEquipamento {
  int? idTipoEquipamento;
  String? numeroSerie;
  String? patrimonioSead;
  String? patrimonioSSP;
  String? descricao;
  int? idFabricante;
  int? idModelo;
  PaginacaoModels? paginacaoModel;
  bool? ocupado = false;

  ItemEquipamento(
      {this.idTipoEquipamento,
      this.numeroSerie,
      this.patrimonioSead,
      this.idFabricante,
      this.idModelo,
      this.paginacaoModel,
      this.descricao,
      this.patrimonioSSP,
      this.ocupado});

  ItemEquipamento.fromJson(Map<String, dynamic> json) {
    idTipoEquipamento = json['idTipoEquipamento'];
    numeroSerie = json['numeroSerie'];
    patrimonioSead = json['patrimonioSead'];
    patrimonioSSP = json['patrimonioSsp'];
    idFabricante = json['idFabricante'];
    idModelo = json['idModelo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTipoEquipamento'] = idTipoEquipamento;
    data['numeroSerie'] = numeroSerie;
    data['patrimonioSead'] = patrimonioSead;
    data['patrimonioSsp'] = patrimonioSSP;
    data['idFabricante'] = idFabricante;
    data['idModelo'] = idModelo;
    if (paginacaoModel != null) {
      data['paginacao'] = paginacaoModel!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toJsonOnlyId() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = idTipoEquipamento;
    return data;
  }
}
