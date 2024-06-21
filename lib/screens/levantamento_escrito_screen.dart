// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/consulta_controller.dart';
import 'package:suporte_dti/data/sqflite_helper.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class LevantamentoDigitado extends StatefulWidget {
  const LevantamentoDigitado({super.key});

  @override
  State<LevantamentoDigitado> createState() => _LevantamentoDigitadoState();
}

class _LevantamentoDigitadoState extends State<LevantamentoDigitado> {
  ScrollController? _scrollController;

  var consultaController = ConsultaController();
  EquipamentoViewModel? model = EquipamentoViewModel(
      itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []));

  @override
  void dispose() {
    model!.ocupado = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.cWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.cSecondaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  model!.ocupado = false;
                  context.pop("value");
                },
                icon: const Icon(Icons.arrow_back_ios)),
            model!.ocupado == true
                ? Text("Levantamento",
                    style: TextStyle(color: Colors.white, fontSize: 20.sp))
                : const Text(""),
            IconButton(
                onPressed: () {
                  setState(() {});
                  //context.push(AppRouterName.homeController);
                },
                icon: const Icon(Icons.home)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: model!.ocupado == true
          ? const LoadingDefault()
          : ListView(
              children: [
                SizedBox(
                  height: 40.h,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: AppColors.cSecondaryColor,
                      ),
                      Positioned(
                          left: 115.w,
                          right: 90.w,
                          top: 0.h,
                          child: Text(
                            "Levantamento",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22.sp),
                          )),
                    ],
                  ),
                ),
                // SizedBox(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [
                //         searchBar(context, model?.ocupado ?? false, height),
                //       ],
                //     ),
                //   ),
                // ),

                searchBar(context, model?.ocupado ?? false, height),

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  child: Container(
                    height: height - kToolbarHeight - 140.h,
                    decoration: BoxDecoration(
                        color:
                            model!.itensEquipamentoModels.equipamentos.isEmpty
                                ? Colors.white
                                : AppColors.cSecondaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: SizedBox(
                      height: height - kToolbarHeight - 115.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisExtent: 220,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15),
                          controller: _scrollController,
                          itemCount:
                              model?.itensEquipamentoModels.equipamentos.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return CardEquipamentosResultadoLevantamento(
                                item: model!.itensEquipamentoModels
                                    .equipamentos[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
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
            bool teveConflito = await checkConflict(context, valor);
            setState(() {
              if (!teveConflito) {
                validateInput(valor);
              }
            });

            if (context.mounted) {
              setState(() {
                model!.ocupado = true;
              });

              consultaController
                  .buscarEquipamentos(context, model!)
                  .then((value) {
                setState(() {
                  model!.ocupado = false;
                });
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
          hintText: 'Patrimônio,Tag, SEAD xx',
          hintStyle: Styles().hintTextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          prefixIcon: Icon(Icons.search,
              size: 25.sp, color: AppColors.cDescriptionIconColor),
        ),
      ),
    );
  }

  Future<bool> checkConflict(BuildContext context, String input) async {
    input = input.replaceAll(' ', '');
    if (RegExp(r'^\d{1,7}$').hasMatch(input) &&
        RegExp(r'^[a-zA-Z0-9]+$').hasMatch(input)) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: AppColors.cWhiteColor,
            title: const Text(
              'Esta entrada é?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Icon(
              Icons.help_outline,
              color: AppColors.cSecondaryColor,
              size: 40,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(AppName.patri);
                },
                child: Text(
                  AppName.patri!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cSecondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(AppName.nSerie);
                },
                child: Text(
                  AppName.nSerie!,
                  style: const TextStyle(color: Colors.white),
                ),
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
        }
      });
      return true;
    } else {
      return false;
    }
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
}

class CardEquipamentosResultadoLevantamento extends StatelessWidget {
  CardEquipamentosResultadoLevantamento({required this.item, super.key});
  final DatabaseHelper dbHelper = DatabaseHelper();
  final ItemEquipamento item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
      child: InkWell(
        onTap: () {
          print("ir para detalhes do equipamento");
          // setState(() {});
          // consultaController
          //     .buscarEquipamentoPorId(context, item)
          //     .then((value) {
          //   setState(() {});
          // });
        },
        child: Material(
          elevation: 7,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.grey,
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h),
                  child: Text(
                    item.tipoEquipamento!,
                    style: Styles().mediumTextStyle(),
                  ),
                ),
                LinhaDescricaoLevantamento(
                    informacao: item.patrimonioSsp, nome: "Patrimônio"),
                LinhaDescricaoLevantamento(
                    informacao: item.fabricante, nome: "Fabricante"),
                LinhaDescricaoLevantamento(
                    informacao: item.modelo, nome: "Modelo"),
                item.patrimonioSead!.length <= 1 || item.patrimonioSead == ""
                    ? Container()
                    : LinhaDescricaoLevantamento(
                        informacao: item.patrimonioSead, nome: "SEAD"),
                item.numeroSerie != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("N° Série: ", style: Styles().hintTextStyle()),
                            Flexible(
                              child: SizedBox(
                                child: Text(
                                  item.numeroSerie!,
                                  style: Styles()
                                      .smallTextStyle()
                                      .copyWith(fontSize: 10.sp),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      bool existe =
                          await dbHelper.produtoExiste(item.idEquipamento!);

                      if (existe) {
                        return Generic.snackBar(
                            context: context,
                            mensagem: "Equipamento já levantado.",
                            duracao: 1,
                            tipo: AppName.erro);
                      } else {
                        String? setor = await showSetorDialog(context);
                        if (setor == "Cancelado" || setor == "") {
                          return Generic.snackBar(
                              context: context,
                              mensagem: "É preciso definir um setor",
                              duracao: 1,
                              tipo: AppName.erro);
                        } else {
                          item.setor = setor;
                          String x = await dbHelper.insertEquipamento(item);

                          if (x == AppName.sucesso!) {
                            Generic.snackBar(
                                context: context,
                                mensagem: "Item adicionado ao levantamento.",
                                duracao: 1,
                                tipo: AppName.info);
                          } else {
                            Generic.snackBar(
                                context: context,
                                mensagem:
                                    "Não foi possível adicionar o esquipamento",
                                duracao: 1,
                                tipo: AppName.erro);
                          }
                        }
                      }
                    },
                    child: const Text("Adicionar",
                        style: TextStyle(color: Colors.white))),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> showSetorDialog(BuildContext context) async {
    final setorController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: AppColors.cWhiteColor,
          title: const Text(
            'Indicar o Setor',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.business,
                color: AppColors.cSecondaryColor,
                size: 40,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: setorController,
                decoration: InputDecoration(
                  hintText: 'Informe o setor',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: AppColors.cSecondaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: AppColors.cSecondaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop("Cancelado");
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.cSecondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(setorController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == null || value.isEmpty) {
        return "Cancelado";
      }
      return value;
    });
  }
}

class LinhaDescricaoLevantamento extends StatelessWidget {
  const LinhaDescricaoLevantamento(
      {super.key, required this.informacao, required this.nome});

  final String? informacao, nome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$nome: ", style: Styles().hintTextStyle()),
          Flexible(
            child: SizedBox(
              child: Text(
                informacao ?? "Sem número",
                style: Styles()
                    .smallTextStyle()
                    .copyWith(fontSize: 10.sp, overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
