class ConsultaViewModel {
  final String tipoConsulta = "";

  String? identificacao;
  bool ocupado = false;

  ConsultaViewModel({this.identificacao, this.ocupado = false});

  ConsultaViewModel.fromJson(Map<String, dynamic> json) {
    identificacao = json['identificacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identificacao'] = identificacao!.replaceAll("-", "");
    data['tipoConsulta'] = tipoConsulta;
    return data;
  }
}

//#region Consulta Veicular Models

class PlacaConsultaVeicularViewModel extends ConsultaViewModel {
  @override
  final String tipoConsulta = "P";
}

class RenavamConsultaVeicularViewModel extends ConsultaViewModel {
  @override
  final String tipoConsulta = "R";
}

class ChassiConsultaVeicularViewModel extends ConsultaViewModel {
  @override
  final String tipoConsulta = "C";
}

//#endregion

//#region Consulta CNH Models

class CpfConsultaCnhViewModel extends ConsultaViewModel {
  @override
  final String tipoConsulta = "C";
}

class RegistroConsultaCnhViewModel extends ConsultaViewModel {
  @override
  final String tipoConsulta = "R";
}

//#endregion