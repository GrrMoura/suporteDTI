import 'package:intl/intl.dart';

class DetalheLevantamentoModel {
  Detalhes? detalhes;

  DetalheLevantamentoModel({this.detalhes});

  DetalheLevantamentoModel.fromJson(Map<String, dynamic> json) {
    detalhes =
        json['detalhes'] != null ? Detalhes.fromJson(json['detalhes']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'detalhes': detalhes?.toJson(),
    };
  }
}

class Detalhes {
  int? idLevantamento;
  int? idUnidadeAdministrativa;
  int? idUsuarioCadastro;
  DateTime? dataLevantamento;
  List<EquipamentoLevantado>? equipamentosLevantados;
  List<List<List<dynamic>>>? unidade;
  String? nomeUnidade;

  Detalhes({
    this.idLevantamento,
    this.idUnidadeAdministrativa,
    this.idUsuarioCadastro,
    this.dataLevantamento,
    this.equipamentosLevantados,
    this.unidade,
    this.nomeUnidade,
  });

  Detalhes.fromJson(Map<String, dynamic> json) {
    idLevantamento = json['idLevantamento'];
    idUnidadeAdministrativa = json['idUnidadeAdministrativa'];
    idUsuarioCadastro = json['idUsuarioCadastro'];
    dataLevantamento = json['dataLevantamento'] != null
        ? DateFormat('dd/MM/yyyy').parse(json['dataLevantamento'])
        : null;

    if (json['equipamentosLevantados'] != null) {
      equipamentosLevantados = <EquipamentoLevantado>[];
      json['equipamentosLevantados'].forEach((v) {
        equipamentosLevantados!.add(EquipamentoLevantado.fromJson(v));
      });
    }

    if (json['unidade'] != null) {
      unidade = <List<List<dynamic>>>[];
      json['unidade'].forEach((v) {
        unidade!.add(List<List<dynamic>>.from(
            v.map((i) => List<dynamic>.from(i.map((j) => j)))));
      });
    }

    nomeUnidade = json['nomeUnidade'];
  }

  Map<String, dynamic> toJson() {
    return {
      'idLevantamento': idLevantamento,
      'idUnidadeAdministrativa': idUnidadeAdministrativa,
      'idUsuarioCadastro': idUsuarioCadastro,
      'dataLevantamento': dataLevantamento != null
          ? DateFormat('dd/MM/yyyy').format(dataLevantamento!)
          : null,
      'equipamentosLevantados':
          equipamentosLevantados?.map((v) => v.toJson()).toList(),
      'unidade': unidade
          ?.map((v) => v.map((i) => i.map((j) => j).toList()).toList())
          .toList(),
      'nomeUnidade': nomeUnidade,
    };
  }
}

class EquipamentoLevantado {
  int? idEquipamento;
  String? descricao;
  String? descricaoSala;
  int? idEquipamentoLevantado;

  EquipamentoLevantado({
    this.idEquipamento,
    this.descricao,
    this.descricaoSala,
    this.idEquipamentoLevantado,
  });

  EquipamentoLevantado.fromJson(Map<String, dynamic> json) {
    idEquipamento = json['idEquipamento'];
    descricao = json['descricao'];
    descricaoSala = json['descricaoSala'];
    idEquipamentoLevantado = json['idEquipamentoLevantado'];
  }

  Map<String, dynamic> toJson() {
    return {
      'idEquipamento': idEquipamento,
      'descricao': descricao,
      'descricaoSala': descricaoSala,
      'idEquipamentoLevantado': idEquipamentoLevantado,
    };
  }
}
