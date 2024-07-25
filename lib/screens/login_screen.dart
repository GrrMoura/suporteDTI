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
import 'package:flutter/services.dart';

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
      bool lembrarMe = prefes.getBool("lembrar_me") ?? false;
      String usuario = prefes.getString("cpf") ?? "";

      loginViewModel
        ..leitorBiometrico = isEntrarComBiometria
        ..lembrarMe = lembrarMe;

      if (isEntrarComBiometria) {
        loginViewModel.ocupado = true;
        await LoginController.loginBiometrico(context, model: loginViewModel);
        if (lembrarMe) usuarioCtrl.text = usuario;
      } else if (lembrarMe) {
        usuarioCtrl.text = usuario;
      }

      setState(() {});
    } catch (e) {
      loginViewModel.ocupado = false;
      setState(() {});
      developer.log("Não foi possível realizar o login", name: "Erro de login");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return loginViewModel.ocupado!
        ? const LoadingDefault()
        : Scaffold(
            backgroundColor: AppColors.cPrimaryColor,
            body: SizedBox(
              height: height,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: height,
                  child: Stack(
                    children: [
                      _buildTopContainer(),
                      _buildLogo(),
                      _buildLoginForm(),
                      _buildSwitchRow(),
                      _buildEnterButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Positioned _buildTopContainer() {
    return Positioned(
      top: 0,
      bottom: 370.h,
      left: 0,
      right: 0,
      child: Container(
        height: 4.h,
        decoration: const BoxDecoration(
          color: AppColors.cSecondaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(65),
            bottomRight: Radius.circular(65),
          ),
        ),
      ),
    );
  }

  Positioned _buildLogo() {
    return Positioned(
      top: 10.h,
      bottom: 380.h,
      left: 0,
      right: 0,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset(
          "assets/images/logo_azul.png",
          height: 350.h,
        ),
      ),
    );
  }

  Positioned _buildLoginForm() {
    return Positioned(
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
                _buildCpfTextfield(),
                _buildPasswordTextfield(),
                _buildRecoverPassword(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Positioned _buildSwitchRow() {
    return Positioned(
      top: 480.h,
      bottom: 60.h,
      left: 30.w,
      right: 40.w,
      child: Row(
        children: [
          _buildSwitch(
            label: "Biometria",
            value: loginViewModel.leitorBiometrico ?? false,
            onChanged: (value) {
              loginViewModel.leitorBiometrico = value;
              setState(() {});
              _testarBiometria(value);
            },
          ),
          Expanded(child: SizedBox(width: 1.w)),
          _buildSwitch(
            label: "Lembrar-me",
            value: loginViewModel.lembrarMe ?? false,
            onChanged: (value) async {
              SharedPreferences prefes = await SharedPreferences.getInstance();
              prefes.setBool("lembrar_me", value);
              loginViewModel.lembrarMe = value;
              if (value) {
                Generic.snackBar(
                  tipo: AppName.sucesso,
                  context: context,
                  mensagem: 'Seu usuário será lembrado no próximo login.',
                );
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Positioned _buildEnterButton() {
    return Positioned(
      key: const Key("botaoEntrar"),
      top: 580.h,
      bottom: 60.h,
      left: 60.w,
      right: 60.w,
      child: ElevatedButton(
        onPressed: () async {
          usuarioCtrl.text = "093.472.924-78";
          passController.text = "Muebom50";
          String msg = _validateUserAndSenhaTextfield(
            usuarioCtrl.text,
            passController.text,
          );
          if (msg == "OK") {
            setState(() {});
            await autenticacaoController.logar(context, loginViewModel);
            setState(() {});
          } else {
            Generic.snackBar(context: context, mensagem: msg);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: Size(300.w, 50.h),
          elevation: 10,
          side: const BorderSide(),
        ),
        child: Text(
          "Entrar",
          style: TextStyle(
            fontSize: 20.sp,
            color: AppColors.cPrimaryColor,
          ),
        ),
      ),
    );
  }

  Column _buildPasswordTextfield() {
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
            obscureText: isShowPass,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(fontSize: 15.sp),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              contentPadding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0),
              errorStyle: TextStyle(fontSize: 10.sp),
              suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye_outlined, size: 18.sp),
                onPressed: () {
                  setState(() {
                    isShowPass = !isShowPass;
                  });
                },
              ),
              prefixIcon: Icon(Icons.lock, size: 18.sp),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(
                  color: AppColors.cSecondaryColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildCpfTextfield() {
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
            inputFormatters: [MaskUtils.maskFormatterCpf()],
            keyboardType: TextInputType.number,
            cursorColor: Colors.black,
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
                  color: AppColors.cSecondaryColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  InkWell _buildRecoverPassword() {
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

  Padding buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, top: 20.h, bottom: 5.h),
      child: Text(label, style: TextStyle(fontSize: 14.sp)),
    );
  }

  SizedBox buildTextField({
    required TextEditingController controller,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return SizedBox(
      width: 230.w,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14.sp),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.black.withOpacity(0.1),
          contentPadding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
              color: AppColors.cSecondaryColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSwitch({
    required String label,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.7,
          child: Switch(
            activeColor: AppColors.cWhiteColor,
            activeTrackColor: AppColors.cSecondaryColor,
            value: value,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          label,
          style: Styles().smallTextStyle(),
        ),
      ],
    );
  }

  String _validateUserAndSenhaTextfield(String cpf, String senha) {
    if (cpf.isEmpty) return 'O campo "CPF" precisa ser preenchido';
    if (!Validador.cpfIsValid(cpf)) return 'CPF inválido';
    if (senha.isEmpty) return 'O campo "senha" precisa ser preenchido';
    if (senha.length < 8) {
      return 'O campo "senha" está muito curto! Entre 8 e 20 caracteres';
    }

    loginViewModel
      ..login = cpf
      ..senha = senha
      ..ocupado = true;

    return "OK";
  }

  Future<void> _testarBiometria(bool value) async {
    if (value) {
      bool funciona =
          await LoginController.testandoSeBiometriaFunciona(context);
      if (funciona) {
        Generic.snackBar(
          context: context,
          mensagem: "O leitor biométrico será utilizado no próximo login.",
          tipo: AppName.sucesso,
        );
      } else {
        Generic.snackBar(
          context: context,
          mensagem: "Desculpe. Seu dispositivo não suporta leitura biométrica.",
        );
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          loginViewModel.leitorBiometrico = false;
          LoginController.setValorDaOpcaoDeLeituraBiometrica(false);
        });
      }
    } else {
      LoginController.setValorDaOpcaoDeLeituraBiometrica(value);
    }
  }
}
