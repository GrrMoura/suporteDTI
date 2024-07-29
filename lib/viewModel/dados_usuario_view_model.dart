import 'package:shared_preferences/shared_preferences.dart';

class DadosDoUsuarioViewModel {
  Dados? dados;

  DadosDoUsuarioViewModel({this.dados});

  DadosDoUsuarioViewModel.fromJson(Map<String, dynamic> json) {
    dados = json['dados'] != null ? Dados.fromJson(json['dados']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dados != null) {
      data['dados'] = dados!.toJson();
    }
    return data;
  }
}

class Dados {
  int? id;
  String? login;
  String? cpf;
  String? nome;
  String? sexo;
  String? email;
  String? emailPessoal;
  String? dataNascimento;

  Dados(
      {this.id,
      this.login,
      this.cpf,
      this.nome,
      this.sexo,
      this.email,
      this.emailPessoal,
      this.dataNascimento});

  factory Dados.fromJson(Map<String, dynamic> json) {
    return Dados(
      id: json['id'],
      login: json['login'],
      cpf: json['cpf'],
      nome: json['nome'],
      sexo: json['sexo'],
      email: json['email'],
      emailPessoal: json['emailPessoal'],
      dataNascimento: json['dataNascimento'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['cpf'] = cpf;
    data['nome'] = nome;
    data['sexo'] = sexo;
    data['email'] = email;
    data['emailPessoal'] = emailPessoal;
    data['dataNascimento'] = dataNascimento;
    return data;
  }

  Dados.getDados(SharedPreferences prefs) {
    cpf = prefs.getString("cpfUsuario") ?? "";
    nome = prefs.getString('nomeUsuario') ?? "";
    id = prefs.getInt('idUsuario') ?? 0;
    email = prefs.getString('email');
    emailPessoal = prefs.getString('emailPessoal');

    dataNascimento = prefs.getString("dataNascimento");
  }

  void setDados(SharedPreferences prefs) {
    prefs.setString("cpfUsuario", cpf!);
    prefs.setString("nomeUsuario", nome!);
    prefs.setInt("id", id!);
    prefs.setString("email", email!);
    prefs.setString("dataNascimento", dataNascimento!);
    prefs.setString("emailPessoal", emailPessoal!);
  }

  void clearSession(SharedPreferences prefs) {
    prefs.setString("token", "");
    prefs.setString("usuario", "");
    prefs.setInt("id", 0);
    prefs.setBool("alterarSenha", false);
    prefs.setStringList("regrasAcesso", ['']);
  }
}
