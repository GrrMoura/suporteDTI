import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class CardEquipamentosResultado extends StatelessWidget {
  const CardEquipamentosResultado(
      {required this.lotacao,
      required this.patrimonio,
      required this.marca,
      required this.tag,
      required this.tipoEquipamento,
      super.key});

  final String? patrimonio, lotacao, marca, tipoEquipamento, tag;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cWhiteColor,
      elevation: 7,
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 3.h),
            Row(
              children: [
                Text("Patri: ", style: Styles().hintTextStyle()),
                Flexible(
                  child: SizedBox(
                    child: Text(
                      patrimonio ?? "",
                      style: Styles().smallTextStyle(),
                    ),
                  ),
                ),
              ],
            ),
            // Text(marca ?? "Sem marca", style: Styles().smallTextStyle()),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Image.asset("assets/images/nobreak.jpg", height: 70.h),
            ),
            LinhaDescricao(informacao: patrimonio, nome: "Patri"),
            LinhaDescricao(informacao: lotacao, nome: "Lotação"),
            LinhaDescricao(informacao: tag, nome: "TAG"),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}

class LinhaDescricao extends StatelessWidget {
  const LinhaDescricao(
      {super.key, required this.informacao, required this.nome});

  final String? informacao, nome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$nome: ", style: Styles().hintTextStyle()),
          Flexible(
            child: SizedBox(
              child: Text(
                informacao ?? "Sem número",
                style: Styles().smallTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
