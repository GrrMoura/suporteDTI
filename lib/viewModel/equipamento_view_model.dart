import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/model/paginacao_model.dart';

class EquipamentoViewModel {
  ItensEquipamentoModels itensEquipamentoModels;
  PaginacaoModels? paginacao;

  int? idTipoEquipamento;
  int? idUnidade;
  String? numeroSerie;
  String? patrimonioSead;
  String? patrimonioSSP;
  String? descricao;
  int? idFabricante;
  int? idModelo;

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
      this.ocupado,
      required this.itensEquipamentoModels});

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
