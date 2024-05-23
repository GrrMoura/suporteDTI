// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/screens/widgets/widget_informacao.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class EquipamentoDetalhe extends StatelessWidget {
  const EquipamentoDetalhe({required this.equipamentoModel, super.key});
  final EquipamentoModel equipamentoModel;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScreenshotController screenshotController = ScreenshotController();

    return SizedBox(
      height: height,
      width: width,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          leading: Padding(
            padding: EdgeInsets.only(bottom: 30.h),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          backgroundColor: AppColors.cSecondaryColor,
          title: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: Text("Detalhes do equipamento",
                style: Styles()
                    .mediumTextStyle()
                    .copyWith(color: AppColors.cWhiteColor, fontSize: 20.sp)),
          ),
          centerTitle: true,
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ScreenShoti(model: equipamentoModel),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
      ),
    );
  }

  void screenShotShare(ScreenshotController screenshotController) async {
    await screenshotController
        .captureFromWidget(ScreenShoti(
      model: equipamentoModel,
    ))
        .then((value) async {
      Uint8List image = value;
      print("passou aqui");

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/captured.png').create();
      await imagePath.writeAsBytes(image);
      XFile imageFileAsXFile = XFile(imagePath.path);
      await Share.shareXFiles([imageFileAsXFile]);
    });
  }
}

class ScreenShoti extends StatelessWidget {
  //nome errado pq existe método igual
  const ScreenShoti({required this.model, super.key});
  final EquipamentoModel model;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 10.h),
          MarcaModelo(model: model),
          SizedBox(height: 10.h),
          DetalhesDetalhes(model: model),
          SizedBox(height: 10.h),
          ObservacoesDetalhe(model: model),
        ],
      ),
    );
  }
}

class ObservacoesDetalhe extends StatelessWidget {
  const ObservacoesDetalhe({required this.model, super.key});
  final EquipamentoModel model;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                model.numeroLacre == null || model.numeroLacre == ""
                    ? Container()
                    : InformacaoDetalhes(
                        informacao: model.numeroLacre!, titulo: "Lacre"),
                model.patrimonioSead == null || model.patrimonioSead == ""
                    ? Container()
                    : InformacaoDetalhes(
                        informacao: model.patrimonioSead!, titulo: "SEAD"),
                model.numeroLacre == null || model.numeroLacre == ""
                    ? Container()
                    : InformacaoDetalhes(
                        informacao: model.patrimonioSead!, titulo: "SEAD"),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                model.numeroLacre == null || model.numeroLacre == ""
                    ? Container()
                    : InformacaoDetalhes(
                        informacao: model.numeroLacre!, titulo: "Lacre"),
                model.patrimonioSead == null || model.patrimonioSead == ""
                    ? Container()
                    : InformacaoDetalhes(
                        informacao: model.patrimonioSead!, titulo: "SEAD"),
                model.numeroLacre == null || model.numeroLacre == ""
                    ? Container()
                    : InformacaoDetalhes(
                        informacao: model.patrimonioSead!, titulo: "SEAD"),
              ],
            )),
      ],
    );
  }
}

class DetalhesDetalhes extends StatelessWidget {
  const DetalhesDetalhes({
    required this.model,
    super.key,
  });
  final EquipamentoModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TituloDetalhe(titulo: "Detalhes"),
        Padding(
            padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
            child: InformacaoDetalhes(
                informacao: model.numeroSerie!, titulo: "TAG")),
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
        model.numeroLacre != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
                child: InformacaoDetalhes(
                    informacao: model.patrimonioSsp!, titulo: "Patrimônio"))
            : Container(),
        model.patrimonioSsp == null || model.patrimonioSsp == ""
            ? Container()
            : Padding(
                padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
                child: InformacaoDetalhes(
                    informacao: model.patrimonioSsp!, titulo: "Patrimônio")),
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
    required this.model,
    super.key,
  });
  final EquipamentoModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TituloDetalhe(titulo: "Equipamento"),
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
                  Text(model.tipoEquipamento!, style: Styles().titleDetail()),
                  SizedBox(height: 20.h),
                  Text("Fabricante", style: Styles().subTitleDetail()),
                  Text(model.fabricante!,
                      style: Styles().descriptionDetail().copyWith(
                          letterSpacing: AppDimens.espacamentoPequeno)),
                  SizedBox(height: 10.h),
                  Text("Modelo", style: Styles().subTitleDetail()),
                  FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: 120.w,
                        child: Text(model.modelo!,
                            style: Styles().descriptionDetail().copyWith(
                                fontSize:
                                    model.modelo!.length >= 15 ? 12.sp : 16)),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
