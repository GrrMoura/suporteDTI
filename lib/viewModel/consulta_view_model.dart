// import 'package:suporte_dti/model/itens_equipamento_model.dart';
// import 'package:suporte_dti/model/paginacao_model.dart';

// class EquipamentoViewModel {
//   ItensEquipamentoModels? itensEquipamentoModels;
//   PaginacaoModels? paginacao =
//       PaginacaoModels(limite: 10, pagina: 1, registros: 6, totalPaginas: 100);
//   int? idTipoEquipamento;
//   String? numeroSerie;
//   String? patrimonioSead;
//   String? patrimonioSSP;
//   String? descricao;
//   int? idFabricante;
//   int? idModelo;

//   bool? ocupado = false;

//   EquipamentoViewModel(
//       {this.idTipoEquipamento,
//       this.numeroSerie,
//       this.patrimonioSead,
//       this.idFabricante,
//       this.idModelo,
//       this.paginacao,
//       this.descricao,
//       this.patrimonioSSP,
//       this.ocupado});
// //modelo tem um campo fabricante.
//   EquipamentoViewModel.fromJson(Map<String, dynamic> json) {
//     idTipoEquipamento = json['idTipoEquipamento'];
//     numeroSerie = json['numeroSerie'];
//     patrimonioSead = json['patrimonioSead'];
//     patrimonioSSP = json['patrimonioSsp'];
//     idFabricante = json['idFabricante'];
//     idModelo = json['idModelo'];

//     paginacao = json['paginacao'] != null
//         ? PaginacaoModels.fromJson(json['paginacao'])
//         : PaginacaoModels(limite: 20, pagina: 1);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['idTipoEquipamento'] = idTipoEquipamento;
//     data['numeroSerie'] = numeroSerie;
//     data['patrimonioSead'] = patrimonioSead;
//     data['patrimonioSsp'] = patrimonioSSP;
//     data['idFabricante'] = idFabricante;
//     data['idModelo'] = idModelo;
//     if (paginacao != null) {
//       data['paginacao'] = paginacao?.toJson();
//     }
//     return data;
//   }
// }
