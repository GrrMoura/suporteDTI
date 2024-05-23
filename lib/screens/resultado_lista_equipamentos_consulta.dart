import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/consulta_controller.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/card_item.dart';

import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class EquipamentoConsultaScreen extends StatefulWidget {
  final EquipamentoViewModel? model;
  const EquipamentoConsultaScreen({super.key, this.model});

  @override
  State<EquipamentoConsultaScreen> createState() =>
      _EquipamentoConsultaScreenState();
}

class _EquipamentoConsultaScreenState extends State<EquipamentoConsultaScreen> {
  ScrollController? _scrollController;
  var consultaController = ConsultaController();

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
          !widget.model!.paginacao!.seChegouAoFinalDaPagina()) {
        setState(() {
          widget.model?.itensEquipamentoModels.equipamentos = [];
        });

        consultaController
            .buscarEquipamentos(context, widget.model!)
            .then((value) {
          setState(() {});
        });
      }
    }
  }

  Widget _buildCard(ItemEquipamento item) {
    return InkWell(
        onTap: () {
          setState(() {});
          consultaController
              .buscarEquipamentoPorId(context, item)
              .then((value) {
            setState(() {});
          });
        },
        child: CardEquipamentosResultado(
          item: item,
        ));

    //    Column(children: <Widget>[
    //     Container(
    //       padding: const EdgeInsets.all(10.0),
    //       child: Row(children: <Widget>[
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Text(
    //                 item.descricao!,
    //                 style: Styles().descriptionDetail(),
    //               ),
    //               Text(item.patrimonioSead ?? "")
    //             ],
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 28,
    //           child: Icon(
    //             Icons.arrow_forward_ios,
    //             size: 16,
    //           ),
    //         ),
    //       ]),
    //     ),
    //     const Divider(
    //       color: Colors.amber,
    //     )
    //   ]),
    // );
  }

  Widget _listViewScreen() {
    double screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.cWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.cSecondaryColor,
        leading: IconButton(
            onPressed: () {
              context.push(AppRouterName.homeController);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {});
      }),
      body: ListView(
        children: [
          const BoxSearchBar(),
          SizedBox(
            height: screenWidth - kToolbarHeight - 160.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 220,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                controller: _scrollController,
                itemCount:
                    widget.model?.itensEquipamentoModels.equipamentos.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return _buildCard(
                      widget.model!.itensEquipamentoModels.equipamentos[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder _futureScreen() {
      return FutureBuilder(
          future: consultaController.buscarEquipamentos(context, widget.model!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Validador.listNotNullAndNotEmpty(
                        widget.model?.itensEquipamentoModels.equipamentos)
                    ? _listViewScreen()
                    : const LoadingDefault(); // TALVEZ DE ERRO.

              default:
                return const LoadingDefault();
            }
          });
    }

    return Validador.listNotNullAndNotEmpty(
            widget.model?.itensEquipamentoModels?.equipamentos)
        ? _listViewScreen()
        : _futureScreen();
  }
}

class BoxSearchBar extends StatelessWidget {
  const BoxSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: Stack(
        children: [
          Container(
            height: 115.h,
            width: double.infinity,
            color: AppColors.cSecondaryColor,
          ),
          Positioned(
              left: 140.w,
              top: 70.h,
              child: Text(
                "Resultado",
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              )),
          Positioned(
            left: 30.w,
            right: 30.w,
            bottom: 80.h,
            child: SearchBar(
              textStyle: MaterialStateProperty.all(
                Styles().mediumTextStyle(),
              ),
              side: MaterialStateProperty.all(
                const BorderSide(color: Colors.grey),
              ),
              elevation: MaterialStateProperty.all(10),
              trailing: [
                IconButton(
                    icon: Icon(Icons.close, size: 22.sp), onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.tune, size: 22.sp), onPressed: () {}),
              ],
              leading: Icon(Icons.search, size: 22.sp),
              backgroundColor: MaterialStateProperty.all(AppColors.cWhiteColor),
              constraints: BoxConstraints(maxWidth: 300.w),
              shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
