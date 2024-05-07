import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/widget_gridview_itens.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

class ResultDelegacia extends StatefulWidget {
  const ResultDelegacia({super.key});

  @override
  State<StatefulWidget> createState() => ResultDelegaciaState();
}

class ResultDelegaciaState extends State {
  final List<Map> myProducts2 = List.generate(
      10,
      (index) => {
            "id": index,
            "name": "Produto $index",
          }).toList();

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          automaticallyImplyLeading: true,
          title: Text("CAPELA",
              style: Styles().titleStyle().copyWith(
                  color: AppColors.cWhiteColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.normal)),
          centerTitle: true,
          backgroundColor: AppColors.cSecondaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Titulos(nome: "  Levantamentos  "),
                  AddBotao(),
                ],
              ),
              SizedBox(
                height: 350.h,
                child: ListView(
                  children: const [
                    DelegaciasCardLevantamento(
                        nome: "Juan Matos Silva",
                        id: "02",
                        data: "12/10/2023",
                        delegacia: "Delegacia de Capela"),
                    DelegaciasCardLevantamento(
                        nome: "Juan Matos Silva",
                        id: "01",
                        data: "12/10/2023",
                        delegacia: "Delegacia de Capela"),
                    DelegaciasCardLevantamento(
                        nome: "Juan Matos Silva",
                        id: "02",
                        data: "12/10/2023",
                        delegacia: "Delegacia de Capela"),
                    DelegaciasCardLevantamento(
                        nome: "Juan Matos Silva",
                        id: "01",
                        data: "12/10/2023",
                        delegacia: "Delegacia de Capela"),
                    DelegaciasCardLevantamento(
                        nome: "Juan Matos Silva",
                        id: "02",
                        data: "12/10/2023",
                        delegacia: "Delegacia de Capela"),
                  ],
                ),
              ),
              const Titulos(nome: "  Equipamentos  "),
              GridviewEquipamentos(
                myProducts: myProducts2,
                widget: const CardItensDelegacia(
                  marcaModelo: "HP/Z220 Work Station",
                  lotacao: "Sala do Diretor",
                  patrimonio: "172671",
                ),
              ),
            ],
          ),
        ));
  }
}

class AddBotao extends StatelessWidget {
  const AddBotao({super.key});
// Função que mostra o AlertDialog com imagens como botões
  void mostrarAlertaComImagens(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(child: Text('Forma de criação')),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Selecione como quer iniciar.'),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  height: 85,
                  width: 85,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.push(AppRouterName.levantamentoDigitadoScreen);
                    },
                    child: Image.asset(
                      AppName.teclado!,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.push(AppRouterName.qrCodeScanner);
                    },
                    child: Image.asset(AppName.qrCode!),
                  ),
                ),
              ],
            ),
            // Botão com imagem 2
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        mostrarAlertaComImagens(context);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: Container(
          height: 30.h,
          width: 30.w,
          decoration: const BoxDecoration(
              color: AppColors.cSecondaryColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0.0, 2.0), //(x,y)
                    blurRadius: 6.0)
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("assets/images/add.png"),
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  fit: BoxFit.contain)),
        ),
      ),
    );
  }
}

class DelegaciasCardLevantamento extends StatelessWidget {
  const DelegaciasCardLevantamento({
    super.key,
    required this.nome,
    required this.id,
    required this.data,
    required this.delegacia,
  });

  final String nome;
  final String id;
  final String data;
  final String delegacia;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Material(
        borderRadius: id == "02"
            ? const BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))
            : const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
        elevation: 5,
        color: id == "02"
            ? AppColors.cSecondaryColor
            : AppColors.cSecondaryColor.withOpacity(0.8),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    id,
                    style:
                        Styles().DescriptionDelegaciasLevantamentoTextStyle(),
                  ),
                  Text(
                    delegacia,
                    style: Styles()
                        .mediumTextStyle()
                        .copyWith(color: AppColors.cWhiteColor),
                  ),
                  const Icon(Icons.remove_red_eye, color: Colors.white70)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    data,
                    style:
                        Styles().DescriptionDelegaciasLevantamentoTextStyle(),
                  ),
                  Text(
                    nome,
                    style:
                        Styles().DescriptionDelegaciasLevantamentoTextStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Titulos extends StatelessWidget {
  const Titulos({required this.nome, super.key});
  final String nome;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: IntrinsicWidth(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.fiber_manual_record, size: 12.sp),
              Text(
                nome,
                style: Styles().mediumTextStyle().copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardItensDelegacia extends StatefulWidget {
  const CardItensDelegacia(
      {this.lotacao, this.patrimonio, this.marcaModelo, super.key});

  final String? patrimonio, lotacao, marcaModelo;

  @override
  State<CardItensDelegacia> createState() => _CardItensDelegaciaState();
}

class _CardItensDelegaciaState extends State<CardItensDelegacia> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: widget.patrimonio!));
        Generic.snackBar(
            tipo: AppName.sucesso,
            context: context,
            mensagem: "Copiado para área de transferência!");
      },
      child: Material(
        color: AppColors.cWhiteColor,
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.marcaModelo!, style: Styles().smallTextStyle()),
            Image.asset("assets/images/impressora.png", height: 70.h),
            Text(widget.patrimonio!, style: Styles().smallTextStyle()),
            Text(widget.lotacao!, style: Styles().hintTextStyle()),
          ],
        ),
      ),
    );
  }
}
