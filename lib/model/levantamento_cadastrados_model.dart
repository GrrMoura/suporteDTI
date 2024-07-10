import 'package:suporte_dti/model/delegacia_model.dart';

class LevantamentocadastradoModel {
  List<Cadastrados>? cadastrados;
  Paginacao? paginacao;

  LevantamentocadastradoModel({this.cadastrados, this.paginacao});

  factory LevantamentocadastradoModel.fromJson(Map<String, dynamic> json) {
    return LevantamentocadastradoModel(
      cadastrados: (json['cadastrados'] as List<dynamic>?)
          ?.map((e) => Cadastrados.fromJson(e))
          .toList(),
      paginacao: json['paginacao'] != null
          ? Paginacao.fromJson(json['paginacao'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cadastrados': cadastrados?.map((e) => e.toJson()).toList(),
      'paginacao': paginacao?.toJson(),
    };
  }
}

class Cadastrados {
  Cadastrados({
    this.idLevantamento,
    this.unidade,
    this.usuario,
    this.dataLevantamento,
    this.quantidadeEquipamentos,
    this.assinado,
    this.levantamentoAssinado,
  });
  int? idLevantamento;
  String? unidade;
  String? usuario;
  String? dataLevantamento;
  int? quantidadeEquipamentos;
  bool? assinado;
  bool? levantamentoAssinado;

  Cadastrados.fromJson(Map<String, dynamic> json) {
    idLevantamento = json['idLevantamento'];
    unidade = json['unidade'];
    usuario = json['usuario'];
    dataLevantamento = json['dataLevantamento'];
    quantidadeEquipamentos = json['quantidadeEquipamentos'];
    assinado = json['assinado'];
    levantamentoAssinado = json['levantamentoAssinado'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
