// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suporte_dti/screens/widgets/widget_informacao.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class EquipamentoDetalhe extends StatelessWidget {
  const EquipamentoDetalhe({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScreenshotController screenshotController = ScreenshotController();

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      iconColor: Colors.black,
      shadowColor: Colors.grey,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "5 mais recentes",
            style: Styles().titleDetail(),
          ),
        ],
      ),
      content: SizedBox(
        height: 300,
        width: 150.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Levantamento - 16/10/2020', style: Styles().smallTextStyle()),
            Text('Levantamento - 16/10/2021', style: Styles().smallTextStyle()),
            Text('Levantamento - 16/10/2022', style: Styles().smallTextStyle()),
            Text('Levantamento - 16/10/2023', style: Styles().smallTextStyle()),
            Text('Levantamento - 16/10/2024', style: Styles().smallTextStyle()),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK',
              style: TextStyle(color: Colors.black, fontSize: 14.sp)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    return SizedBox(
      height: height,
      width: width,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          backgroundColor: AppColors.cSecondaryColor,
          title: Text("Detalhes do equipamento",
              style: Styles()
                  .mediumTextStyle()
                  .copyWith(color: AppColors.cWhiteColor)),
          centerTitle: true,
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const ScreenShoti(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                    icon: Icon(Icons.history, size: 30.sp),
                  ),
                  SizedBox(width: 10.w),
                  IconButton(
                      onPressed: () async {
                        screenShotShare(screenshotController);
                      },
                      icon: Icon(Icons.share, size: 30.sp))
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Levantado em: 16/10/2023", style: Styles().subTitleDetail()),
          ],
        ),
      ),
    );
  }

  void screenShotShare(ScreenshotController screenshotController) async {
    await screenshotController
        .captureFromWidget(const ScreenShoti())
        .then((value) async {
      Uint8List image = value;
      print("passou aqui");

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

class ScreenShoti extends StatelessWidget {
  const ScreenShoti({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 10.h),
          const MarcaModelo(),
          SizedBox(height: 10.h),
          const DetalhesDetalhes(),
          SizedBox(height: 10.h),
          const ObservacoesDetalhe(),
        ],
      ),
    );
  }
}

class ObservacoesDetalhe extends StatelessWidget {
  const ObservacoesDetalhe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text("Observações",
              style: Styles().titleDetail().copyWith(fontSize: 22.sp)),
        ),
        Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InformacaoDetalhes(informacao: "288/13", titulo: "Convênio"),
                InformacaoDetalhes(informacao: "1212", titulo: "Lacre"),
                InformacaoDetalhes(informacao: "xxxx", titulo: "Outro"),
              ],
            )),
      ],
    );
  }
}

class DetalhesDetalhes extends StatelessWidget {
  const DetalhesDetalhes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TituloDetalhe(titulo: "Detalhes"),
        Padding(
            padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
            child: const InformacaoDetalhes(
                informacao: "CN0N2D7T74444545TAABS", titulo: "TAG")),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InformacaoDetalhes(titulo: "Lotaçao", informacao: "Capela"),
              InformacaoDetalhes(titulo: "Setor", informacao: "Cartório")
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
            child: const InformacaoDetalhes(
                informacao: "149892", titulo: "Patrimônio")),
      ],
    );
  }
}

class TituloDetalhe extends StatelessWidget {
  const TituloDetalhe({
    required this.titulo,
    super.key,
  });

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 5.h),
      child:
          Text(titulo, style: Styles().titleDetail().copyWith(fontSize: 22.sp)),
    );
  }
}

class MarcaModelo extends StatelessWidget {
  const MarcaModelo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TituloDetalhe(titulo: "Equipamentos"),
        Padding(
          padding: EdgeInsets.only(top: 5.h, left: 20.w, right: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Material(
                  color: AppColors.cWhiteColor,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  shadowColor: Colors.grey,
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 5.w),
                        child: Image.asset("assets/images/impressora.png",
                            height: 150.h),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Estabilizador", style: Styles().titleDetail()),
                  SizedBox(height: 20.h),
                  Text("Marca", style: Styles().subTitleDetail()),
                  Text("DELL",
                      style: Styles().descriptionDetail().copyWith(
                          letterSpacing: AppDimens.espacamentoPequeno)),
                  SizedBox(height: 10.h),
                  Text("Modelo", style: Styles().subTitleDetail()),
                  Text("P2422HB", style: Styles().descriptionDetail()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
