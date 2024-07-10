// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:suporte_dti/controller/levantamento_controller.dart';
import 'package:suporte_dti/data/sqflite_helper.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/screens/widgets/custom_dialog.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

class ResumoLevantamento extends StatefulWidget {
  const ResumoLevantamento({super.key, required this.idUnidade});
  final int idUnidade;
  @override
  State<ResumoLevantamento> createState() => _ResumoLevantamentoState();
}

class _ResumoLevantamentoState extends State<ResumoLevantamento> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final LevantamentoModel modelLevantamento =
      LevantamentoModel(equipamentosLevantados: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text("Resumo",
            style: Styles().titleStyle().copyWith(
                color: AppColors.cWhiteColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.normal)),
        centerTitle: true,
        backgroundColor: AppColors.cSecondaryColor,
      ),
      body: ListView(
        children: [
          const Header(),
          LevantamentoAtual(dbHelper: dbHelper),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            child: Container(
              height: 380.h,
              decoration: BoxDecoration(
                  color: AppColors.cSecondaryColor,
                  borderRadius: BorderRadius.circular(20)),
              child: ListView(
                children: [
                  SizedBox(
                    height: 380.h,
                    child: FutureBuilder(
                        initialData: const [],
                        future: dbHelper.equipamentos(),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          var data = snapshot.data;
                          var datalength = data!.length;

                          return datalength == 0
                              ? Center(
                                  child: Text(
                                  "Levantamento ainda não iniciado",
                                  style: Styles()
                                      .mediumTextStyle()
                                      .copyWith(color: Colors.white),
                                ))
                              : ListView.builder(
                                  itemCount: datalength,
                                  itemBuilder: (context, index) {
                                    modelLevantamento.equipamentosLevantados ??=
                                        [];

                                    // Cria um novo EquipamentoLevantado com id e descricao
                                    EquipamentoLevantado novoEquipamento =
                                        EquipamentoLevantado(
                                      idEquipamento: data[index].idEquipamento,
                                      descricaoSala: data[index].setor,
                                    );

                                    // Adiciona o novo EquipamentoLevantado à lista de equipamentos do levantamento
                                    modelLevantamento.equipamentosLevantados!
                                        .add(novoEquipamento);

                                    return cardEquipamento(
                                      context: context,
                                      index: index,
                                      equipamento: data[index],
                                    );
                                  },
                                );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Row(
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
                  int response = await dbHelper.getEquipamentosCount();
                  if (response > 0) {
                    debugPrint(
                        modelLevantamento.equipamentosLevantados.toString());
                    modelLevantamento.idUnidadeAdministrativa =
                        widget.idUnidade;
                    modelLevantamento.dataLevantamento = DateTime.now();
                    LevantamentoController()
                        .cadastrar(context, modelLevantamento);
                  }
                },
                child: const Text(
                  'Finalizar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
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
        height: 112.h,
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 5.w),
            child: Column(
              children: [
                //TODO: ADICIONAR "NÃO INFORMADO NA HORA DE ADCIONAR O ITEM AO BANCO DE DADOS";
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
                  ],
                ),
                InkWell(
                  onTap: () {
                    Generic.snackBar(
                        tipo: AppName.info,
                        context: context,
                        mensagem: "Vai para a tela DETALHE");
                    //context.push(AppRouterName.detalhesEquipamento);
                  },
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
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
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
                SizedBox(height: 10.h),
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
