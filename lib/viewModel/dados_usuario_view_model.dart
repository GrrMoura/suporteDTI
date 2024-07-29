import 'package:shared_preferences/shared_preferences.dart';

class Dados {
  int? id;
  int? idPessoa;
  String? login;
  String? cpf;
  String? nome;
  String? email;

  Dados({this.id, this.login, this.cpf, this.nome, this.email, this.idPessoa});

  factory Dados.fromJson(Map<String, dynamic> json) {
    return Dados(
      id: json['id'],
      idPessoa: json['idPessoa'],
      login: json['login'],
      cpf: json['cpf'],
      nome: json['nome'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['cpf'] = cpf;
    data['nome'] = nome;

    data['email'] = email;
    data['idPessoa'] = idPessoa;

    return data;
  }

  static List<Dados> fromList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Dados.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Dados.getDados(SharedPreferences prefs) {
    cpf = prefs.getString("cpfUsuario") ?? "";
    nome = prefs.getString('nomeUsuario') ?? "";
    id = prefs.getInt('idUsuario') ?? 0;
    email = prefs.getString('email');
  }

  void setDados(SharedPreferences prefs) {
    prefs.setString("cpfUsuario", cpf!);
    prefs.setString("nomeUsuario", nome!);
    prefs.setInt("id", id!);
    prefs.setString("email", email!);
  }

  void clearSession(SharedPreferences prefs) {
    prefs.setString("token", "");
    prefs.setString("usuario", "");
    prefs.setInt("id", 0);
    prefs.setBool("alterarSenha", false);
    prefs.setStringList("regrasAcesso", ['']);
  }
}
