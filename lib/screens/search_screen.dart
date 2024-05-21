// ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers, avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/controller/consulta_controller.dart';
import 'package:suporte_dti/data/delegacia_data.dart';
import 'package:suporte_dti/data/equipamentos_data.dart';
import 'package:suporte_dti/model/delegacia_model.dart';
import 'package:suporte_dti/model/equipamentos_historico_model.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/services/sqlite_service.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/consulta_view_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.nome});

  final String nome;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<DelegaciaModel> delegaciaList;
  late List<EquipamentoModel> equipamentoList;
  final ConsultaController consultaController = ConsultaController();
  EquipamentosHistoricoModel historicoModel = EquipamentosHistoricoModel();
  EquipamentoViewModel? model = EquipamentoViewModel();

  late String name, cpf;

  SqliteService db = SqliteService();
  // ignore: prefer_typing_uninitialized_variables
  EquipamentosHistoricoModel? teste;

  String? semFoto = AppName.semFoto;
  Uint8List? bytes;
  bool temFoto = false;

  @override
  initState() {
    super.initState();

    pegarFoto();
    pegarIdentificacao();

    delegaciaList = delegaciaData;
    todosOsEquipamentos = equipamentosData;
    teste = EquipamentosHistoricoModel(
        id: 7,
        marca: "DELL",
        patrimonio: "777777",
        tag: "BH2239",
        tipo: "monitor",
        lotacao: "ARACAJU");
  }

  void pegarIdentificacao() {
    String informacoes = widget.nome;

    List names = informacoes.split(' ');
    String _nome = "${names[0]} ${names[1]}";
    String _cpf = "${names[2]}";
    name = _nome;
    cpf = _cpf;
  }

  pegarFoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bytes = base64Decode(prefs.getString("foto") ?? "");
    temFoto = prefs.getBool("temFoto") ?? false;

    setState(() {});
  }

  _pickImagefromGallery() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        File? imageFile = File(pickedImage.path);
        bytes = imageFile.readAsBytesSync();
        String imageString = base64Encode(bytes!);
        prefs.setString("foto", imageString);
        prefs.setBool("temFoto", true);

        setState(() {});
      } else {}
    } catch (e) {
      return null;
    }
  }

  List<EquipamentoModel> todosOsEquipamentos = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return model?.ocupado != true
        ? Scaffold(
            backgroundColor: AppColors.cPrimaryColor,
            body: SizedBox(
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    heading(),
                    FastSearch(delegaciaList: delegaciaList),
                    searchBar(context, model?.ocupado ?? false),
                    SizedBox(height: 25.h),
                    builderHistorico(),
                  ],
                ),
              ),
            ),
          )
        : const LoadingDefault();
  }

  Padding searchBar(BuildContext context, bool ocupado) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.cSecondaryColor,
        ),
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          style: Styles().mediumTextStyle(),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: ((value) async {
            if (value.isNotEmpty) {
              bool teveConflito = await checkConflict(context, value);
              setState(() {
                print(teveConflito);

                if (!teveConflito) {
                  validateInput(value);
                }
                model?.ocupado = true;
              });

              print("patrimonio ssp: ${model!.patrimonioSSP}");
              print("numero de serie:  ${model!.numeroSerie}");
              print("Sead: ${model!.patrimonioSead}");
              model?.idFabricante = 0;
              model?.idModelo = 0;
              model?.idTipoEquipamento = 0;
              if (context.mounted) {
                context.push(AppRouterName.listaEquipamentos, extra: model);
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
            hintText: 'Patrimônio, Marca, Tipo, Modelo, Tag...',
            hintStyle: Styles().hintTextStyle(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            prefixIcon: Icon(Icons.search,
                size: 25.sp, color: AppColors.cDescriptionIconColor),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<dynamic>> builderHistorico() {
    return FutureBuilder(
        initialData: const [],
        future: db.getEquipamentos(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data;
          var datalength = data?.length;

          return datalength == 0
              ? const Center(child: Text("Sem Histórico"))
              : SizedBox(
                  height: 160.h,
                  width: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: datalength,
                      itemBuilder: (context, index) {
                        String patrimonio = data![index].patrimonio;
                        String lotacao = data[index].lotacao;
                        String marca = data[index].marca;
                        return GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(ClipboardData(text: patrimonio));

                            Generic.snackBar(
                              context: context,
                              mensagem: "Copiado para área de transferência",
                              tipo: AppName.sucesso,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 5.h),
                            child: SizedBox(
                              width: 100.w,
                              child: Material(
                                color: AppColors.cWhiteColor,
                                elevation: 4,
                                borderRadius: BorderRadius.circular(10),
                                shadowColor: Colors.grey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              db.deletarEquipamento(patrimonio);
                                              setState(() {});
                                            },
                                            child: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red))
                                      ],
                                    ),
                                    Text(marca,
                                        style: Styles().smallTextStyle()),
                                    Image.asset("assets/images/impressora.png",
                                        height: 70.h),
                                    Text(patrimonio,
                                        style: Styles().smallTextStyle()),
                                    Text(lotacao,
                                        style: Styles().hintTextStyle()),
                                    SizedBox(
                                      height: 3.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
        });
  }

  Container heading() {
    return Container(
      color: AppColors.cSecondaryColor,
      height: 160.h,
      child: Column(
        children: [
          Expanded(child: SizedBox(height: 1.h)),
          Expanded(child: SizedBox(height: 1.h)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 45.h,
                backgroundColor: AppColors.cWhiteColor,
                child: InkWell(
                  onTap: () async {
                    await _pickImagefromGallery();
                    setState(() {
                      temFoto = true;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.cSecondaryColor,
                    radius: 40.h,
                    backgroundImage: temFoto == false
                        ? AssetImage(semFoto!)
                        // ? AssetImage("assets/images/people1.jpg")
                        : bytes != null
                            ? MemoryImage(bytes!) as ImageProvider<Object>
                            : AssetImage(semFoto!),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        name,
                        style: Styles().titleStyle().copyWith(
                            fontSize: name.length >= 17 ? 16.sp : 22.sp),
                      ),
                    ),
                    Row(
                      children: [Text(cpf, style: Styles().subTitleStyle())],
                    )
                  ],
                ),
              )
            ],
          ),
          Expanded(child: SizedBox(height: 1.h)),
        ],
      ),
    );
  }

  void validateInput(value) {
    if (RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      model!.idTipoEquipamento = value; // euqipamento
    } else if (RegExp(r'^\d{1,7}$').hasMatch(value)) {
      model!.patrimonioSSP = value;
    } else if (RegExp(r'^(SEAD|\d+)(\s+)/$').hasMatch(value)) {
      model!.patrimonioSead = value.replaceAll(RegExp(r'^SEAD\s+'), '');
    } else if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      model!.numeroSerie = value;
    } else {
      // inválido
    }
  }

  Future<bool> checkConflict(BuildContext context, String input) async {
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

class FastSearch extends StatelessWidget {
  const FastSearch({
    super.key,
    required this.delegaciaList,
  });

  final List<DelegaciaModel> delegaciaList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: SizedBox(
        height: 107.h,
        width: double.infinity,
        child: ListView.builder(
          itemCount: delegaciaList.length + 1,
          itemBuilder: (context, index) {
            if (index < delegaciaList.length) {
              final delegacia = delegaciaList[index];
              return DelegaciasIcones(
                  path: delegacia.path,
                  id: delegacia.id,
                  name: delegacia.name,
                  region: delegacia.region);
            } else {
              return const PesquisarDelegacias();
            }
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class PesquisarDelegacias extends StatelessWidget {
  const PesquisarDelegacias({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              context.push(AppRouterName.resultDelegacias);
            },
            child: Container(
              height: 80.h,
              width: 80.w,
              decoration: BoxDecoration(
                  color: AppColors.cSecondaryColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 2.0), //(x,y)
                        blurRadius: 6.0)
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(AppName.add!),
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      fit: BoxFit.cover)),
            ),
          ),
          SizedBox(height: 5.h),
          Text("OUTRA", style: Styles().smallTextStyle())
        ],
      ),
    );
  }
}

