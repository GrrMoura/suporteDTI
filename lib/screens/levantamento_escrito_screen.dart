import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class LevantamentoDigitado extends StatefulWidget {
  const LevantamentoDigitado({super.key});

  @override
  State<LevantamentoDigitado> createState() => _LevantamentoDigitadoState();
}

class _LevantamentoDigitadoState extends State<LevantamentoDigitado> {
  TextEditingController equipamentoCtrl = TextEditingController();
  TextEditingController marcaCtrl = TextEditingController();
  TextEditingController serviceTagCtrl = TextEditingController();
  TextEditingController lotacaoCtrl = TextEditingController();
  TextEditingController setorCtrl = TextEditingController();
  TextEditingController lacreCtrl = TextEditingController();
  TextEditingController convenioCtrl = TextEditingController();
  TextEditingController patrimonioCtrl = TextEditingController();
  bool isLacre = false;
  bool isConvenio = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Levantamento",
            style: Styles().mediumTextStyle().copyWith(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.cSecondaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.sp),
              Row(
                children: [
                  SizedBox(width: 10.w),
                  Text(
                    "Possui convênio?",
                    style: Styles().smallTextStyle(),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                        activeColor: AppColors.cSecondaryColor,
                        value: isConvenio,
                        onChanged: (value) {
                          setState(() {
                            isConvenio = value;
                          });
                        }),
                  ),
                  const Expanded(child: SizedBox(width: 30)),
                  Text(
                    "Possui Lacre?",
                    style: Styles().smallTextStyle(),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                        activeColor: AppColors.cSecondaryColor,
                        value: isLacre,
                        onChanged: (value) {
                          setState(() {
                            isLacre = value;
                          });
                        }),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
              FieldsLevantamentoDigitado(
                lotacaoCtrl: lotacaoCtrl,
                tipo: "Lotação",
              ),
              FieldsLevantamentoDigitado(
                lotacaoCtrl: setorCtrl,
                tipo: "Setor",
              ),
              FieldsLevantamentoDigitado(
                lotacaoCtrl: equipamentoCtrl,
                tipo: "Equipamento",
              ),
              FieldsLevantamentoDigitado(
                  lotacaoCtrl: marcaCtrl,
                  tipo: "Marca-Modelo",
                  keyboardType: TextInputType.visiblePassword),
              FieldsLevantamentoDigitado(
                  lotacaoCtrl: patrimonioCtrl,
                  tipo: "Patrimônio",
                  keyboardType: TextInputType.visiblePassword),
              FieldsLevantamentoDigitado(
                  lotacaoCtrl: serviceTagCtrl,
                  tipo: "Sn - Service Tag",
                  keyboardType: TextInputType.visiblePassword),
              isConvenio == true
                  ? FieldsLevantamentoDigitado(
                      lotacaoCtrl: convenioCtrl,
                      tipo: "Convênio",
                      keyboardType: TextInputType.number)
                  : Container(),
              isLacre == true
                  ? FieldsLevantamentoDigitado(
                      lotacaoCtrl: lacreCtrl,
                      tipo: "Lacre",
                      keyboardType: TextInputType.number)
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.cSecondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        //  context.go(AppRouterName.homeController);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.plus_one,
                            color: Colors.white,
                          ),
                          Container(width: 10.w),
                          Text(
                            "Outro",
                            style: Styles()
                                .mediumTextStyle()
                                .copyWith(color: Colors.white),
                          )
                        ],
                      )),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        //context.push(AppRouterName.homeController);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.check),
                          Container(width: 10.w),
                          Text("Concluir", style: Styles().mediumTextStyle())
                        ],
                      )),
                ],
              ),
              Container(height: 20.h)
            ],
          ),
        ));
  }
}

class FieldsLevantamentoDigitado extends StatelessWidget {
  const FieldsLevantamentoDigitado(
      {super.key,
      required this.lotacaoCtrl,
      required this.tipo,
      this.keyboardType});

  final TextEditingController lotacaoCtrl;
  final String tipo;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: lotacaoCtrl,
        keyboardType: keyboardType ?? TextInputType.name,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: tipo,
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
    );
  }
}
