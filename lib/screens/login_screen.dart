import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/controller/autenticacao_controller.dart';
import 'package:suporte_dti/controller/login_controller.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_mask.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/viewModel/login_view_model.dart';
import 'dart:developer' as developer;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final _formKey = GlobalKey<FormState>();

  TextEditingController usuarioCtrl = TextEditingController();
  TextEditingController passController = TextEditingController();
  LoginViewModel loginViewModel = LoginViewModel();
  late AutenticacaoController _autenticacaoController =
      AutenticacaoController();
  bool isOcupado = false;

  var isShowPass = false;

  @override
  void initState() {
    super.initState();

    // _login();
  }

  Future<void> _login() async {
    try {
      SharedPreferences prefes = await SharedPreferences.getInstance();

      bool isEntrarComBiometria = prefes.getBool("leitorBiometrico") ?? true;
      loginViewModel.leitorBiometrico = isEntrarComBiometria;
      bool lembrarMe = prefes.getBool("lembrar_me") ?? false;
      String usuario = prefes.getString("cpf") ?? "";
      //  loginViewModel.token = (await FirebaseMessaging.instance.getToken())!;
      loginViewModel.lembrarMe = lembrarMe;

      setState(() {});

      if (isEntrarComBiometria) {
        LoginController.loginBiometrico(context);
        if (lembrarMe) {
          usuarioCtrl.text = usuario;
        }
      } else if (lembrarMe) {
        usuarioCtrl.text = usuario;
      }
    } catch (e) {
      //  Loader.hide();
      developer.log("Não foi possível realizar o login", name: "Erro de login");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return loginViewModel.ocupado == false
        ? Scaffold(
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
    return ElevatedButton(
      onPressed: () {
        validateUserAndSenhaTextfield(usuarioCtrl.text, passController.text);
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

  Padding recoverPassword() {
    return Padding(
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
            onChanged: (newValue) {
              passController.text = newValue;
            },
            style: TextStyle(fontSize: 15.sp),
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              errorStyle: TextStyle(fontSize: 10.sp),
              suffixIcon: Icon(Icons.remove_red_eye, size: 18.sp),
              prefixIcon: Icon(Icons.lock, size: 18.sp),
              hintText: "********",
              hintStyle: TextStyle(fontSize: 12.sp),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ),
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
            style: TextStyle(fontSize: 14.sp),
            onChanged: (newValue) {
              usuarioCtrl.text = newValue;
            },
            inputFormatters: [MaskUtils.maskFormatterCpf()],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon:
                  Icon(Icons.lock, size: 18.sp, color: Colors.transparent),
              hintText: "111.222.333-44",
              hintStyle: TextStyle(fontSize: 12.sp),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0),
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  validateUserAndSenhaTextfield(String cpf, String senha) {
    if (cpf.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              'O campo "CPF" precisa ser preenchido',
              style: Styles().errorTextStyle(),
            ),
            backgroundColor: AppColors.cErrorColor),
      );
    } else if (!Validador.cpfIsValid(cpf)) {
      print(Validador.cpfIsValid(cpf));
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'CPF inválido',
            style: Styles().errorTextStyle(),
          ),
          backgroundColor: AppColors.cErrorColor));
    }

    if (senha.isEmpty) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'O campo "senha" precisa ser preenchido',
            style: Styles().errorTextStyle(),
          ),
          backgroundColor: AppColors.cErrorColor));
    } else if (senha.length < 8) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'O campo "senha" está muito curto! Entre 8 e 20 caracteres',
            style: Styles().errorTextStyle(),
          ),
          backgroundColor: AppColors.cErrorColor));
    }

    loginViewModel.login = cpf;
    loginViewModel.senha = senha;
    loginViewModel.ocupado = true;
    setState(() {});
    _autenticacaoController.logar(context, loginViewModel).then((value) {
      setState(() {});
    });
  }
}
