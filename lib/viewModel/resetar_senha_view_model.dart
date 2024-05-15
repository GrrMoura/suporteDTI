class ResetarSenhaViewModel {
  String? cpf = "";
  String? dataNascimento = "";
  String? email = "";
  bool? esqueceuSenha = false;
  bool? ocupado = false;

  ResetarSenhaViewModel(
      {this.cpf, this.dataNascimento, this.email, this.ocupado});

  ResetarSenhaViewModel.fromJson(Map<String, dynamic> json) {
    cpf = json['cpf'];
    dataNascimento = json['dataNascimento'];
    email = json['email'];
    esqueceuSenha = json['esqueceuSenha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cpf'] = cpf;
    data['dataNascimento'] = dataNascimento;
    data['email'] = email;
    data['esqueceuSenha'] = esqueceuSenha;
    return data;
  }
}
