import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/screens/widgets/widget_informacao.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class EquipamentoDetalhe extends StatelessWidget {
  const EquipamentoDetalhe({super.key, required this.equipamentoModel});

  final EquipamentoModel equipamentoModel;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              // screenShotShare(context);
            },
            icon: Icon(Icons.share, size: 20.sp, color: Colors.white),
          ),
        ],
        backgroundColor: AppColors.cSecondaryColor,
        title: Text(
          "Detalhes do Equipamento",
          style: Styles()
              .mediumTextStyle()
              .copyWith(color: AppColors.cWhiteColor, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Screenshot(
        controller: ScreenshotController(),
        child: ScreenShoti(model: equipamentoModel, height: height),
      ),
    );
  }

  // void screenShotShare(BuildContext context) async {
  //   try {
  //     Uint8List? image = await Screenshot.capture(
  //       context,
  //       pixelRatio: 2.0,
  //       delay: Duration(milliseconds: 10),
  //     );

  //     if (image != null) {
  //       final directory = await getApplicationDocumentsDirectory();
  //       final imagePath = await File('${directory.path}/captured.png').create();
  //       await imagePath.writeAsBytes(image);

  //       XFile imageFileAsXFile = XFile(imagePath.path);
  //       await Share.shareXFiles([imageFileAsXFile]);
  //     } else {
  //       print("Failed to capture screenshot.");
  //     }
  //   } catch (e) {
  //     print("Error while capturing and sharing screenshot: $e");
  //   }
  // }
}

class ScreenShoti extends StatelessWidget {
  const ScreenShoti({super.key, required this.model, required this.height});

  final EquipamentoModel model;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: height - kToolbarHeight - 50,
        child: ListView(
          children: [
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              decoration: const BoxDecoration(
                color: AppColors.cSecondaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: MarcaModelo(model: model),
            ),
            SizedBox(height: 20.h),
            DetalhesDetalhes(model: model),
            SizedBox(height: 20.h),
            ObservacoesDetalhe(model: model),
            SizedBox(height: 20.h),
            if (model.alocacoes!.isNotEmpty) UltimaAlocacao(model: model),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class MarcaModelo extends StatelessWidget {
  const MarcaModelo({super.key, required this.model});

  final EquipamentoModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DetalheTitulo("Tipo", '1'),
              DetalheValor(model.tipoEquipamento!),
              const DetalheTitulo("Fabricante", '1'),
              DetalheValor(model.fabricante!),
              const DetalheTitulo("Modelo", '1'),
              DetalheValor(model.modelo!),
            ],
          ),
        ),
        SizedBox(width: 20.w),
        Material(
          color: AppColors.cWhiteColor,
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AppName.fotoEquipamento(model.tipoEquipamento!),
              height: 140.h,
              width: 100.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class DetalhesDetalhes extends StatelessWidget {
  const DetalhesDetalhes({super.key, required this.model});

  final EquipamentoModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DetalheTitulo("Detalhes", "2"),
          model.numeroSerie != null
              ? DetalheInformacao(model.numeroSerie!, "TAG")
              : Container(),
          model.patrimonioSsp != null
              ? DetalheInformacao(model.patrimonioSsp!, "Patrimônio SSP")
              : Container(),
          model.dataCompra == null || model.dataCompra!.isEmpty
              ? Container()
              : DetalheInformacao(model.dataCompra!, "Data da compra"),
          SizedBox(height: 10.h),
          DetalheUnidadeAtual(model.unidadeAtual!),
        ],
      ),
    );
  }
}

class ObservacoesDetalhe extends StatelessWidget {
  const ObservacoesDetalhe({super.key, required this.model});

  final EquipamentoModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetalheTitulo("Observações", '3'),
          model.numeroLacre != null || model.patrimonioSead != null
              ? Padding(
                  padding: EdgeInsets.only(bottom: 80.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (model.numeroLacre != null &&
                          model.numeroLacre!.isNotEmpty)
                        InformacaoDetalhes(
                          informacao: model.numeroLacre!,
                          titulo: "Lacre",
                        ),
                      SizedBox(width: 10.w),
                      if (model.patrimonioSead != null &&
                          model.patrimonioSead!.isNotEmpty)
                        InformacaoDetalhes(
                          informacao: model.patrimonioSead!,
                          titulo: "SEAD",
                        ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sem observação.",
                        style: Styles()
                            .descriptionDetail()
                            .copyWith(fontSize: 15.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class UltimaAlocacao extends StatelessWidget {
  const UltimaAlocacao({super.key, required this.model});

  final EquipamentoModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Última alocação: ${model.alocacoes![0].dataAlocacao.toString()}",
            style: Styles().subTitleDetail(),
          ),
          Text(
            "por ${model.alocacoes![0].usuarioAlocacao}",
            style: Styles().subTitleDetail(),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class DetalheTitulo extends StatelessWidget {
  final String titulo;
  final String? box;

  const DetalheTitulo(this.titulo, this.box, {super.key});

  @override
  Widget build(BuildContext context) {
    switch (box) {
      // para trocar stilo do primeiro box
      case '1':
        return Padding(
          padding: EdgeInsets.only(left: 10.w, top: 5.h),
          child: Text(
            titulo,
            style: Styles()
                .titleDetail()
                .copyWith(fontSize: 20.sp, color: Colors.white),
          ),
        );

      default:
        return Text(
          titulo,
          style: Styles().titleDetail().copyWith(fontSize: 20.sp),
        );
    }
  }
}

class DetalheValor extends StatelessWidget {
  final String valor;

  const DetalheValor(this.valor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Text(
        valor,
        style: Styles().descriptionDetail().copyWith(
              color: Colors.white70,
              letterSpacing: AppDimens.espacamentoPequeno,
              fontSize: valor.length >= 15 ? 12.sp : 16.sp,
            ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class DetalheInformacao extends StatelessWidget {
  final String informacao;
  final String titulo;

  const DetalheInformacao(this.informacao, this.titulo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: Styles().subTitleDetail().copyWith(color: Colors.black87)),
          Text(informacao,
              style: Styles()
                  .descriptionDetail()
                  .copyWith(fontSize: informacao.length >= 15 ? 15 : 20)),
        ],
      ),
    );
  }
}

class DetalheUnidadeAtual extends StatelessWidget {
  final String unidadeAtual;

  const DetalheUnidadeAtual(this.unidadeAtual, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetalheTitulo("Lotação", '4'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 320.w,
              child: Text(
                unidadeAtual,
                style: Styles().descriptionDetail().copyWith(
                      letterSpacing: AppDimens.espacamentoPequeno,
                      fontSize: unidadeAtual.length > 16 ? 15.sp : 20.sp,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
