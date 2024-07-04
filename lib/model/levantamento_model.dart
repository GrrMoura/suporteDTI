import 'package:intl/intl.dart';

class LevantamentoModel {
  List<EquipamentoLevantado>? equipamentosLevantados;
  int? idUnidadeAdministrativa;
  DateTime? dataLevantamento;

  LevantamentoModel({
    this.equipamentosLevantados,
    this.idUnidadeAdministrativa,
    this.dataLevantamento,
  });

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
}

class EquipamentoLevantado {
  int? id;
  String? descricaoSala;

  EquipamentoLevantado({this.id, this.descricaoSala});

  EquipamentoLevantado.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricaoSala = json['descricaoSala'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricaoSala'] = descricaoSala;
    return data;
  }
}
