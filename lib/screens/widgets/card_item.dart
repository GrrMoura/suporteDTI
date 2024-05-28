import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class CardEquipamentosResultado extends StatelessWidget {
  const CardEquipamentosResultado({required this.item, super.key});

  final ItemEquipamento item;
  // final String? patrimonio, lotacao, marca, tipoEquipamento, tag;

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
                Text("Patr. ", style: Styles().hintTextStyle()),
                Flexible(
                  child: SizedBox(
                    child: Text(
                      item.patrimonioSsp ?? "",
                      style: Styles().smallTextStyle(),
                    ),
                  ),
                ),
              ],
            ),
            // Text(marca ?? "Sem marca", style: Styles().smallTextStyle()),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Image.asset(
                AppName.fotoEquipamento(item.tipoEquipamento!),
                height: 60.h,
              ),
            ),
            LinhaDescricao(informacao: item.fabricante, nome: "Fabricante"),
            LinhaDescricao(informacao: item.modelo, nome: "Modelo"),
            item.patrimonioSead!.length <= 1 || item.patrimonioSead == ""
                ? Container()
                : LinhaDescricao(informacao: item.patrimonioSead, nome: "SEAD"),
            item.numeroSerie != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TAG: ", style: Styles().hintTextStyle()),
                        Flexible(
                          child: SizedBox(
                            child: Text(
                              item.numeroSerie!,
                              style: Styles()
                                  .smallTextStyle()
                                  .copyWith(fontSize: 10.sp),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
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
                style: Styles()
                    .smallTextStyle()
                    .copyWith(fontSize: 10.sp, overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
