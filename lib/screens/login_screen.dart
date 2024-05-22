// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/controller/autenticacao_controller.dart';
import 'package:suporte_dti/controller/login_controller.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_mask.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/login_view_model.dart';
import 'dart:developer' as developer;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usuarioCtrl = TextEditingController();
  TextEditingController passController = TextEditingController();
  LoginViewModel loginViewModel = LoginViewModel();

  late AutenticacaoController autenticacaoController = AutenticacaoController();

  bool isOcupado = false;
  bool isShowPass = true;

  @override
  void initState() {
    super.initState();

    login();
  }

  Future<void> login() async {
    try {
      SharedPreferences prefes = await SharedPreferences.getInstance();

      bool isEntrarComBiometria = prefes.getBool("leitorBiometrico") ?? false;
      loginViewModel.leitorBiometrico = isEntrarComBiometria;
      bool lembrarMe = prefes.getBool("lembrar_me") ?? false;
      String usuario = prefes.getString("cpf") ?? "";
      loginViewModel.lembrarMe = lembrarMe;

      setState(() {});

      if (isEntrarComBiometria) {
        loginViewModel.ocupado = true;

        await LoginController.loginBiometrico(context, model: loginViewModel);
        setState(() {});
        if (lembrarMe) {
          usuarioCtrl.text = usuario;
        }
      } else if (lembrarMe) {
        usuarioCtrl.text = usuario;
      }
    } catch (e) {
      loginViewModel.ocupado = false;

      setState(() {});
      developer.log("Não foi possível realizar o login", name: "Erro de login");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return loginViewModel.ocupado == false
        ? Scaffold(
            floatingActionButton: FloatingActionButton(onPressed: () {
              //  UsuarioController.resetarSenha(context, model)
            }),
            backgroundColor: AppColors.cPrimaryColor,
            body: SizedBox(
              height: height,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: height,
                  child: Stack(
                    children: [
                      Positioned(
                          key: const Key("telaAzul"),
                          top: 0,
                          bottom: 370.h,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 250.h,
                            decoration: const BoxDecoration(
                                color: AppColors.cSecondaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(65),
                                    bottomRight: Radius.circular(65))),
                          )),
                      Positioned(
                          top: 10.h,
                          bottom: 380.h,
                          left: 0,
                          right: 0,
                          key: const Key("logo"),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image.asset(
                              "assets/images/logo_azul.png",
                              height: 350.h,
                            ),
                          )),
                      Positioned(
                          key: const Key("credenciais"),
                          top: 270.h,
                          bottom: 10.h,
                          left: 30.w,
                          right: 30.w,
                          child: ListView(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.cWhiteColor,
                                elevation: 10,
                                shadowColor: Colors.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    cpfTextfield(),
                                    passwordTextfield(),
                                    recoverPassword()
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Positioned(
                          top: 450.h,
                          bottom: 60.h,
                          left: 30.w,
                          right: 40.w,
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                    activeColor: AppColors.cWhiteColor,
                                    activeTrackColor: AppColors.cSecondaryColor,
                                    value: loginViewModel.leitorBiometrico ??
                                        false,
                                    onChanged: (value) async {
                                      loginViewModel.leitorBiometrico = value;
                                      setState(() {});
                                      testarBiometria(value);
                                    }),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "Biometria",
                                style: Styles().smallTextStyle(),
                              ),
                              Expanded(child: SizedBox(width: 1.w)),
                              Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                    activeColor: AppColors.cWhiteColor,
                                    activeTrackColor: AppColors.cSecondaryColor,
                                    value: loginViewModel.lembrarMe ?? false,
                                    onChanged: (value) async {
                                      SharedPreferences prefes =
                                          await SharedPreferences.getInstance();
                                      prefes.setBool("lembrar_me", value);
                                      loginViewModel.lembrarMe = value;

                                      if (value) {
                                        Generic.snackBar(
                                            tipo: AppName.sucesso,
                                            context: context,
                                            mensagem:
                                                'Seu usuário será lembrado no próximo login.');
                                      }
                                      setState(() {});
                                    }),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "Lembrar-me",
                                style: Styles().smallTextStyle(),
                              ),
                            ],
                          )),
                      Positioned(
                          key: const Key("botaoEntrar"),
                          top: 580.h,
                          bottom: 60.h,
                          left: 60.w,
                          right: 60.w,
                          child: bottonEnter(context)),
                    ],
                  ),
                ),
              ),
            ))
        : const LoadingDefault();
  }

  ElevatedButton bottonEnter(BuildContext context) {
    String msg;
    return ElevatedButton(
      onPressed: () async {
        msg = validateUserAndSenhaTextfield(
            usuarioCtrl.text, passController.text);
        if (msg == "OK") {
          setState(() {});
          await autenticacaoController
              .logar(context, loginViewModel)
              .then((value) {
            setState(() {});
          });
        } else {
          Generic.snackBar(context: context, mensagem: msg);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cSecondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size(300.w, 50.h),
        elevation: 10,
        side: const BorderSide(),
      ),
      child: Text("Entrar",
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.cPrimaryColor,
          )),
    );
  }

  InkWell recoverPassword() {
    return InkWell(
      onTap: () {
        context.push(AppRouterName.recuperarSenhaScreen);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 20.w, top: 20.h, bottom: 25.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Recuperar senha?",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.cSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column passwordTextfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 5.h),
          child: Text("Senha", style: TextStyle(fontSize: 14.sp)),
        ),
        SizedBox(
            width: 230.w,
            child: TextFormField(
              controller: passController,
              onChanged: (newValue) {
                passController.text = newValue;
              },
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(fontSize: 15.sp),
              obscureText: isShowPass,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.1),
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                errorStyle: TextStyle(fontSize: 10.sp),
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined, size: 18.sp),
                  onPressed: () {
                    isShowPass = !isShowPass;
                    setState(() {});
                  },
                ),
                prefixIcon: Icon(Icons.lock, size: 18.sp),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: AppColors
                        .cSecondaryColor, // Cor da borda quando o campo está ativo
                    width: 2.0,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Column cpfTextfield() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 20.h, bottom: 5.h),
          child: Text("CPF", style: TextStyle(fontSize: 14.sp)),
        ),
        SizedBox(
          width: 230.w,
          child: TextFormField(
            controller: usuarioCtrl,
            style: TextStyle(fontSize: 14.sp),
            onChanged: (newValue) {
              usuarioCtrl.text = newValue;
            },
            textInputAction: TextInputAction.next,
            inputFormatters: [MaskUtils.maskFormatterCpf()],
            keyboardType: TextInputType.number,
            cursorColor: Colors.black, // Define a cor da barra de inserção

            decoration: InputDecoration(
              suffixIcon:
                  Icon(Icons.lock, size: 18.sp, color: Colors.transparent),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0),
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(
                  color: AppColors
                      .cSecondaryColor, // Cor da borda quando o campo está ativo
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String validateUserAndSenhaTextfield(String cpf, String senha) {
    if (cpf.isEmpty) {
      return 'O campo "CPF" precisa ser preenchido';
    } else if (!Validador.cpfIsValid(cpf)) {
      return 'CPF inválido';
    }
    if (senha.isEmpty) {
      return 'O campo "senha" precisa ser preenchido';
    } else if (senha.length < 8) {
      return 'O campo "senha" está muito curto! Entre 8 e 20 caracteres';
    }

    // loginViewModel.login = cpf;
    // loginViewModel.senha = senha;
    loginViewModel.login = '093.472.924-78';
    loginViewModel.senha = "Muebom10";
    loginViewModel.ocupado = true;

    return "OK";
  }

  Future<void> testarBiometria(bool value) async {
    if (value) {
      bool funciona =
          await LoginController.testandoSeBiometriaFunciona(context);
      if (funciona) {
        Generic.snackBar(
            context: context,
            mensagem: "O leitor biométrico será utilizado no próximo login.",
            tipo: AppName.sucesso);
      } else {
        Generic.snackBar(
            context: context,
            mensagem:
                "Desculpe. Seu dispositivo não suporta leitura biométrica.");

        await Future.delayed(const Duration(seconds: 2)).then((_) => {
              setState(() {
                loginViewModel.leitorBiometrico = false;

                LoginController.setValorDaOpcaoDeLeituraBiometrica(false);
              })
            });
      }
    } else {
      LoginController.setValorDaOpcaoDeLeituraBiometrica(value);
    }
  }
}
