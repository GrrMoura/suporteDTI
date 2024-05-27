// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/screens/widgets/widget_informacao.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
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
              actions: [
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: IconButton(
                      onPressed: () async {
                        screenShotShare(screenshotController);
                      },
                      icon:
                          Icon(Icons.share, size: 20.sp, color: Colors.white)),
                )
              ],
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
                    style: Styles().mediumTextStyle().copyWith(
                        color: AppColors.cWhiteColor, fontSize: 18.sp)),
              ),
              centerTitle: true,
            ),
            body: Screenshot(
              controller: screenshotController,
              child: ScreenShoti(model: equipamentoModel),
            )));
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
        children: [
          SizedBox(height: 30.h),
          MarcaModelo(model: model),
          SizedBox(height: 10.h),
          DetalhesDetalhes(model: model),
          SizedBox(height: 10.h),
          ObservacoesDetalhe(model: model),
          const Expanded(child: SizedBox(height: 10)),
          model.alocacoes!.isEmpty ? const Text("") : ultimaAlocacao()
        ],
      ),
    );
  }

  Padding ultimaAlocacao() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Última alocação: ${model.alocacoes![0].dataAlocacao.toString()}",
              style: Styles().subTitleDetail()),
          Text(" por ${model.alocacoes![0].usuarioAlocacao}",
              style: Styles().subTitleDetail().copyWith(
                    overflow: TextOverflow.ellipsis,
                  )),
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
              style: Styles().titleDetail().copyWith(fontSize: 20.sp)),
        ),
        Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //lacre
                model.numeroLacre == null || model.numeroLacre == ""
                    ? Container()
                    : InformacaoDetalhes(
                        informacao: model.numeroLacre!, titulo: "Lacre"),
                //sead
                model.patrimonioSead == null || model.patrimonioSead == ""
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
                        child: InformacaoDetalhes(
                            informacao: model.patrimonioSead!, titulo: "SEAD")),
              ],
            )),
      ],
    );
  }
}

class DetalhesDetalhes extends StatelessWidget {
  const DetalhesDetalhes({required this.model, super.key});
  final EquipamentoModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TituloDetalhe(titulo: "Detalhes"),
        //serie
        model.numeroSerie == null || model.numeroSerie == ""
            ? Container()
            : Padding(
                padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
                child: InformacaoDetalhes(
                    informacao: model.numeroSerie!, titulo: "TAG")),

        //patrimonio
        model.patrimonioSsp == null || model.patrimonioSsp == ""
            ? Container()
            : Padding(
                padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
                child: InformacaoDetalhes(
                    informacao: model.patrimonioSsp!, titulo: "Patrimônio")),

        //data compra
        model.dataCompra == null || model.dataCompra == ""
            ? Container()
            : Padding(
                padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
                child: InformacaoDetalhes(
                    informacao: model.patrimonioSsp!,
                    titulo: "Data da compra")),
        unidadeAtual(),
      ],
    );
  }

  Padding unidadeAtual() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          model.unidadeAtual == null || model.unidadeAtual == ""
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lotação", style: Styles().subTitleDetail()),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: 250.w,
                          child: Text(model.unidadeAtual!,
                              style: Styles().descriptionDetail().copyWith(
                                  letterSpacing: AppDimens.espacamentoPequeno,
                                  fontSize: model.unidadeAtual!.length > 16
                                      ? 15
                                      : 20)),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class TituloDetalhe extends StatelessWidget {
  const TituloDetalhe({required this.titulo, super.key});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 5.h),
      child:
          Text(titulo, style: Styles().titleDetail().copyWith(fontSize: 20.sp)),
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
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: AppColors.cWhiteColor,
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                shadowColor: Colors.grey,
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Image.asset(
                          AppName.fotoEquipamento(model.tipoEquipamento!),
                          height: 140.h),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tipo", style: Styles().subTitleDetail()),
                  Text(model.tipoEquipamento!,
                      style: Styles().descriptionDetail()),
                  SizedBox(height: 15.h),
                  Text("Fabricante", style: Styles().subTitleDetail()),
                  Text(model.fabricante!,
                      style: Styles().descriptionDetail().copyWith(
                          letterSpacing: AppDimens.espacamentoPequeno)),
                  SizedBox(height: 15.h),
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
