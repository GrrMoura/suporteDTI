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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2), // Deslocamento da sombra
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
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
                  : LinhaDescricao(
                      informacao: item.patrimonioSead, nome: "SEAD"),
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
                                item.numeroSerie ?? '',
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
