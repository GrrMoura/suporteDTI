import 'dart:ffi';

import 'package:suporte_dti/model/delegacia_model.dart';

class LevantamentocadastradoModel {
  List<Cadastrados>? cadastrados;
  Paginacao? paginacao;

  LevantamentocadastradoModel({this.cadastrados, this.paginacao});

  LevantamentocadastradoModel.fromJson(Map<String, dynamic> json) {
    if (json['cadastrados'] != null) {
      cadastrados = <Cadastrados>[];
      json['cadastrados'].forEach((v) {
        cadastrados!.add(Cadastrados.fromJson(v));
      });
    }
    paginacao = json['paginacao'] != null
        ? Paginacao.fromJson(json['paginacao'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cadastrados != null) {
      data['cadastrados'] = cadastrados!.map((v) => v.toJson()).toList();
    }
    if (paginacao != null) {
      data['paginacao'] = paginacao!.toJson();
    }
    return data;
  }
}

class Cadastrados {
  int? idLevantamento;
  String? unidade;
  String? usuario;
  String? dataLevantamento;
  int? quantidadeEquipamentos;
  bool? assinado;
  Bool? levantamentoAssinado;

  Cadastrados(
      {this.idLevantamento,
      this.unidade,
      this.usuario,
      this.dataLevantamento,
      this.quantidadeEquipamentos,
      this.assinado,
      this.levantamentoAssinado});

  Cadastrados.fromJson(Map<String, dynamic> json) {
    idLevantamento = json['idLevantamento'];
    unidade = json['unidade'];
    usuario = json['usuario'];
    dataLevantamento = json['dataLevantamento'];
    quantidadeEquipamentos = json['quantidadeEquipamentos'];
    assinado = json['assinado'];
    levantamentoAssinado = json['levantamentoAssinado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idLevantamento'] = idLevantamento;
    data['unidade'] = unidade;
    data['usuario'] = usuario;
    data['dataLevantamento'] = dataLevantamento;
    data['quantidadeEquipamentos'] = quantidadeEquipamentos;
    data['assinado'] = assinado;
    data['levantamentoAssinado'] = levantamentoAssinado;
    return data;
  }
}
