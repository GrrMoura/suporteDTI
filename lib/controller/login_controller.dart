import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/controller/autenticacao_controller.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/viewModel/login_view_model.dart';

class LoginController {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static LoginViewModel? model = LoginViewModel();
  static bool deviceSupported = false;

  static final _autenticacaoController = AutenticacaoController();

  static Future<void> loginBiometrico(BuildContext context) async {
    bool authenticated = false;
    try {
      //   Loader.show(context);
      authenticated = await _localAuth.authenticate(
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true, useErrorDialogs: true),
          localizedReason: 'Desbloqueie para ter acesso ao App');

      if (authenticated) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        model!.login = prefs.getString("cpf") ?? "000.000.00.00";
        model!.senha = prefs.getString("senha") ?? "000001";
        model!.leitorBiometrico = prefs.getBool("leitorBiometrico") ?? true;

        _autenticacaoController.logar(context, model!).then((value) {
          //     return Loader.hide();
        });
      } else {
        //    Loader.hide();
      }
    } on PlatformException catch (e) {
      developer.log("Erro no método loginBiometrico em loginController ",
          error: e, name: "Leitura Biométrica");
      SnackBar(
          content: Text(
            'Não foi possível inicializar com biometria.',
            style: Styles().errorTextStyle(),
          ),
          backgroundColor: AppColors.cErrorColor);

      ///  Loader.hide();
      return null;
    }
  }

  // analisando se o divice suporta o uso da biometria como login.
  static Future<bool> testandoSeBiometriaFunciona(BuildContext context) async {
    deviceSupported = await _localAuth.isDeviceSupported();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("leitorBiometrico", deviceSupported);

    if (deviceSupported) {
      pegandoTiposBiometricos();
    }

    return deviceSupported;
  }

  //pegando os tipos disponiveis de biometria usaveis no device
  static Future<List<BiometricType>> pegandoTiposBiometricos() async {
    List<BiometricType> availableBiometrics = <BiometricType>[];
    if (deviceSupported) {
      try {
        if (await _localAuth.canCheckBiometrics) {
          availableBiometrics = await _localAuth.getAvailableBiometrics();
        }
        return availableBiometrics;
      } catch (e) {
        developer.log(
            "Erros ao pegar tipos de biometria em login controller => ($e)",
            name: "Pegando Tipos Biometricos");
        // Loader.hide();
        SnackBar(
            content: Text(
              'Não foi possível inicilizar com biometria.',
              style: Styles().errorTextStyle(),
            ),
            backgroundColor: AppColors.cErrorColor);
      }
    }
    return availableBiometrics;
  }

  static Future<bool> getValorDaOpcaoDeLembrarMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("lembrar_me") ?? false;
  }

  static Future<String> getValorDaCPF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login = prefs.getString("cpf")!;
    return login;
  }

  static Future setCpf(String cpf) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("cpf", cpf);
  }

  static Future<String> getValorDaSenha() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String senha = prefs.getString("senha")!;
    return senha;
  }

  static Future setSenha(String senha) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("senha", senha);
  }

  static Future<bool> getValorDaOpcaoDeLeituraBiometrica() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("leitorBiometrico") ?? false;
  }

  static Future setValorDaOpcaoDeLeituraBiometrica(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("leitorBiometrico", value);
  }
}

class AndroidAuthmessages2 {
  const AndroidAuthmessages2();
}

class AuthMessages {
  static const String cancelButton = 'Cancelar';
  static const String goToSettingsButton = 'Ir para Configurações';
  static const String goToSettingsDescription =
      'Por favor, configure a autenticação biométrica.';
  static const String fingerprintNotRecognized =
      'Impressão digital não reconhecida. Tente novamente.';
  static const String goToSettings = 'Ir para Configurações';
  static const String fingerprintRequiredTitle =
      'Autenticação Biométrica Necessária';
  static const String fingerprintSuccess = 'Autenticação Biométrica Concluída';
  static const String fingerprintHint = 'Toque no sensor de impressão digital';
  static const String fingerprintRequiredSubtitle =
      'Toque no sensor de impressão digital para continuar.';
  static const String fingerprintSuccessSubtitle =
      'Autenticação biométrica concluída com sucesso!';
  static const String fingerprintHintSubtitle =
      'Toque no sensor de impressão digital para continuar.';
  static const String fingerprintRequiredAction =
      'Toque no sensor de impressão digital para continuar.';
  static const String fingerprintSuccessAction = 'Continuar';
  static const String fingerprintHintAction = 'Cancelar';
}
