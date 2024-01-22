// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:suporte_dti/data/delegacia_data.dart';
import 'package:suporte_dti/data/equipamentos_data.dart';
import 'package:suporte_dti/model/equipamentos_historico_model.dart';
import 'package:suporte_dti/model/equipamentos_model.dart';
import 'package:suporte_dti/navegacao/app_screens_string.dart';
import 'package:suporte_dti/services/sqlite_service.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

import '../model/delegacia_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<DelegaciaModel> delegaciaList;
  late List<EquipamentosModel> equipamentoList;
  EquipamentosHistoricoModel historicoModel = EquipamentosHistoricoModel();
  SqliteService db = SqliteService();
  // ignore: prefer_typing_uninitialized_variables
  EquipamentosHistoricoModel? teste;

  String? semFoto = "assets/images/semfoto.png";
  Uint8List? bytes;
  bool temFoto = false;

  @override
  initState() {
    super.initState();

    pegarFoto();

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

  pegarFoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bytes = base64Decode(prefs.getString("foto")!);
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

  List<EquipamentosModel> todosOsEquipamentos = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.cPrimaryColor,
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              heading(),
              FastSearch(delegaciaList: delegaciaList),
              SearchBarr(model: historicoModel),
              // ElevatedButton(
              //     onPressed: () {
              //       setState(() {});
              //     },
              //     child: Text("SET STATE")),
              SizedBox(height: 25.h),
              builderHistorico(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        // db.add(teste!);
        // setState(() {});
      }),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.orange,
                                content: Text(
                                  "copiado para area de transferencia",
                                  style: Styles().mediumTextStyle(),
                                )));
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
                    Text(
                      "Fabiana Maria",
                      style: Styles().titleStyle(),
                    ),
                    Row(
                      children: [
                        Text("DESENVOLVEDORA", style: Styles().subTitleStyle()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text("-", style: Styles().subTitleStyle()),
                        ),
                        Text("1023322", style: Styles().subTitleStyle())
                      ],
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
          itemCount: delegaciaList.length,
          itemBuilder: (context, index) {
            final delegacia = delegaciaList[index];

            return DelegaciasIcones(
                path: delegacia.path,
                id: delegacia.id,
                name: delegacia.name,
                region: delegacia.region);
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class SearchBarr extends StatelessWidget {
  SearchBarr({super.key, required this.model});
  final EquipamentosHistoricoModel model;

  final SqliteService db = SqliteService();
  @override
  Widget build(BuildContext context) {
    void runFilter(String enteredKeyword) {
      //toDO  Fazer filtro
      // List<EquipamentosModel> results = [];
      // if (enteredKeyword.isEmpty) {
      //   results = todosOsEquipamentos;
      // } else {
      //   results = todosOsEquipamentos
      //       .where((equipamento) => equipamento.patrimonio
      //           .toLowerCase()
      //           .contains(enteredKeyword.toLowerCase()))
      //       .toList();
      // }

      // setState(() {
      //   _acharEquipamentos = results;
      // });
    }

    // void addEquipamento(EquipamentosHistoricoModel equipamento) {
    //   db.add(equipamento);
    // }

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
          onChanged: runFilter,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: ((value) {
            context.push(AppRouterName.resultado);
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "copiado para area de transferencia",
              style: Styles().mediumTextStyle(),
            )));
        // copied successfully
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
                SizedBox(
                  height: 3.h,
                )
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

class SearchBar2 extends StatefulWidget {
  const SearchBar2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar2> {
  SqliteService db = SqliteService();
  String? query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  void addEquipamento(EquipamentosHistoricoModel equipamento) {
    db.add(equipamento);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.cSecondaryColor,
        ),
        padding: const EdgeInsets.all(8),
        child: TextField(
          style: Styles().mediumTextStyle(),
          onSubmitted: (value) {},
          // onChanged: onQueryChanged,
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
}
