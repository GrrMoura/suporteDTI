// import 'package:suporte_dti/model/equipamento_model.dart';
// import 'package:suporte_dti/model/levantamento_model.dart';

// class EquipamentoVerificadoViewmodel {
//   DateTime? dataLevantamento;
//   List<EquipamentoModel>? equipamentosLevantados;
//   int? idUnidadeAdministrativa;
//   Unidade? unidade;
//   String? nomeUnidade;

//   EquipamentoVerificadoViewmodel(
//       {this.idUnidadeAdministrativa,
//       this.dataLevantamento,
//       this.unidade,
//       this.equipamentosLevantados,
//       this.nomeUnidade});

//   factory EquipamentoVerificadoViewmodel.fromJson(Map<String, dynamic> json) {
//     return EquipamentoVerificadoViewmodel(
//       equipamentosLevantados: (json['equipamentosLevantados'] as List)
//           .map((item) => EquipamentoModel.fromJson(item))
//           .toList(),
//       idUnidadeAdministrativa: json['idUnidadeAdministrativa'],
//       nomeUnidade: json['nomeUnidade'],
//       unidade: UnidadeModel.fromJson(json['unidade']),
//       dataLevantamento: json['dataLevantamento'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'equipamentosLevantados':
//           equipamentosLevantados?.map((item) => item.toJson()).toList(),
//       'idUnidadeAdministrativa': idUnidadeAdministrativa,
//       'nomeUnidade': nomeUnidade,
//       'unidade': unidade?.toJson(),
//       'dataLevantamento': dataLevantamento,
//     };
//   }
// }
