// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/screens/widgets/widget_informacao.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class QrCodeResult extends StatefulWidget {
  const QrCodeResult({super.key});

  @override
  State<QrCodeResult> createState() => _QrCodeResultState();
}

class _QrCodeResultState extends State<QrCodeResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const HeadingScanResult(),
        const TopoScanResult(),
        const CardEbotoes(),
        const botoesScanResult(),
        SizedBox(height: 5.h)
      ],
    ));
  }
}

class botoesScanResult extends StatelessWidget {
  const botoesScanResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.cSecondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {},
            child: Row(
              children: [
                const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
                Container(width: 10.w),
                Text(
                  "Scan",
                  style:
                      Styles().mediumTextStyle().copyWith(color: Colors.white),
                )
              ],
            )),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {},
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                Container(width: 10.w),
                Text("Voltar", style: Styles().mediumTextStyle().copyWith())
              ],
            )),
      ],
    );
  }
}

class CardEbotoes extends StatelessWidget {
  const CardEbotoes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const CardViewResultScan(
          marca: "DELL",
          modelo: "P2422HB",
          lotacao: "DAGV",
          patrimonio: "1333223",
          tag: 'br023jd223404488123092745828',
        ),
        SizedBox(
          height: 230.h,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonScanResult(icone: Icons.add, type: "Outro"),
              ButtonScanResult(icone: Icons.search, type: "Consultar"),
              ButtonScanResult(icone: Icons.share, type: "Partilhar"),
              ButtonScanResult(icone: Icons.upload, type: "Atualizar"),
            ],
          ),
        ),
      ],
    );
  }
}

class TopoScanResult extends StatelessWidget {
  const TopoScanResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InformacaoDetalhes(informacao: "1232314", titulo: "Patrimônio"),
            InformacaoDetalhes(informacao: "DAGV", titulo: "Lotação"),
            InformacaoDetalhes(informacao: "Cartório", titulo: "Setor")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const InformacaoDetalhes(
                informacao: "BH2239BH2239BH2239", titulo: "TAG"),
            Container(width: 10.w)
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InformacaoDetalhes(informacao: "16/10/22", titulo: "Levantado"),
              InformacaoDetalhes(informacao: "288/13", titulo: "Convênio"),
              InformacaoDetalhes(informacao: "1212", titulo: "LACRE"),
              SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}

class ButtonScanResult extends StatelessWidget {
  const ButtonScanResult({
    super.key,
    required this.type,
    required this.icone,
  });

  final String type;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {},
          icon: Icon(icone),
          label: Text(
            type,
            style: Styles().mediumTextStyle(),
          )),
    );
  }
}

class HeadingScanResult extends StatelessWidget {
  const HeadingScanResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cSecondaryColor,
      height: 160.h,
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Scan Completo",
              style: Styles().titleStyle(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Lotação", style: Styles().subTitleStyle()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text("-", style: Styles().subTitleStyle()),
                ),
                Text("DAGV", style: Styles().subTitleStyle())
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CardViewResultScan extends StatelessWidget {
  const CardViewResultScan(
      {required this.lotacao,
      required this.patrimonio,
      required this.tag,
      required this.marca,
      required this.modelo,
      super.key});

  final String? patrimonio, lotacao, tag, marca, modelo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5.h,
      ),
      child: SizedBox(
        height: 230.h,
        width: 150.w,
        child: Material(
          color: AppColors.cWhiteColor,
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.grey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
                child: Column(
                  children: [
                    Text(marca!, style: Styles().descriptionRestulScan()),
                    Text(modelo!, style: Styles().descriptionRestulScan()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Image.asset("assets/images/nobreak.jpg", height: 70.h),
              ),
              infomacaoScanResult(informacao: patrimonio, tipo: "Patrimônio"),
              Padding(
                padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("TAG", style: Styles().hintTextStyle()),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Text("BROAHDO2S2S3GA23332HHP2",
                          style: Styles().descriptionRestulScan()),
                    ),
                  ],
                ),
              ),
              infomacaoScanResult(informacao: lotacao, tipo: "Lotação"),
            ],
          ),
        ),
      ),
    );
  }
}

class infomacaoScanResult extends StatelessWidget {
  const infomacaoScanResult({
    super.key,
    required this.informacao,
    required this.tipo,
  });

  final String? informacao, tipo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(tipo!,
              style: Styles().hintTextStyle().copyWith(fontSize: 12.sp)),
          Text(informacao!, style: Styles().descriptionRestulScan()),
        ],
      ),
    );
  }
}
