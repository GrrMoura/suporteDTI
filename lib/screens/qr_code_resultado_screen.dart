import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/equipamento_detalhe_screen.dart';
import 'package:suporte_dti/screens/widgets/app_bar.dart';
import 'package:suporte_dti/screens/widgets/aux_app_bar.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

class QrCodeResult extends StatefulWidget {
  const QrCodeResult({super.key});

  @override
  State<QrCodeResult> createState() => _QrCodeResultState();
}

class _QrCodeResultState extends State<QrCodeResult> {
  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: GenericAppBar(context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GeneriAuxAppBar(titulo: "Resultado QrCode"),
            //     const HeadingScanResult(),
            const TopoScanResult(),
            Container(height: 10.h),
            CardEbotoes(),
            Container(height: 40.h),
            const BotoesScanResult(),
          ],
        ),
      ),
    );
  }
}

class BotoesScanResult extends StatelessWidget {
  const BotoesScanResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.cSecondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
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
                style: Styles().mediumTextStyle().copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            context.push(AppRouterName.homeController);
          },
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              Container(width: 10.w),
              Text("Voltar", style: Styles().mediumTextStyle()),
            ],
          ),
        ),
      ],
    );
  }
}

class CardEbotoes extends StatelessWidget {
  CardEbotoes({super.key});

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              //  Adicionar botões se necessário
              ButtonScanResult(icone: Icons.search, type: "Consultar"),
              ButtonScanResult(icone: Icons.share, type: "Partilhar"),
              ButtonScanResult(icone: Icons.add_box_rounded, type: "Levantar"),
            ],
          ),
        ),
      ],
    );
  }
}

//TODO: FALTA CRIAR O QRCODE, LER E JOGAR OS DADOS AQUI VINDO DO LEITOR.
//ADICIONAR AS FUNÇÕES AOS BOTOES
class TopoScanResult extends StatelessWidget {
  const TopoScanResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              WidgetQrCodeScreen(
                  titulo: "Patrimônio", valor: "123456", width: 100.w),
              WidgetQrCodeScreen(
                  titulo: "Convênio", valor: "288/13", width: 100.w),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WidgetQrCodeScreen(
                titulo: "N° Série",
                valor: "BH2239BH2239BH2239",
                width: 300.w,
              ),
            ],
          ),
          WidgetQrCodeScreen(
              titulo: "Lotação",
              valor: "01ª DELEGACIA METROPOLITANA ",
              width: 400.w,
              readOnly: false),
        ],
      ),
    );
  }
}

class WidgetQrCodeScreen extends StatelessWidget {
  const WidgetQrCodeScreen({
    super.key,
    required this.width,
    required this.valor,
    required this.titulo,
    this.readOnly,
    this.ctrl,
  });

  final double width;
  final bool? readOnly;
  final String valor, titulo;
  final TextEditingController? ctrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        readOnly: readOnly ?? true,
        style: Styles()
            .mediumTextStyle()
            .copyWith(overflow: TextOverflow.ellipsis),
        initialValue: valor,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(
            titulo,
            style: Styles().subTitleDetail().copyWith(fontSize: 15.sp),
          ),
        ),
      ),
    );
  }
}

class ButtonScanResult extends StatelessWidget {
  ButtonScanResult({
    super.key,
    required this.type,
    required this.icone,
    // required this.model,
  });

  final String type;
  //final EquipamentoModel model;
  final IconData icone;
  final ScreenshotController screenshotController1 = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          switch (type) {
            case "Consultar":
              Generic.snackBar(
                mensagem: 'Consultar para saber se existe mesmo esse produto',
                context: context,
              );
              break;
            case "Partilhar":
              //      screenShotShare(screenshotController1);
              break;
            case "Atualizar":
              Generic.snackBar(
                context: context,
                mensagem: 'Mudança de lotação, setor ou lacre',
              );
              break;
            default:
          }
        },
        icon: Icon(icone),
        label: Text(
          type,
          style: Styles().mediumTextStyle(),
        ),
      ),
    );
  }

  void screenShotShare(
      ScreenshotController screenshotController, EquipamentoModel model) async {
    await screenshotController
        .captureFromWidget(ScreenShoti(
      model: model,
    ))
        .then((value) async {
      Uint8List image = value;

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/captured.png').create();
      await imagePath.writeAsBytes(image);

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cPrimaryColor, AppColors.cSecondaryColor],
        ),
      ),
      height: 160.h,
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Scan Completo",
              style: Styles().titleStyle().copyWith(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Lotação",
                    style:
                        Styles().subTitleStyle().copyWith(color: Colors.white)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text("-",
                      style: Styles()
                          .subTitleStyle()
                          .copyWith(color: Colors.white)),
                ),
                Text("DAGV",
                    style:
                        Styles().subTitleStyle().copyWith(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardViewResultScan extends StatelessWidget {
  const CardViewResultScan({
    required this.lotacao,
    required this.patrimonio,
    required this.tag,
    required this.marca,
    required this.modelo,
    super.key,
  });

  final String? patrimonio, lotacao, tag, marca, modelo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
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
                child: Image.asset(AppName.cpu!, height: 70.h),
              ),
              InfomacaoScanResult(informacao: patrimonio, tipo: "Patrimônio"),
              Padding(
                padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("TAG", style: Styles().hintTextStyle()),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: Text(
                        "BROAHDO2S2S3GA23332HHP2",
                        style: Styles().descriptionRestulScan(),
                      ),
                    ),
                  ],
                ),
              ),
              InfomacaoScanResult(informacao: lotacao, tipo: "Lotação"),
            ],
          ),
        ),
      ),
    );
  }
}

class InfomacaoScanResult extends StatelessWidget {
  const InfomacaoScanResult({
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
