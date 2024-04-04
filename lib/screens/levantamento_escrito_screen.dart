import 'package:flutter/material.dart';

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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Possui lacre?",
                    style: Styles().mediumTextStyle(),
                  ),
                  Switch(
                      value: isConvenio,
                      onChanged: (value) {
                        setState(() {
                          isConvenio = value;
                        });
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Possui convênio?",
                    style: Styles().smallTextStyle(),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                        value: isConvenio,
                        onChanged: (value) {
                          setState(() {
                            isConvenio = value;
                          });
                        }),
                  ),
                ],
              ),
              FieldsLevantamentoDigitado(
                  lotacaoCtrl: lotacaoCtrl,
                  tipo: "Lotação",
                  keyboardType: TextInputType.name),
              FieldsLevantamentoDigitado(
                  lotacaoCtrl: setorCtrl,
                  tipo: "Setor",
                  keyboardType: TextInputType.name),
              FieldsLevantamentoDigitado(
                  lotacaoCtrl: equipamentoCtrl,
                  tipo: "Equipamento",
                  keyboardType: TextInputType.name),
              FieldsLevantamentoDigitado(
                  lotacaoCtrl: marcaCtrl,
                  tipo: "Marca-Modelo",
                  keyboardType: TextInputType.visiblePassword),
              FieldsLevantamentoDigitado(
                  lotacaoCtrl: patrimonioCtrl,
                  tipo: "Patrimônio",
                  keyboardType: TextInputType.number),
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
                            Icons.qr_code,
                            color: Colors.white,
                          ),
                          Container(width: 10.w),
                          Text(
                            "Scan",
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
                          const Icon(Icons.arrow_back),
                          Container(width: 10.w),
                          Text("Voltar", style: Styles().mediumTextStyle())
                        ],
                      )),
                ],
              ),
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
      required this.keyboardType});

  final TextEditingController lotacaoCtrl;
  final String tipo;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: lotacaoCtrl,
        keyboardType: keyboardType,
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
