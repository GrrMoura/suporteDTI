import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import 'package:suporte_dti/viewModel/login_view_model.dart';

class Sessao {
  String? token;
  String? usuario;
  int? id;
  bool? alterarSenha;
  List<String>? regrasAcesso;
  String? cpf;

  Sessao(
      {this.token,
      this.usuario,
      this.id,
      this.alterarSenha,
      this.regrasAcesso,
      this.cpf});

  Sessao.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    usuario = json['usuario'];
    id = json['id'];
    alterarSenha = json['alterarSenha'];
    regrasAcesso = json['regrasAcesso'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['usuario'] = usuario;
    data['id'] = id;
    data['alterarSenha'] = alterarSenha;
    data['regrasAcesso'] = regrasAcesso;
    return data;
  }

  Sessao.getSession(SharedPreferences prefs) {
    token = prefs.getString("token") ?? "";
    usuario = prefs.getString('usuario') ?? "";
    id = prefs.getInt('id') ?? 0;
    alterarSenha = prefs.getBool('alterarSenha') ?? false;
    regrasAcesso = prefs.getStringList('regrasAcesso');
    cpf = prefs.getString("cpf") ?? "";
  }

  void setSession(SharedPreferences prefs, LoginViewModel model) {
    prefs.setString("token", token!);
    prefs.setString("usuario", usuario!);
    prefs.setInt("id", id!);
    prefs.setBool("alterarSenha", alterarSenha!);
    prefs.setStringList("regrasAcesso", regrasAcesso!);
    prefs.setString("cpf", model.login!);
    developer.log(" Id: $id , Usuário: $usuario , Token: $token, ",
        name: "Sessão");
  }

  void clearSession(SharedPreferences prefs) {
    prefs.setString("token", "");
    prefs.setString("usuario", "");
    prefs.setInt("id", 0);
    prefs.setBool("alterarSenha", false);
    prefs.setStringList("regrasAcesso", ['']);
  }
}
