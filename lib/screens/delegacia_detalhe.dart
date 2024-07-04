// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/equipamento_controller.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/card_item.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

//
class DelegaciaDetalhe extends StatefulWidget {
  final String? sigla;
  final String? nome;
  final EquipamentoViewModel? model;
  const DelegaciaDetalhe(
      {this.sigla, this.model, super.key, required this.nome});

  @override
  State<DelegaciaDetalhe> createState() => _DelegaciaDetalheState();
}

class _DelegaciaDetalheState extends State<DelegaciaDetalhe> {
  ScrollController? scrollController;
  EquipamentoController equipamentoController = EquipamentoController();

  @override
  void initState() {
    setState(() {});
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController?.removeListener(_scrollListener);
    scrollController?.dispose();
    widget.model?.itensEquipamentoModels.equipamentos = [];
    widget.model?.paginacao?.pagina = 1;
    widget.model?.paginacao?.totalPaginas = 1;
    super.dispose();
  }

  // Controle do scroll: ao final do scroll é carregado novos elementos
  void _scrollListener() {
    if (scrollController?.position.pixels ==
        scrollController?.position.maxScrollExtent) {
      if (widget.model?.paginacao == null ||
          !widget.model!.paginacao!
              .seChegouAoFinalDaPagina(widget.model!.paginacao!.pagina!)) {
        setState(() {});

        equipamentoController
            .buscarEquipamentos(context, widget.model!)
            .then((value) {
          setState(() {});
        });
      } else {
        Generic.snackBar(
            context: context,
            mensagem: "A lista chegou ao fim.",
            tipo: AppName.info);
      }
    }
  }

  Widget _buildCard(ItemEquipamento itens) {
    return InkWell(
        onTap: () {
          equipamentoController
              .buscarEquipamentoPorId(context, itens)
              .then((value) {
            setState(() {});
          });
        },
        child: CardEquipamentosResultado(item: itens));
  }

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    setState(() {});
    FutureBuilder futureScreen() {
      return FutureBuilder(
          future:
              equipamentoController.buscarEquipamentos(context, widget.model!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Container(
                    color: Colors.white,
                  );
                } else if (!snapshot.hasData ||
                    (snapshot.data as List).isEmpty) {
                  return _listViewScreen();
                } else {
                  return _listViewScreen();
                }

              default:
                return const LoadingDefault();
            }
          });
    }

    return Validador.listNotNullAndNotEmpty(
            widget.model?.itensEquipamentoModels.equipamentos)
        ? _listViewScreen()
        : futureScreen();
  }

  Widget _listViewScreen() {
    double screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
              onPressed: () {
                widget.model?.paginacao?.pagina = 1;
                widget.model?.paginacao?.totalPaginas = 1;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
          title: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(widget.sigla ?? "",
                style: Styles().titleStyle().copyWith(
                    color: AppColors.cWhiteColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.normal)),
          ),
          centerTitle: true,
          backgroundColor: AppColors.cSecondaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250.w,
                      child:
                          Text(widget.nome!, style: Styles().smallTextStyle()),
                    ),
                  ],
                ),
              ),
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
                  children: [
                    DelegaciasCardLevantamento(
                        idUnidade: widget.model!.idUnidade!,
                        nome: "Juan Matos Silva",
                        id: "02",
                        data: "12/10/2023",
                        delegacia: "Resumo"),
                  ],
                ),
              ),
              widget.model?.itensEquipamentoModels.equipamentos.length != null
                  ? Titulos(
                      nome:
                          " ${widget.model?.itensEquipamentoModels.equipamentos.length} de ${widget.model?.paginacao!.registros} equipamentos  ")
                  : const Titulos(nome: "  Equipamentos "),
              _blocoEquipamento(screenWidth),
            ],
          ),
        ));
  }

  SizedBox _blocoEquipamento(double screenWidth) {
    return SizedBox(
      height: screenWidth - kToolbarHeight - 115.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 220,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15),
          controller: scrollController,
          itemCount: widget.model?.itensEquipamentoModels.equipamentos.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return _buildCard(
                widget.model!.itensEquipamentoModels.equipamentos[index]);
          },
        ),
      ),
    );
  }
}

class AddBotao extends StatelessWidget {
  const AddBotao({super.key});
// Função que mostra o AlertDialog com imagens como botões
  void mostrarAlertaComImagens(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
                  height: 100.w,
                  width: 95.w,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.pop('value');
                      context.push(AppRouterName.levantamentoDigitadoScreen);
                    },
                    child: Image.asset(
                      AppName.teclado!,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90.w,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.pop('value');
                      context.push(AppRouterName.qrCodeScanner);
                    },
                    child: Image.asset(AppName.qrCode!),
                  ),
                ),
              ],
            ),
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
  const DelegaciasCardLevantamento(
      {super.key,
      required this.nome,
      required this.id,
      required this.data,
      required this.delegacia,
      required this.idUnidade});

  final String nome;
  final String id;
  final String data;
  final String delegacia;
  final int idUnidade;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (delegacia == "Resumo") {
          context.push(AppRouterName.resumoLevantamento, extra: idUnidade);
        } else {
          debugPrint("buscandos os levantamentos");
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        child: Material(
          borderRadius: delegacia != "Resumo"
              ? const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
          elevation: 5,
          color: delegacia != "Resumo"
              ? AppColors.cSecondaryColor
              : AppColors.cSecondaryColor.withOpacity(0.6),
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
                          Styles().descriptionDelegaciasLevantamentoTextStyle(),
                    ),
                    Text(
                      delegacia,
                      style: Styles().mediumTextStyle().copyWith(
                          color: delegacia != "Resumo"
                              ? AppColors.cWhiteColor
                              : AppColors.cWhiteColor.withOpacity(0.7)),
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
                          Styles().descriptionDelegaciasLevantamentoTextStyle(),
                    ),
                    Text(
                      nome,
                      style:
                          Styles().descriptionDelegaciasLevantamentoTextStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                style: Styles().mediumTextStyle().copyWith(
                    color: Colors.black, fontSize: AppDimens.smallTextSize),
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