class CardUltimasConsultas extends StatefulWidget {
  const CardUltimasConsultas(
      {this.lotacao, this.patrimonio, this.db, super.key});

  final String? patrimonio, lotacao;
  final SqliteService? db;

  @override
  State<CardUltimasConsultas> createState() => _CardUltimasConsultasState();
}

class _CardUltimasConsultasState extends State<CardUltimasConsultas> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: widget.patrimonio!));
        Generic.snackBar(
            context: context,
            mensagem: "Copiado para área de transferência",
            tipo: AppName.sucesso);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
        child: SizedBox(
          width: 100.w,
          child: Material(
            color: AppColors.cWhiteColor,
            elevation: 10,
            borderRadius: BorderRadius.circular(10),
            shadowColor: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          widget.db!.deletarEquipamento(widget.patrimonio!);
                          setState(() {});
                        },
                        child: const Icon(Icons.remove_circle_outline,
                            color: Colors.red))
                  ],
                ),
                Image.asset("assets/images/impressora.png", height: 70.h),
                Text(widget.patrimonio!, style: Styles().smallTextStyle()),
                Text(widget.lotacao!, style: Styles().hintTextStyle()),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DelegaciasIcones extends StatelessWidget {
  final String? path;
  final int? id;
  final String? name;
  final String? region;
  const DelegaciasIcones({
    required this.id,
    required this.path,
    required this.name,
    required this.region,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          context.push(AppRouterName.resultDelegacias);
        },
        child: Column(
          children: [
            Container(
              height: 80.h,
              width: 80.w,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 2.0), //(x,y)
                        blurRadius: 6.0)
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(
                        path!,
                      ),
                      fit: BoxFit.cover)),
            ),
            SizedBox(height: 5.h),
            Text(name!, style: Styles().smallTextStyle())
          ],
        ),
      ),
    );
  }
}
