import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

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
          const Header(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Resumo",
                style: Styles().mediumTextStyle(),
              )
            ],
          ),
          const UltimoLevantamento(),
          const LevantamentoAtual(),
          const BoxEquipamentos()
        ],
      ),
    );
  }
}

class BoxEquipamentos extends StatelessWidget {
  const BoxEquipamentos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Container(
        height: 250.h,
        decoration: BoxDecoration(
            color: AppColors.cSecondaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: ListView(
          children: const [
            CardEquipametos(
                titulo: "Estabilizador",
                id: "1",
                setor: "Sala do diretor",
                patrimonio: "44155",
                lacre: "1212"),
            CardEquipametos(
                titulo: "Monitor",
                id: "2",
                setor: "Cartorio",
                patrimonio: "122/13",
                lacre: "1010"),
            CardEquipametos(
                titulo: "Monitor",
                id: "2",
                setor: "Cartorio",
                patrimonio: "122/13",
                lacre: "1010")
          ],
        ),
      ),
    );
  }
}

class LevantamentoAtual extends StatelessWidget {
  const LevantamentoAtual({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class UltimoLevantamento extends StatelessWidget {
  const UltimoLevantamento({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w, bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 45.w, height: 45.w, child: Image.asset(AppName.sspLogo!)),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              children: [
                Text(
                  "Estado de Sergipe",
                  style: Styles().titleStyle().copyWith(
                      color: Colors.black, fontSize: AppDimens.subTitleSize),
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
    );
  }
}

class CardEquipametos extends StatelessWidget {
  const CardEquipametos({
    super.key,
    required this.titulo,
    required this.id,
    required this.setor,
    required this.patrimonio,
    required this.lacre,
  });
  final String titulo;
  final String id;
  final String setor;
  final String patrimonio;
  final String lacre;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 5.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 50.w, child: Text(id)),
                  SizedBox(
                      width: 100.w,
                      child: Text(titulo, textAlign: TextAlign.center)),
                  SizedBox(
                    width: 50.w,
                    child: IconButton(
                        onPressed: () {
                          Generic.snackBar(
                              tipo: AppName.info,
                              context: context,
                              mensagem: "Vai para a tela edit");
                        },
                        icon: Icon(Icons.edit, size: 15.sp)),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  context.push(AppRouterName.detalhe);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Setor",
                          style: Styles().descriptionRestulScan(),
                        ),
                        SizedBox(
                            width: 100.w,
                            child: Text(setor, textAlign: TextAlign.center)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Patrimônio",
                          style: Styles().descriptionRestulScan(),
                        ),
                        SizedBox(
                            width: 80.w,
                            child:
                                Text(patrimonio, textAlign: TextAlign.center)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Lacre",
                          style: Styles().descriptionRestulScan(),
                        ),
                        SizedBox(
                            width: 80.w,
                            child:
                                Text(patrimonio, textAlign: TextAlign.center)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ),
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
