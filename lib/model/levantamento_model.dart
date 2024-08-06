import 'package:intl/intl.dart';

class LevantamentoModel {
  List<EquipamentoLevantado>? equipamentosLevantados;
  int? idUnidadeAdministrativa;
  DateTime? dataLevantamento;
  Unidade? unidade;
  String? nomeUnidade;
  LevantamentoModel(
      {this.equipamentosLevantados,
      this.idUnidadeAdministrativa,
      this.dataLevantamento,
      this.nomeUnidade,
      this.unidade});

  LevantamentoModel.fromJson(Map<String, dynamic> json) {
    if (json['equipamentosLevantados'] != null) {
      equipamentosLevantados = <EquipamentoLevantado>[];
      json['equipamentosLevantados'].forEach((v) {
        equipamentosLevantados!.add(EquipamentoLevantado.fromJson(v));
      });
    }
    idUnidadeAdministrativa = json['idUnidadeAdministrativa'];
    dataLevantamento = json['dataLevantamento'] != null
        ? DateFormat('dd/MM/yyyy').parse(json['dataLevantamento'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (equipamentosLevantados != null) {
      data['equipamentosLevantados'] =
          equipamentosLevantados!.map((v) => v.toJson()).toList();
    }
    data['idUnidadeAdministrativa'] = idUnidadeAdministrativa;
    data['dataLevantamento'] = dataLevantamento != null
        ? DateFormat('dd/MM/yyyy').format(dataLevantamento!)
        : null;
    return data;
  }

  Map<String, dynamic> toJsonVerificar() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (equipamentosLevantados != null) {
      data['equipamentosLevantados'] =
          equipamentosLevantados!.map((v) => v.toJson()).toList();
    }
    data['idUnidadeAdministrativa'] = idUnidadeAdministrativa;
    data['nomeUnidade'] = nomeUnidade;

    data['dataLevantamento'] = dataLevantamento != null
        ? DateFormat('dd/MM/yyyy').format(dataLevantamento!)
        : null;
    return data;
  }
}

class EquipamentoLevantado {
  int? idEquipamento;
  String? descricaoSala;

  EquipamentoLevantado({this.idEquipamento, this.descricaoSala});

  EquipamentoLevantado.fromJson(Map<String, dynamic> json) {
    idEquipamento = json['idEquipamento'];
    descricaoSala = json['descricaoSala'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idEquipamento'] = idEquipamento;
    data['descricaoSala'] = descricaoSala;
    return data;
  }
}

class Unidade {
  int? id;
  int? idEquipamento;
  int? idIntranetAntiga;
  String? nome;
  String? sigla;
  String? descricao;

  Unidade({
    this.idEquipamento,
    this.idIntranetAntiga,
    this.nome,
    this.sigla,
    this.id,
    this.descricao,
  });

  factory Unidade.fromJson(Map<String, dynamic> json) {
    return Unidade(
      idEquipamento: json['idEquipamento'],
      id: json['id'],
      idIntranetAntiga: json['idIntranetAntiga'],
      nome: json['nome'],
      sigla: json['sigla'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEquipamento': idEquipamento,
      'idIntranetAntiga': idIntranetAntiga,
      'nome': nome,
      'sigla': sigla,
      'descricao': descricao,
      'id': id,
    };
  }
}
