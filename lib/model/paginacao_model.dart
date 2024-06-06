import 'package:flutter/material.dart';

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

  bool seChegouAoFinalDaPagina(int paginas) {
    return paginas == totalPaginas!;
  }

  int setProximaPagina(int paginas, int totalPaginas) {
    if (totalPaginas == 1) {
      return 1;
    } else {
      return paginas = paginas + 1;
    }
  }
}
