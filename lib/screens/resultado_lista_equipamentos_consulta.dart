import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/consulta_controller.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/card_item.dart';

import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
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
  var consultaController = ConsultaController();
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
          // setState(() {});
          consultaController
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
          SizedBox(
            height: 60.h,
            child: Stack(
              children: [
                Container(
                  height: 115.h,
                  width: double.infinity,
                  color: AppColors.cSecondaryColor,
                ),
                Positioned(
                    left: 125.w,
                    right: 125.w,
                    top: 0.h,
                    child: Text(
                      "Resultadoo",
                      style: TextStyle(color: Colors.white, fontSize: 22.sp),
                    )),
              ],
            ),
          ),
          SizedBox(
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
    // ignore: no_leading_underscores_for_local_identifiers
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
            widget.model?.itensEquipamentoModels.equipamentos)
        ? _listViewScreen()
        : _futureScreen();
  }

  void validateInput(value) {
    value = value.toUpperCase().replaceAll(' ', '');
    if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      model!.idTipoEquipamento = value; // euqipamento
    } else if (RegExp(r'^\d{1,7}$').hasMatch(value)) {
      model!.patrimonioSSP = value;
    } else if (RegExp(r'^SEAD\d+$').hasMatch(value)) {
      model!.patrimonioSead = value.replaceAll(RegExp(r'^SEAD'), '');
    } else if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      model!.numeroSerie = value;
    } else {
      Generic.snackBar(context: context, mensagem: 'Padrão inválido');
    }
  }

  Future<bool> checkConflict(BuildContext context, String input) async {
    input = input.replaceAll(' ', '');
    if (RegExp(r'^\d{1,7}$').hasMatch(input) &&
        RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input)) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.cWhiteColor,
            title: const Text(
              'Está entrada é ?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.of(context).pop(AppName.patri);
                },
                child: Text(AppName.patri!,
                    style: const TextStyle(color: AppColors.contentColorBlack)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.of(context).pop(AppName.nSerie);
                },
                child: Text(AppName.nSerie!,
                    style: const TextStyle(color: AppColors.contentColorBlack)),
              ),
            ],
          );
        },
      ).then((value) {
        if (value != null) {
          if (value == AppName.nSerie) {
            model!.patrimonioSSP = "";
            model!.numeroSerie = input;
            model!.patrimonioSead = "";
          } else {
            model!.patrimonioSSP = input;
            model!.numeroSerie = "";
            model!.patrimonioSead = "";
          }
        } else {}
      });
      return true;
    } else {
      return false;
    }
  }
}
