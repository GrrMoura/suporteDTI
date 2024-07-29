import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/usuario_controller.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_mask.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/resetar_senha_view_model.dart';

class RecuperarSenha extends StatefulWidget {
  const RecuperarSenha({super.key});

  @override
  State<RecuperarSenha> createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  TextEditingController cpfCtrl = TextEditingController();
  TextEditingController dtNascimentoCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  ResetarSenhaViewModel model = ResetarSenhaViewModel();
  bool isOcupado = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.h,
        title: Column(
          children: [
            Text(
              "Recuperar Senha",
              style: Styles().titleStyle().copyWith(
                    fontSize: AppDimens.subHeadingSize,
                    color: AppColors.cWhiteColor,
                  ),
            ),
            Text(
              "Confirme suas informações",
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            )
          ],
        ),
        backgroundColor: AppColors.cSecondaryColor,
        leading: IconButton(
          onPressed: () {
            context.pop("value");
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: isOcupado == false
          ? SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40.h),
                  _buildTextField(
                    controller: cpfCtrl,
                    label: "CPF",
                    keyboardType: TextInputType.number,
                    formatter: MaskUtils.maskFormatterCpf(),
                  ),
                  SizedBox(height: 20.h),
                  _buildTextField(
                    controller: dtNascimentoCtrl,
                    label: "Data de Nascimento",
                    keyboardType: TextInputType.number,
                    formatter: MaskUtils.maskFormatterData(),
                  ),
                  SizedBox(height: 20.h),
                  _buildTextField(
                    controller: emailCtrl,
                    label: "E-mail Cadastrado",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: () {
                      _onContinuePressed();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cSecondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                    ),
                    child: Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cWhiteColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: () {
                      context.pop(AppRouterName.voltar);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    child: Text(
                      "Voltar",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const LoadingDefault(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    TextInputFormatter? formatter,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: [formatter ?? MaskUtils.padrao()],
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            Styles().mediumTextStyle().copyWith(color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              const BorderSide(color: AppColors.cSecondaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              const BorderSide(color: AppColors.cSecondaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      ),
    );
  }

  void _onContinuePressed() {
    String result = _validateForm(
      cpf: cpfCtrl.text,
      dtNascimento: dtNascimentoCtrl.text,
      email: emailCtrl.text,
    );
    if (result == "OK") {
      setState(() {
        isOcupado = true;
      });
      model.cpf = cpfCtrl.text;
      model.dataNascimento = dtNascimentoCtrl.text;
      model.email = emailCtrl.text;
      model.esqueceuSenha = true;
      UsuarioController.resetarSenha(context, model);

      setState(() {
        isOcupado = false;
      });
    } else {
      Generic.snackBar(context: context, mensagem: result);
    }
  }

  String _validateForm({
    required String cpf,
    required String dtNascimento,
    required String email,
  }) {
    if (Validador.cpfIsValid(cpf)) {
      if (Validador.dataNascimentoIsValid(dtNascimento: dtNascimento)) {
        if (Validador.emailIsValid(email: email)) {
          return "OK";
        } else {
          return "E-mail inválido";
        }
      } else {
        return "Data de nascimento inválida";
      }
    } else {
      return "CPF inválido";
    }
  }
}
