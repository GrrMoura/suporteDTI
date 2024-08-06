// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/equipamento_controller.dart';
import 'package:suporte_dti/data/sqflite_helper.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class LevantamentoDigitado extends StatefulWidget {
  const LevantamentoDigitado(
      {super.key}); //TODO: TRAZER O ID DELEGACIA  AQUI PARA SALVAR NO BANCO E TRAZER OS RESUMOS POR ID

  @override
  State<LevantamentoDigitado> createState() => _LevantamentoDigitadoState();
}

class _LevantamentoDigitadoState extends State<LevantamentoDigitado> {
  ScrollController? _scrollController;
  bool isLoading = false;
  final DatabaseHelper dbHelper = DatabaseHelper();
  EquipamentoController equipamentoController = EquipamentoController();
  EquipamentoViewModel? model = EquipamentoViewModel(
      itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []));

  @override
  void dispose() {
    isLoading = false;
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
                  isLoading = false;
                  context.pop("value");
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text(
              "Levantamento",
              style: TextStyle(color: Colors.white, fontSize: 22.sp),
            ),
            IconButton(
                onPressed: () {
                  setState(() {});
                  context.go(AppRouterName.homeController);
                },
                icon: const Icon(Icons.home)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading == true
          ? const LoadingDefault()
          : ListView(
              children: [
                // SizedBox(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [
                //         searchBar(context, model?.ocupado ?? false, height),
                //       ],
                //     ),
                //   ),
                // ),

                searchBar(context, false, height),

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  child: Container(
                    height: height - kToolbarHeight - 100.h,
                    decoration: BoxDecoration(
                        color:
                            model!.itensEquipamentoModels.equipamentos.isEmpty
                                ? Colors.white
                                : AppColors.cSecondaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 250,
                          mainAxisSpacing: 20,
                        ),
                        controller: _scrollController,
                        itemCount:
                            model?.itensEquipamentoModels.equipamentos.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return cardEquipamentosRestulado(
                              context,
                              model!
                                  .itensEquipamentoModels.equipamentos[index]);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Padding cardEquipamentosRestulado(
      BuildContext context, final ItemEquipamento item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
      child: InkWell(
        onTap: () {
          debugPrint("ir para detalhes do equipamento");
          setState(() {});
          equipamentoController
              .buscarEquipamentoPorId(context, item)
              .then((value) {
            setState(() {});
          });
        }, //TODO: COLOCAR BOTÃO PARA IR PAR RESUMO
        child: Material(
          color: AppColors.cWhiteColor,
          elevation: 7,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h),
                  child: Text(
                    item.tipoEquipamento!,
                    style: Styles()
                        .mediumTextStyle()
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                ),
                LinhaDescricaoLevantamento(
                    informacao: item.patrimonioSsp, nome: "Patrimônio"),
                LinhaDescricaoLevantamento(
                    informacao: item.fabricante, nome: "Fabricante"),
                LinhaDescricaoLevantamento(
                    informacao: item.modelo, nome: "Modelo"),
                item.patrimonioSead!.isNotEmpty
                    ? LinhaDescricaoLevantamento(
                        informacao: item.patrimonioSead, nome: "SEAD")
                    : Container(),
                item.numeroLacre!.isNotEmpty
                    ? LinhaDescricaoLevantamento(
                        informacao: item.numeroLacre, nome: "Lacre")
                    : Container(),
                item.numeroSerie != null && item.numeroSerie!.isNotEmpty
                    ? LinhaDescricaoLevantamento(
                        informacao: item.numeroSerie, nome: "N° Série")
                    : Container(),
                item.comAssistenciaEmAberto == true
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Assistência técnica em aberto",
                          style: TextStyle(
                              color: AppColors.cErrorColor,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.cSecondaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12)),
                            onPressed: () async {
                              bool existe = await dbHelper
                                  .equipamentoExiste(item.idEquipamento!);

                              if (existe) {
                                return Generic.snackBar(
                                    context: context,
                                    mensagem: "Equipamento já levantado.",
                                    duracao: 1,
                                    tipo: AppName.erro);
                              } else {
                                String? setor = await showSetorDialog(context);
                                if (setor == "Cancelado" || setor!.isEmpty) {
                                  return Generic.snackBar(
                                      context: context,
                                      mensagem: "É preciso definir um setor",
                                      duracao: 1,
                                      tipo: AppName.erro);
                                } else {
                                  item.setor = setor;
                                  String x =
                                      await dbHelper.insertEquipamento(item);

                                  if (x == AppName.sucesso!) {
                                    Generic.snackBar(
                                        context: context,
                                        mensagem:
                                            "Item adicionado ao levantamento.",
                                        duracao: 1,
                                        tipo: AppName.info);
                                  } else {
                                    Generic.snackBar(
                                        context: context,
                                        mensagem:
                                            "Não foi possível adicionar o equipamento",
                                        duracao: 1,
                                        tipo: AppName.erro);
                                  }
                                }
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                SizedBox(width: 8),
                                const Text("Adicionar",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            )),
                      ),
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
                style: TextStyle(color: AppColors.cErrorColor),
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

  Padding searchBar(BuildContext context, bool ocupado, double? height) {
    return Padding(
      padding:
          EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w, bottom: 10.h),
      child: TextFormField(
        style: Styles().mediumTextStyle(),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          model!.descricao = value;
        },
        onFieldSubmitted: ((valor) async {
          if (valor.isNotEmpty) {
            if (context.mounted) {
              setState(() {
                model!.itensEquipamentoModels.equipamentos = [];
                isLoading = true;
              });

              await equipamentoController.buscarEquipamentos(context, model!);

              setState(() {
                isLoading = false;
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
              mensagem: "O campo precisa ser preenchido",
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
