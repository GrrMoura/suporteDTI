class NaoAlocadosModel {
  List<NaoAlocado>? naoAlocados;

  NaoAlocadosModel({this.naoAlocados});

  NaoAlocadosModel.fromJson(Map<String, dynamic> json) {
    if (json['naoAlocados'] != null) {
      naoAlocados = <NaoAlocado>[];
      json['naoAlocados'].forEach((v) {
        naoAlocados!.add(NaoAlocado.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'naoAlocados': naoAlocados?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class NaoAlocado {
  int? idEquipamento;
  int? idEquipamentoLevantado;
  String? descricao;
  String? descricaoUnidade;

  NaoAlocado({
    this.idEquipamento,
    this.idEquipamentoLevantado,
    this.descricao,
    this.descricaoUnidade,
  });

  NaoAlocado.fromJson(Map<String, dynamic> json) {
    idEquipamento = json['idEquipamento'];
    idEquipamentoLevantado = json['idEquipamentoLevantado'];
    descricao = json['descricao'];
    descricaoUnidade = json['descricaoUnidade'];
  }

  Map<String, dynamic> toJson() {
    return {
      'idEquipamento': idEquipamento,
      'idEquipamentoLevantado': idEquipamentoLevantado,
      'descricao': descricao,
      'descricaoUnidade': descricaoUnidade,
    };
  }

  static List<NaoAlocado> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => NaoAlocado.fromJson(json)).toList();
  }
}
