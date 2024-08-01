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
  bool? noAlmoxarifado;
  String? tipoEquipamento;

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
      this.noAlmoxarifado,
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
    data['descricao'] = descricao;

    if (paginacao != null) {
      data['paginacao'] = paginacao!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toJsonTeste() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descricao'] = descricao;
    data['idUnidade'] = idUnidade;

    if (paginacao != null) {
      data['paginacao'] = paginacao!.toJson();
    }
    return data;
  }
}
