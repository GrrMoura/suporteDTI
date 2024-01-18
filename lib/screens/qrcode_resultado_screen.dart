// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suporte_dti/navegacao/app_screens_string.dart';
import 'package:suporte_dti/screens/equipamento_detalhe_screen.dart';
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
    double heigth = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: heigth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const HeadingScanResult(),
            const TopoScanResult(),
            CardEbotoes(),
            Expanded(child: SizedBox(height: 5.h)),
            const BotoesScanResult(),
            Expanded(child: SizedBox(height: 5.h)),
          ],
        ),
      ),
    ));
  }
}

class BotoesScanResult extends StatelessWidget {
  const BotoesScanResult({
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
            onPressed: () {
              context.go(AppRouterName.homeController);
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
                  style:
                      Styles().mediumTextStyle().copyWith(color: Colors.white),
                )
              ],
            )),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              context.push(AppRouterName.homeController);
            },
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                Container(width: 10.w),
                Text("Voltar", style: Styles().mediumTextStyle())
              ],
            )),
      ],
    );
  }
}

class CardEbotoes extends StatelessWidget {
  CardEbotoes({
    super.key,
  });
  ScreenshotController screenshotController = ScreenshotController();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
        Padding(
          padding: EdgeInsets.only(left: 40.w),
          child: Row(
            children: [
              WidgetQrCodeScreen(
                  titulo: "Patrimônio", valor: "123456", width: 100.w),
              SizedBox(width: 5.w),
              WidgetQrCodeScreen(
                titulo: "Lotação",
                valor: "DAGV",
                width: 100.w,
                readOnly: false,
              ),
              SizedBox(width: 5.w),
              WidgetQrCodeScreen(
                titulo: "Setor",
                valor: "Cartório",
                width: 100.w,
                readOnly: false,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WidgetQrCodeScreen(
                  titulo: "TAG", valor: "BH2239BH2239BH2239", width: 300.w)
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40.w, bottom: 8.h),
          child: Row(
            children: [
              WidgetQrCodeScreen(
                  titulo: "Levantamento", valor: "16/10/22", width: 90.w),
              Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: WidgetQrCodeScreen(
                    titulo: "Convênio", valor: "288/13", width: 100.w),
              ),
              WidgetQrCodeScreen(
                titulo: "Lacre",
                valor: "1212",
                width: 90.w,
                readOnly: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WidgetQrCodeScreen extends StatelessWidget {
  WidgetQrCodeScreen({
    super.key,
    required this.width,
    required this.valor,
    required this.titulo,
    this.readOnly,
    this.ctrl,
  });

  final double width;
  bool? readOnly;
  final String valor, titulo;
  final TextEditingController? ctrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
          readOnly: readOnly ?? true,
          style: Styles().mediumTextStyle(),
          initialValue: valor,
          decoration: InputDecoration(
              border: InputBorder.none,
              label: Text(
                titulo,
                style: Styles().subTitleDetail().copyWith(fontSize: 15.sp),
              ))),
    );
  }
}

class ButtonScanResult extends StatelessWidget {
  ButtonScanResult({
    super.key,
    required this.type,
    required this.icone,
  });

  final String type;
  final IconData icone;
  ScreenshotController screenshotController1 = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            switch (type) {
              case "Consultar":
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                        'Consultar para saber se existe mesmo esse produto',
                        style: Styles().errorTextStyle(),
                      ),
                      backgroundColor: AppColors.cErrorColor),
                );
                break;

              case "Partilhar":
                print(screenshotController1.toString());
                screenShotShare(screenshotController1);
                break;

              case "Atualizar":
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                        'Mudança de lotação, setor ou lacre',
                        style: Styles().errorTextStyle(),
                      ),
                      backgroundColor: AppColors.cErrorColor),
                );
                break;

              default:
            }
          },
          icon: Icon(icone),
          label: Text(
            type,
            style: Styles().mediumTextStyle(),
          )),
    );
  }

  void screenShotShare(ScreenshotController screenshotController) async {
    await screenshotController
        .captureFromWidget(const ScreenShoti())
        .then((value) async {
      Uint8List image = value;

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/captured.png').create();
      await imagePath.writeAsBytes(image);

      /// Share Plugin

      //    await Share.shareFiles([imagePath.path]);
      XFile imageFileAsXFile = XFile(imagePath.path);
      await Share.shareXFiles([imageFileAsXFile]);
    });
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
