class PaginacaoModels {
  int? limite;
  int? pagina;
  int? totalPaginas;
  int? registros;

  PaginacaoModels(
      {this.limite, this.pagina, this.totalPaginas, this.registros});

  PaginacaoModels.fromJson(Map<String, dynamic> json) {
    limite = 10;
    pagina = json['pagina'];
    totalPaginas = json['totalPaginas'];
    registros = json['registros'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limite'] = limite;
    data['pagina'] = pagina;
    data['totalPaginas'] = totalPaginas;
    data['Registros'] = registros;
    return data;
  }

  int getPosicaoInicialList() {
    return (pagina! * limite!) - limite!;
  }

  bool seChegouAoFinalDaPagina() {
    print(pagina);
    return pagina! == totalPaginas!;
  }

  void setProximaPagina() {
    pagina = pagina! + 1;
  }
}
