// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:suporte_dti/controller/equipamento_controller.dart';
import 'package:suporte_dti/controller/levantamento_controller.dart';
import 'package:suporte_dti/data/sqflite_helper.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/viewModel/equipamento_nao_alocados.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/screens/widgets/custom_dialog.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class ResumoLevantamento extends StatefulWidget {
  const ResumoLevantamento({super.key, required this.unidade});

  final Unidade unidade;
  @override
  State<ResumoLevantamento> createState() => _ResumoLevantamentoState();
}

class _ResumoLevantamentoState extends State<ResumoLevantamento> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final LevantamentoModel modelLevantamento =
      LevantamentoModel(equipamentosLevantados: []);
  bool isOk = false;
  // EquipamentoVerificadoViewmodel equipamentoVerificadoViewmodel =
  //     EquipamentoVerificadoViewmodel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView(
        children: [
          const Header(),
          LevantamentoAtual(dbHelper: dbHelper),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            child: _buildEquipamentoContainer(),
          ),
          _buildRowBotoes(context),
        ],
      ),
    );
  }

  Padding _buildRowBotoes(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                showDiscardConfirmationDialog(context);
              });
            },
            child: const Text(
              'Descartar',
              style: TextStyle(color: AppColors.cErrorColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              List<NaoAlocado> naoAlocado = [];
              int response = await dbHelper.getEquipamentosCount();
              if (response > 0) {
                modelLevantamento.idUnidadeAdministrativa = widget.unidade.id;
                modelLevantamento.nomeUnidade = widget.unidade.nome;
                modelLevantamento.unidade = widget.unidade;

                modelLevantamento.dataLevantamento = DateTime.now();
                naoAlocado = await EquipamentoController()
                    .verificarEquipamento(context, modelLevantamento);

                // modelLevantamento.idUnidadeAdministrativa = widget.unidade.id;
                // modelLevantamento.dataLevantamento = DateTime.now();
                // LevantamentoController().cadastrar(context, modelLevantamento);

                if (naoAlocado.isNotEmpty) {
                  mostrarEquipamentosNaoAlocados(
                      context: context,
                      equipamentos: naoAlocado,
                      unidade: widget.unidade);
                } else {
                  LevantamentoController()
                      .cadastrar(context, modelLevantamento);
                  Navigator.of(context).pop();
                }
              } else {
                Generic.snackBar(
                    context: context,
                    mensagem: "Nenhum equipamento foi levantado");
              }
            },
            child: const Text(
              'Finalizar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<dynamic>> _buildEquipamentoContainer() {
    return FutureBuilder(
      initialData: const [],
      future: dbHelper.getEquipamentos(),
      builder: (context, AsyncSnapshot<List> snapshot) {
        var data = snapshot.data;
        var datalength = data!.length;

        return Container(
          height: datalength == 0 ? 300.h : 340.h,
          decoration: BoxDecoration(
              color: AppColors.cSecondaryColor,
              borderRadius: BorderRadius.circular(20)),
          child: datalength == 0
              ? Center(
                  child: Text(
                    "Levantamento ainda não iniciado",
                    style: Styles()
                        .mediumTextStyle()
                        .copyWith(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: datalength,
                  itemBuilder: (context, index) {
                    modelLevantamento.equipamentosLevantados ??= [];

                    EquipamentoLevantado novoEquipamento = EquipamentoLevantado(
                      idEquipamento: data[index].idEquipamento,
                      descricaoSala: data[index].setor,
                    );

                    modelLevantamento.equipamentosLevantados!
                        .add(novoEquipamento);

                    return cardEquipamento(
                      context: context,
                      index: index,
                      equipamento: data[index],
                    );
                  },
                ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context, "ola");
          },
          icon: const Icon(Icons.arrow_back_ios_new)),
      title: Text("Resumo",
          style: Styles().titleStyle().copyWith(
              color: AppColors.cWhiteColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.normal)),
      centerTitle: true,
      backgroundColor: AppColors.cSecondaryColor,
    );
  }

  Future<void> mostrarEquipamentosNaoAlocados(
      {required BuildContext context,
      required List<NaoAlocado> equipamentos,
      required Unidade unidade}) async {
    final Map<int, bool> equipamentosAlocados = {
      for (var eq in equipamentos) eq.idEquipamento!: false,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style:
                  TextStyle(fontSize: 20, color: Colors.black), // Estilo padrão
              children: <TextSpan>[
                TextSpan(
                  text: 'Esses equipamentos ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: 'NÃO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: ' estão alocados nesta unidade:',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: equipamentos.length,
                        itemBuilder: (context, index) {
                          final equipamento = equipamentos[index];
                          final bool isAlocado = equipamentosAlocados[
                                  equipamento.idEquipamento!] ??
                              false;
                          return Card(
                            color: AppColors.cWhiteColor,
                            margin: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 8.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              leading: const Icon(
                                Icons.devices,
                                color: AppColors.cSecondaryColor,
                              ),
                              title: Text(
                                equipamento.descricao!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColors.cSecondaryColor,
                                ),
                              ),
                              subtitle: Text(
                                equipamento.descricaoUnidade!,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: AppColors.cSecondaryColor,
                                ),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.cSecondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8.0),
                                ),
                                onPressed: isAlocado == true
                                    ? null
                                    : () async {
                                        int result =
                                            await EquipamentoController()
                                                .movimentarEquipamento(
                                          context: context,
                                          descricao:
                                              equipamento.descricao ?? "",
                                          idEquipamento:
                                              equipamento.idEquipamento!,
                                          idUnidade: unidade.id!,
                                        );
                                        if (result == 200) {
                                          setState(() {
                                            equipamentosAlocados[equipamento
                                                .idEquipamento!] = true;
                                          });
                                        }
                                      },
                                child: Text(
                                  isAlocado == true ? "Alocado" : 'Alocar',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //FUNÇÃO PARA ALOCAR TODOS OS EQUIPAMENTOS DE UMA VEZ
                    // SizedBox(height: 5.h),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         bool sucesso = true;
                    //         for (var equipamento in equipamentos) {
                    //           if (!(equipamentosAlocados[
                    //                   equipamento.idEquipamento!] ??
                    //               false)) {
                    //             int result = await EquipamentoController()
                    //                 .movimentarEquipamento(
                    //               context: context,
                    //               descricao: equipamento.descricao ?? "",
                    //               idEquipamento: equipamento.idEquipamento!,
                    //               idUnidade: idUnidade,
                    //             );
                    //             if (result != 200) {
                    //               sucesso = false;
                    //               break; // Se algum item falhar, interrompe a alocação de todos
                    //             }
                    //           }
                    //         }
                    //         if (sucesso) {
                    //           setState(() {
                    //             equipamentosAlocados
                    //                 .updateAll((key, value) => true);
                    //           });
                    //           Navigator.of(context).pop();
                    //         } else {
                    //           // Tratar falha na alocação (exibir mensagem de erro, etc.)
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             const SnackBar(
                    //                 content: Text(
                    //                     'Falha ao alocar todos os itens.')),
                    //           );
                    //         }
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.green,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(12.0),
                    //         ),
                    //       ),
                    //       child: const Text('Alocar Todos',
                    //           style: TextStyle(color: Colors.white)),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar',
                  style: TextStyle(color: AppColors.cErrorColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                EquipamentoViewModel? modelEquipamento;
                modelEquipamento?.idUnidade = unidade.id;
                final todosAlocados =
                    equipamentosAlocados.values.every((value) => value == true);

                if (todosAlocados) {
                  modelLevantamento.idUnidadeAdministrativa = widget.unidade.id;
                  modelLevantamento.dataLevantamento = DateTime.now();
                  LevantamentoController()
                      .cadastrar(context, modelLevantamento);
                  context.push(
                    AppRouterName.delegaciaDetalhe,
                    extra: {"model": modelEquipamento, "unidade": unidade},
                  );
                  // int count = 0;
                  // Navigator.of(context).popUntil((route) {
                  //   return count++ == 2; // metodo para voltar 2 pilhas
                  // });
                } else {
                  Generic.snackBar(
                    context: context,
                    mensagem: "Todos os Equipamentos precisam ser alocados ",
                    duracao: 1,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDiscardConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Text(
            'Confirmar Descarte',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          content: const Text(
            'Tem certeza de que deseja descartar o levantamento?',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Descartar',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        setState(() {
          dbHelper.deleteAllEquipamentos();
        });
      }
    });
  }

  Padding cardEquipamento(
      {required BuildContext context,
      required ItemEquipamento equipamento,
      required int index}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: SizedBox(
        height: 132.h,
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 5.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 18.h,
                      decoration: BoxDecoration(
                          color: AppColors.cSecondaryColor.withOpacity(0.8),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text(
                      equipamento.tipoEquipamento ?? "",
                      style: Styles().smallTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                        onPressed: () {
                          _showBottomSheet(
                              context: context, equipamento: equipamento);
                        },
                        icon: Icon(Icons.more_vert_outlined, size: 15.sp)),
                  ], //TODO COLOCAR OS RESUMOS INDIVIDUAIS POR ID UNIDADE
                ),
                InkWell(
                  // onTap: () {
                  //   // EquipamentoModel? model;
                  //   // model?.idEquipamento = equipamento.idEquipamento;

                  //   // context.push(AppRouterName.detalhesEquipamento,extra: equipamento);
                  // },
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.w, left: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SEAD",
                                style: Styles()
                                    .descriptionRestulScan()
                                    .copyWith(fontSize: AppDimens.smallSize),
                              ),
                              Text(
                                equipamento.patrimonioSead ?? "",
                                style: Styles().hintTextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patrimônio",
                                style: Styles()
                                    .descriptionRestulScan()
                                    .copyWith(fontSize: AppDimens.smallSize),
                              ),
                              SizedBox(
                                  width: 100.w,
                                  child: Text(equipamento.patrimonioSsp ?? "",
                                      style: Styles().hintTextStyle(),
                                      overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nº Série",
                                style: Styles()
                                    .descriptionRestulScan()
                                    .copyWith(fontSize: AppDimens.smallSize),
                              ),
                              Text(equipamento.numeroSerie ?? "",
                                  style: Styles().hintTextStyle(),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 10.w, top: 5.h),
                  child: Row(
                    children: [
                      Text(
                        "Setor: ",
                        style: Styles().descriptionRestulScan(),
                      ),
                      Text(
                        equipamento.setor ?? "",
                        style: Styles()
                            .hintTextStyle()
                            .copyWith(fontSize: AppDimens.pSize),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showBottomSheet(
      {required BuildContext context,
      required ItemEquipamento equipamento}) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: AppColors.cDescriptionIconColor,
              ),
              title: const Text('Editar'),
              onTap: () async {
                String? result = await CustomDialog.show(
                  context,
                  title: 'Atualize o Setor',
                  icon: Icons.business,
                  hintText: 'Informe o setor',
                );

                if (result == "Cancelado" || result == "") {
                  context.pop("value");
                  return;
                } else {
                  equipamento.setor = result;
                  equipamento.idFabricante = 0;
                  // RETIRAR DEPOIS DO NA HORA DE SALVAR
                  equipamento.idModelo = 0;

                  String x = await dbHelper.updateEquipamento(equipamento);

                  if (x == AppName.sucesso!) {
                    Generic.snackBar(
                        context: context,
                        mensagem: "Item Atualizado",
                        duracao: 1,
                        tipo: AppName.sucesso);
                    context.pop("value");
                    setState(() {});
                  } else {
                    Generic.snackBar(
                        context: context,
                        mensagem: "Não foi possível atualizar o equipamento",
                        duracao: 1,
                        tipo: AppName.erro);
                    context.pop("value");
                  }
                }

                //   Navigator.of(context).pop();

                // dbHelper.updateEquipamento(equipamento);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Deletar'),
              onTap: () {
                dbHelper.deleteEquipamentoPorId(equipamento.idBanco!);
                setState(() {});

                context.pop("value");
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartilhar'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LevantamentoAtual extends StatelessWidget {
  const LevantamentoAtual({
    required this.dbHelper,
    super.key,
  });
  final DatabaseHelper dbHelper;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Container(
        width: double.maxFinite,
        height: 80.h,
        decoration: const BoxDecoration(
            color: AppColors.cSecondaryColor,
            boxShadow: [BoxShadow(color: Colors.black)],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
                topLeft: Radius.circular(5),
                bottomRight: Radius.circular(5))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 180.w,
                    child: Text(
                      "Levantamento Atual:",
                      style: Styles().descriptionRestulScan().copyWith(
                          color: const Color.fromARGB(255, 195, 197, 199)),
                    ),
                  ),
                  SizedBox(
                    width: 80.w,
                    child: Text(DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        style: Styles()
                            .descriptionRestulScan()
                            .copyWith(color: AppColors.cPrimaryColor)),
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: dbHelper.getEquipamentosCount(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else {
                    return InfoResumo(
                      titulo: "Equipamentos Cadastrados",
                      info: " ${snapshot.data ?? 0}",
                    );
                  }
                }))
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 45.w, height: 45.w, child: Image.asset(AppName.sspLogo!)),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              children: [
                Text(
                  "Estado de Sergipe",
                  style: Styles().titleStyle().copyWith(
                      color: Colors.black, fontSize: AppDimens.subTitleSize),
                ),
                Text("Secretaria de Segurança Pública",
                    style: Styles().smallTextStyle().copyWith(
                          color: AppColors.contentColorBlack,
                        )),
                Text("CPSI/DTI",
                    style: Styles().smallTextStyle().copyWith(
                          color: AppColors.contentColorBlack,
                        )),
              ],
            ),
          ),
          SizedBox(
              width: 50.w,
              height: 50.w,
              child: Image.asset(
                AppName.logoDti!,
                color: AppColors.cSecondaryColor,
              )),
        ],
      ),
    );
  }
}

class InfoResumo extends StatelessWidget {
  const InfoResumo({
    required this.info,
    required this.titulo,
    super.key,
  });
  final String titulo;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 180.w,
            child: Text(
              "$titulo:",
              style: Styles()
                  .descriptionRestulScan()
                  .copyWith(color: const Color.fromARGB(255, 195, 197, 199)),
            ),
          ),
          SizedBox(
            width: 80.w,
            child: Text(info,
                style: Styles()
                    .descriptionRestulScan()
                    .copyWith(color: AppColors.cPrimaryColor)),
          ),
        ],
      ),
    );
  }
}
