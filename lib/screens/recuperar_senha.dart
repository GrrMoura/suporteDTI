import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/usuario_controller.dart';
import 'package:suporte_dti/model/usuario_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Recuperar senha",
                style: Styles().titleStyle().copyWith(
                    color: AppColors.contentColorBlack,
                    fontSize: AppDimens.subHeadingSize),
              ),
              const Text("É necessário confirmar algumas informações")
            ],
          ),
          Column(
            children: [
              GenericFormFieldRecuperarSenha(
                ctrl: cpfCtrl,
                titulo: "CPF",
                keyboardType: TextInputType.number,
                formatter: MaskUtils.maskFormatterCpf(),
              ),
              SizedBox(height: 20.h),
              GenericFormFieldRecuperarSenha(
                ctrl: dtNascimentoCtrl,
                titulo: "Data de nascimento",
                keyboardType: TextInputType.number,
                formatter: MaskUtils.maskFormatterData(),
              ),
              SizedBox(height: 20.h),
              GenericFormFieldRecuperarSenha(
                ctrl: emailCtrl,
                titulo: "E-mail cadastrado",
                keyboardType: TextInputType.visiblePassword,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.w, left: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 120.w,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Define o raio desejado
                          ),
                          backgroundColor: Colors.red),
                      onPressed: () {
                        context.pop(AppRouterName.voltar);
                      },
                      child: Text(
                        "Voltar",
                        style: TextStyle(
                            color: AppColors.cWhiteColor, fontSize: 15.sp),
                      )),
                ),
                SizedBox(
                  width: 120.w,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Define o raio desejado
                          ),
                          backgroundColor: AppColors.cSecondaryColor),
                      onPressed: () {
                        String result = testarform(
                            cpf: cpfCtrl.text,
                            dtNascimneto: dtNascimentoCtrl.text,
                            email: emailCtrl.text);
                        if (result == "OK") {
                          Generic.snackBar(
                              context: context,
                              tipo: AppName.sucesso,
                              mensagem:
                                  'Sua senha foi enviada para email ${emailCtrl.text}');
                          UsuarioController.resetarSenha(context, model);
                        } else {
                          Generic.snackBar(context: context, mensagem: result);
                        }
                      },
                      child: Text(
                        "Continuar",
                        style: TextStyle(
                            color: AppColors.cWhiteColor, fontSize: 15.sp),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

String testarform({
  required String cpf,
  required String dtNascimneto,
  required String email,
}) {
  if (Validador.cpfIsValid(cpf)) {
    if (Validador.dataNascimentoIsValid(dtNascimento: dtNascimneto)) {
      if (Validador.emailIsValid(email: email)) {
        return "OK";
      } else {
        return "Email inválido";
      }
    } else {
      return "Data de nascimento inválida";
    }
  } else {
    return "CPF inválido";
  }
}

class GenericFormFieldRecuperarSenha extends StatelessWidget {
  const GenericFormFieldRecuperarSenha(
      {super.key,
      required this.ctrl,
      this.keyboardType,
      required this.titulo,
      this.formatter});
  final TextEditingController ctrl;
  final TextInputType? keyboardType;
  final String titulo;
  final TextInputFormatter? formatter;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 25.w,
            bottom: 5.h,
          ),
          child: Text(
            titulo,
            style: Styles().mediumTextStyle(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            controller: ctrl,
            inputFormatters: [formatter ?? MaskUtils.padrao()],
            keyboardType: keyboardType ?? TextInputType.name,
            decoration: InputDecoration(
                alignLabelWithHint: true,
                labelStyle: Styles().mediumTextStyle(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: AppColors.cSecondaryColor, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: AppColors.cSecondaryColor, width: 2))),
          ),
        )
      ],
    );
  }
}
