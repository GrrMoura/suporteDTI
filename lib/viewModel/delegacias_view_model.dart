import 'package:suporte_dti/model/itens_delegacia_model.dart';
import 'package:suporte_dti/model/paginacao_model.dart';

class DelegaciasViewModel {
  ItensDelegaciaModel? itensDelegaciaModel;
  PaginacaoModels? paginacao;
  int? id;
  int? idIntranetAntiga;
  String? nome;
  String? sigla;
  String? descricao;

  DelegaciasViewModel(
      {this.id,
      this.idIntranetAntiga,
      this.nome,
      this.sigla,
      this.descricao,
      required this.itensDelegaciaModel});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idIntranetAntiga'] = idIntranetAntiga;
    data['nome'] = nome;
    data['sigla'] = sigla;
    data['descricao'] = descricao;
    if (paginacao != null) {
      data['paginacao'] = paginacao!.toJson();
    }
    return data;
  }
}
