import 'package:suporte_dti/model/paginacao_model.dart';

class ItensDelegaciaModel {
  List<ItemDelegacia> delegacias = [];
  PaginacaoModels? paginacao;

  ItensDelegaciaModel({required this.delegacias, this.paginacao});

  ItensDelegaciaModel.fromJson(Map<String, dynamic> json) {
    if (json['ativas'] != null) {
      delegacias = [];
      json['ativas'].forEach((v) {
        delegacias.add(ItemDelegacia.fromJson(v));
      });
    }
    paginacao = json['paginacao'] != null
        ? PaginacaoModels.fromJson(json['paginacao'])
        : PaginacaoModels(limite: 20, pagina: 1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (delegacias != []) {
      data['ativas'] = delegacias.map((v) => v.toJson()).toList();
    }
    if (paginacao != null) {
      data['paginacao'] = paginacao?.toJson();
    }
    return data;
  }
}

class ItemDelegacia {
  int? id;
  int? idIntranetAntiga;
  String? nome;
  String? sigla;
  String? descricao;

  ItemDelegacia(
      {this.descricao, this.id, this.idIntranetAntiga, this.nome, this.sigla});

  ItemDelegacia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idIntranetAntiga = json['idIntranetAntiga'];
    descricao = json['descricao'];
    nome = json['nome'];
    sigla = json['sigla'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idIntranetAntiga'] = idIntranetAntiga;
    data['descricao'] = descricao;
    data['nome'] = nome;
    data['sigla'] = sigla;

    return data;
  }

  Map<String, dynamic> toJsonOnlyId() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
