class DelegaciaModel {
  List<Ativas>? ativas;
  Paginacao? paginacao;

  DelegaciaModel({this.ativas, this.paginacao});

  DelegaciaModel.fromJson(Map<String, dynamic> json) {
    if (json['ativas'] != null) {
      ativas = <Ativas>[];
      json['ativas'].forEach((v) {
        ativas!.add(Ativas.fromJson(v));
      });
    }
    paginacao = json['paginacao'] != null
        ? Paginacao.fromJson(json['paginacao'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ativas != null) {
      data['ativas'] = ativas!.map((v) => v.toJson()).toList();
    }
    if (paginacao != null) {
      data['paginacao'] = paginacao!.toJson();
    }
    return data;
  }
}

class Ativas {
  int? id;
  int? idIntranetAntiga;
  String? nome;
  String? sigla;
  String? descricao;

  Ativas(
      {this.id, this.idIntranetAntiga, this.nome, this.sigla, this.descricao});

  Ativas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idIntranetAntiga = json['idIntranetAntiga'];
    nome = json['nome'];
    sigla = json['sigla'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['idIntranetAntiga'] = idIntranetAntiga;
    data['nome'] = nome;
    data['sigla'] = sigla;
    data['descricao'] = descricao;
    return data;
  }
}

class Paginacao {
  int? limite;
  int? pagina;
  int? totalPaginas;
  int? registros;

  Paginacao({this.limite, this.pagina, this.totalPaginas, this.registros});

  Paginacao.fromJson(Map<String, dynamic> json) {
    limite = json['limite'];
    pagina = json['pagina'];
    totalPaginas = json['totalPaginas'];
    registros = json['registros'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limite'] = limite;
    data['pagina'] = pagina;
    data['totalPaginas'] = totalPaginas;
    data['registros'] = registros;
    return data;
  }
}
