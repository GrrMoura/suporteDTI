import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/equipamento_controller.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/card_item.dart';

import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class ResultadoEquipamentoConsultaScreen extends StatefulWidget {
  final EquipamentoViewModel? model;
  const ResultadoEquipamentoConsultaScreen({super.key, this.model});

  @override
  State<ResultadoEquipamentoConsultaScreen> createState() =>
      _ResultadoEquipamentoConsultaScreenState();
}

class _ResultadoEquipamentoConsultaScreenState
    extends State<ResultadoEquipamentoConsultaScreen> {
  ScrollController? _scrollController;
  bool isLoading = false;
  EquipamentoController equipamentoController = EquipamentoController();
  EquipamentoViewModel? model = EquipamentoViewModel(
      itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []));

  @override
  void initState() {
    setState(() {});
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  // Controle do scroll: ao final do scroll é carregado novos elementos
  void _scrollListener() {
    if (_scrollController?.position.pixels ==
        _scrollController?.position.maxScrollExtent) {
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
            mensagem: "Não há mais itens.",
            tipo: AppName.info);
      }
    }
  }

  Widget _buildCard(ItemEquipamento item) {
    return InkWell(
        onTap: () {
          equipamentoController
              .buscarEquipamentoPorId(context, item)
              .then((value) {
            setState(() {});
          });
        },
        child: CardEquipamentosResultado(item: item));
  }

  Widget _listViewScreen() {
    double screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.cWhiteColor,
      appBar: AppBar(
        title: Text(
          "Resultado",
          style: TextStyle(color: Colors.white, fontSize: 22.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cSecondaryColor,
        leading: IconButton(
            onPressed: () {
              context.push(AppRouterName.homeController);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10.h),
          //  searchBar(context, isLoading, 50),
          widget.model!.itensEquipamentoModels.equipamentos.isNotEmpty
              ? SizedBox(
                  height: screenWidth - kToolbarHeight - 50.h,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 220,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15),
                      controller: _scrollController,
                      itemCount: widget
                          .model?.itensEquipamentoModels.equipamentos.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return _buildCard(widget
                            .model!.itensEquipamentoModels.equipamentos[index]);
                      },
                    ),
                  ),
                )
              : Container(),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 5.h),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         widget.model!.paginacao!.registros! <= 10
          //             ? "${widget.model!.paginacao!.registros!} "
          //             : "${widget.model!.paginacao!.pagina! * 10}  ",
          //         style: Styles().smallTextStyle(),
          //       ),
          //       Text(
          //         "Total de ${widget.model!.paginacao!.registros} equipamentos",
          //         style: Styles().smallTextStyle(),
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    FutureBuilder _futureScreen() {
      return FutureBuilder(
          future:
              equipamentoController.buscarEquipamentos(context, widget.model!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return _listViewScreen();

              default:
                return const LoadingDefault();
            }
          });
    }

    return Validador.listNotNullAndNotEmpty(
            widget.model?.itensEquipamentoModels.equipamentos)
        ? _listViewScreen()
        : _futureScreen();
  }

  Padding searchBar(BuildContext context, bool ocupado, double? height) {
    return Padding(
      padding:
          EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w, bottom: 10.h),
      child: TextFormField(
        style: Styles().mediumTextStyle(),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: ((valor) async {
          if (valor.isNotEmpty) {
            if (context.mounted) {
              setState(() {
                model!.itensEquipamentoModels.equipamentos = [];
                model!.descricao = valor;
                isLoading = true;
              });

              //   await equipamentoController.buscarEquipamentos(context, model!);

              setState(() {
                isLoading = false;
                // if (model!.itensEquipamentoModels.equipamentos.isEmpty) {

                // }
              });
            } else {
              Generic.snackBar(
                context: context,
                mensagem: "Tente novamente",
              );
            }
          } else {
            Generic.snackBar(
              context: context,
              mensagem: "O campo \"pesquisa\" precisa ser preenchido!",
            );
          }
        }),
        decoration: InputDecoration(
          fillColor: AppColors.cWhiteColor,
          filled: true,
          isDense: true,
          hintText: 'Patrimônio, Tag, SEAD ',
          hintStyle: Styles().hintTextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          prefixIcon: Icon(Icons.search,
              size: 25.sp, color: AppColors.cDescriptionIconColor),
        ),
      ),
    );
  }
}
