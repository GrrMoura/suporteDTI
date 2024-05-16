import 'package:suporte_dti/model/equipamentos_model.dart';
import 'package:suporte_dti/model/paginacao_model.dart';

class EquipamentoViewModel {
  EquipamentosModel? equipamentosModels;
  PaginacaoModels? paginacao;

  int? idTipoEquipamento;
  int? idUnidade;
  String? numeroSerie;
  String? patrimonioSead;
  String? patrimonioSSP;
  String? descricao;
  Null idFabricante;
  Null idModelo;

  bool? ocupado = false;

  EquipamentoViewModel(
      {this.idTipoEquipamento,
      this.idUnidade,
      this.numeroSerie,
      this.patrimonioSead,
      this.idFabricante,
      this.idModelo,
      this.paginacao,
      this.descricao,
      this.patrimonioSSP,
      this.ocupado});

  // EquipamentoViewModel.fromJson(Map<String, dynamic> json) {
  //   if (json['resultado'] != null) {
  //     equipamentos = [];
  //     json['medidasProtetivas'].forEach((v) {
  //       equipamentos?.add(EquipamentosModel.fromJson(v));
  //     });
  //   }

  //   paginacao = json['paginacao'] != null
  //       ? PaginacaoModels?.fromJson(json['paginacao'])
  //       : PaginacaoModels(limite: 20, pagina: 1);
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTipoEquipamento'] = idTipoEquipamento;
    data['idUnidade'] = idUnidade;
    data['numeroSerie'] = numeroSerie;
    data['patrimonioSead'] = patrimonioSead;
    data['patrimonioSsp'] = patrimonioSSP;
    data['idFabricante'] = idFabricante;
    data['idModelo'] = idModelo;
    if (paginacao != null) {
      data['paginacao'] = paginacao!.toJson();
    }
    return data;
  }
}
