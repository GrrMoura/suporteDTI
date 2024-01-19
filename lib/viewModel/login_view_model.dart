class LoginViewModel {
  String? login;
  String? senha;
  bool? lembrarMe;
  bool? leitorBiometrico;
  String? token;

  LoginViewModel({
    this.login,
    this.senha,
    this.token,
    this.lembrarMe,
    this.leitorBiometrico,
  });

  LoginViewModel.fromJson(Map<String, dynamic> json) {
    login = json['usuario'];
    senha = json['senha'];
    token = json['token'];
    lembrarMe = json['lembrarMe'];
    leitorBiometrico = json['leitorBiometrico'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['senha'] = senha;
    data['token'] = token;
    return data;
  }
}
