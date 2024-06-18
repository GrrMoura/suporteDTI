import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:suporte_dti/data/sqflite_helper.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

class ResumoLevantamento extends StatelessWidget {
  ResumoLevantamento({super.key});
  final DatabaseHelper dbHelper = DatabaseHelper();

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
      body: Column(
        children: [
          const Header(),
          //   UltimoLevantamento(),
          LevantamentoAtual(dbHelper: dbHelper),
          BoxEquipamentos(dbHelper: dbHelper)
        ],
      ),
    );
  }
}

class BoxEquipamentos extends StatelessWidget {
  const BoxEquipamentos({super.key, required this.dbHelper});
  final DatabaseHelper dbHelper;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Container(
        height: 250.h,
        decoration: BoxDecoration(
            color: AppColors.cSecondaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: ListView(
          children: [
            SizedBox(
              height: 400,
              child: FutureBuilder(
                  initialData: [],
                  future: dbHelper.equipamentos(),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    var data = snapshot.data;
                    var datalength = data!.length;

                    return datalength == 0
                        ? Center(
                            child: Text(
                            "Sem Contatos Salvos",
                            style: Styles().mediumTextStyle(),
                          ))
                        : ListView.builder(
                            itemCount: datalength,
                            itemBuilder: (context, index) => CardEquipametos(
                                  index: index,
                                  equipamento: data[index],
                                ));
                  }),
            ),
            // CardEquipametos(
            //     titulo: "Monitor",
            //     id: "2",
            //     setor: "Cartorio",
            //     patrimonio: "122/13",
            //     lacre: "1010")
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
            // const InfoResumo(
            //   titulo: "Equipamentos Cadastrados",
            //   info: await dbHelper.getEquipamentosCount(),
            // ),
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
      padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w, bottom: 20.h),
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

class CardEquipametos extends StatelessWidget {
  const CardEquipametos(
      {required this.equipamento, required this.index, super.key});
  final ItemEquipamento equipamento;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 5.w),
          child: Column(
            children: [
              //TODO: ADICIONAR "NÃO INFORMADO NA HORA DE ADCIONAR O ITEM AO BANCO DE DADOS";
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 50.w, child: Text("${index + 1}")),
                  SizedBox(
                      width: 100.w,
                      child: Text(equipamento.tipoEquipamento!,
                          textAlign: TextAlign.center)),
                  SizedBox(
                    width: 50.w,
                    child: IconButton(
                        onPressed: () {
                          showOptions(context, 'editar');
                          // Generic.snackBar(
                          //     tipo: AppName.info,
                          //     context: context,
                          //     mensagem: "Vai para a tela edit");
                        },
                        icon: Icon(Icons.more_vert_outlined, size: 15.sp)),
                  ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Setor",
                          style: Styles().descriptionRestulScan(),
                        ),
                        SizedBox(
                            width: 100.w,
                            child: Text(equipamento.descricao!,
                                textAlign: TextAlign.center)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Patrimônio",
                          style: Styles().descriptionRestulScan(),
                        ),
                        SizedBox(
                            width: 80.w,
                            child: Text(equipamento.patrimonioSsp!,
                                textAlign: TextAlign.center)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Lacre",
                          style: Styles().descriptionRestulScan(),
                        ),
                        SizedBox(
                            width: 80.w,
                            child: Text(equipamento.patrimonioSead!,
                                textAlign: TextAlign.center)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ),
      ),
    );
  }

  void showOptions(BuildContext context, String opcao) {
    // Mostra o menu de opções específico para cada ícone
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 0, 0, 0),
      items: [
        PopupMenuItem(child: Text('Opção 1'), value: 'opcao1'),
        PopupMenuItem(child: Text('Opção 2'), value: 'opcao2'),
        PopupMenuItem(child: Text('Opção 3'), value: 'opcao3'),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        if (opcao == 'editar') {
          // Adicione o código para editar aqui
        } else if (opcao == 'deletar') {
          // Adicione o código para deletar aqui
        }
      }
    });
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
