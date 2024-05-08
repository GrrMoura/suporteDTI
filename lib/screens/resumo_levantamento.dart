import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class ResumoLevantamento extends StatelessWidget {
  const ResumoLevantamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cSecondaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 8.h, left: 10.w, right: 10.w, bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 45.w,
                    height: 45.w,
                    child: Image.asset(AppName.sspLogo!)),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    children: [
                      Text(
                        "Estado de Sergipe",
                        style: Styles().titleStyle().copyWith(
                            color: Colors.black,
                            fontSize: AppDimens.subTitleSize),
                      ),
                      Text("Secretaria de Segurança Pública",
                          style: Styles().smallTextStyle().copyWith(
                                color: AppColors.contentColorBlack,
                              )),
                      Text("CPSI/DTI",
                          style: Styles().smallTextStyle().copyWith(
                                color: AppColors.contentColorBlack,
                              )),
                    ],
                  ),
                ),
                SizedBox(
                    width: 50.w,
                    height: 50.w,
                    child: Image.asset(
                      AppName.logoDti!,
                      color: AppColors.cSecondaryColor,
                    )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Resumo",
                style: Styles().mediumTextStyle(),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Container(
              width: double.maxFinite,
              height: 80.h,
              decoration: const BoxDecoration(
                  color: AppColors.cSecondaryColor,
                  boxShadow: [BoxShadow(color: Colors.black)],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: const Column(
                children: [
                  InfoResumo(
                    titulo: "Último levantamento",
                    info: "20/04/2022",
                  ),
                  InfoResumo(
                    titulo: "Total de Equipamentos",
                    info: "30",
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Container(
              width: double.maxFinite,
              height: 80.h,
              decoration: const BoxDecoration(
                  color: AppColors.cSecondaryColor,
                  boxShadow: [BoxShadow(color: Colors.black)],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      topLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: const Column(
                children: [
                  InfoResumo(
                    titulo: "Levantamento Atual",
                    info: "25/01/2024",
                  ),
                  InfoResumo(
                    titulo: "Total de Equipamentos",
                    info: "25",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoResumo extends StatelessWidget {
  const InfoResumo({
    required this.info,
    required this.titulo,
    super.key,
  });
  final String titulo;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 160.w,
            child: Text(
              titulo + ":",
              style: Styles()
                  .descriptionRestulScan()
                  .copyWith(color: const Color.fromARGB(255, 195, 197, 199)),
            ),
          ),
          SizedBox(
            width: 80.w,
            child: Text(info,
                style: Styles()
                    .descriptionRestulScan()
                    .copyWith(color: AppColors.cPrimaryColor)),
          ),
        ],
      ),
    );
  }
}
