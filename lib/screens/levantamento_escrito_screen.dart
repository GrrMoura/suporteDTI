import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/consulta_controller.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class LevantamentoDigitado extends StatefulWidget {
  const LevantamentoDigitado({super.key});

  @override
  State<LevantamentoDigitado> createState() => _LevantamentoDigitadoState();
}

class _LevantamentoDigitadoState extends State<LevantamentoDigitado> {
  ScrollController? _scrollController;
  Future<void>? _future;
  var consultaController = ConsultaController();
  EquipamentoViewModel? model = EquipamentoViewModel(
      itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []));

  @override
  void initState() {
    setState(() {});
    super.initState();
    //  _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController?.position.pixels ==
        _scrollController?.position.maxScrollExtent) {
      if (model?.paginacao == null ||
          model!.paginacao!
              .seChegouAoFinalDaPagina(model!.paginacao!.pagina!)) {
        setState(() {});

        consultaController.buscarEquipamentos(context, model!).then((value) {
          setState(() {}); //testar
        });
      } else {
        Generic.snackBar(
            context: context,
            mensagem: "Não há mais itens.",
            tipo: AppName.info);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return _listViewScreen(height: height);
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
        child: CardEquipamentosResultadoLevantamento(item: item));
  }

  Widget _listViewScreen({required double height}) {
    double screenWidth = MediaQuery.of(context).size.height;
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
                  context.pop("value");
                },
                icon: const Icon(Icons.arrow_back_ios)),
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
      body: ListView(
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
                      style: TextStyle(color: Colors.white, fontSize: 22.sp),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  searchBar(context, model?.ocupado ?? false, height),
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao buscar equipamentos'));
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {});
                      });
                      return Container(
                        color: Colors.amber,
                        height: height - kToolbarHeight - 115.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
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
                            itemCount: model
                                ?.itensEquipamentoModels.equipamentos.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Container(
                                height: 300,
                                width: 100,
                                color: Colors.black,
                              );
                              // _buildCard(
                              //     model!.itensEquipamentoModels.equipamentos[index]);
                            },
                          ),
                        ),
                      );
                    }
                }
              }),
        ],
      ),
    );
  }

  Padding searchBar(BuildContext context, bool ocupado, double? height) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
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
              _future = consultaController.buscarEquipamentos(context, model!);
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
  const CardEquipamentosResultadoLevantamento({required this.item, super.key});

  final ItemEquipamento item;
  // final String? patrimonio, lotacao, marca, tipoEquipamento, tag;

  @override
  Widget build(BuildContext context) {
    debugPrint("criando o card");
    return Container(
      height: 300,
      child: Material(
        color: AppColors.contentColorBlack,
        elevation: 7,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 3.h),
              Row(
                children: [
                  Text("Patr. ", style: Styles().hintTextStyle()),
                  Flexible(
                    child: SizedBox(
                      child: Text(
                        item.patrimonioSsp ?? "",
                        style: Styles().smallTextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
              // Text(marca ?? "Sem marca", style: Styles().smallTextStyle()),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Image.asset(
                  AppName.fotoEquipamento(item.tipoEquipamento!),
                  height: 60.h,
                ),
              ),
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
                          Text("TAG: ", style: Styles().hintTextStyle()),
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
              SizedBox(height: 3.h),
            ],
          ),
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


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:suporte_dti/utils/app_colors.dart';
// import 'package:suporte_dti/utils/app_styles.dart';

// class LevantamentoDigitado extends StatefulWidget {
//   const LevantamentoDigitado({super.key});

//   @override
//   State<LevantamentoDigitado> createState() => _LevantamentoDigitadoState();
// }

// class _LevantamentoDigitadoState extends State<LevantamentoDigitado> {
//   TextEditingController equipamentoCtrl = TextEditingController();
//   TextEditingController marcaCtrl = TextEditingController();
//   TextEditingController serviceTagCtrl = TextEditingController();
//   TextEditingController lotacaoCtrl = TextEditingController();
//   TextEditingController setorCtrl = TextEditingController();
//   TextEditingController lacreCtrl = TextEditingController();
//   TextEditingController convenioCtrl = TextEditingController();
//   TextEditingController patrimonioCtrl = TextEditingController();
//   bool isLacre = false;
//   bool isConvenio = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.white),
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: const Icon(Icons.arrow_back_ios_new)),
//           title: Text("Levantamento",
//               style: Styles().titleStyle().copyWith(
//                   color: AppColors.cWhiteColor,
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.normal)),
//           centerTitle: true,
//           backgroundColor: AppColors.cSecondaryColor,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 10.sp),
//               Row(
//                 children: [
//                   SizedBox(width: 10.w),
//                   Text(
//                     "Possui convênio?",
//                     style: Styles().smallTextStyle(),
//                   ),
//                   Transform.scale(
//                     scale: 0.8,
//                     child: Switch(
//                         activeColor: AppColors.cSecondaryColor,
//                         value: isConvenio,
//                         onChanged: (value) {
//                           setState(() {
//                             isConvenio = value;
//                           });
//                         }),
//                   ),
//                   const Expanded(child: SizedBox(width: 30)),
//                   Text(
//                     "Possui Lacre?",
//                     style: Styles().smallTextStyle(),
//                   ),
//                   Transform.scale(
//                     scale: 0.8,
//                     child: Switch(
//                         activeColor: AppColors.cSecondaryColor,
//                         value: isLacre,
//                         onChanged: (value) {
//                           setState(() {
//                             isLacre = value;
//                           });
//                         }),
//                   ),
//                   SizedBox(width: 10.w),
//                 ],
//               ),
//               FieldsLevantamentoDigitado(
//                 lotacaoCtrl: lotacaoCtrl,
//                 tipo: "Lotação",
//               ),
//               FieldsLevantamentoDigitado(
//                 lotacaoCtrl: setorCtrl,
//                 tipo: "Setor",
//               ),
//               FieldsLevantamentoDigitado(
//                 lotacaoCtrl: equipamentoCtrl,
//                 tipo: "Equipamento",
//               ),
//               FieldsLevantamentoDigitado(
//                   lotacaoCtrl: marcaCtrl,
//                   tipo: "Marca-Modelo",
//                   keyboardType: TextInputType.visiblePassword),
//               FieldsLevantamentoDigitado(
//                   lotacaoCtrl: patrimonioCtrl,
//                   tipo: "Patrimônio",
//                   keyboardType: TextInputType.visiblePassword),
//               FieldsLevantamentoDigitado(
//                   lotacaoCtrl: serviceTagCtrl,
//                   tipo: "Sn - Service Tag",
//                   keyboardType: TextInputType.visiblePassword),
//               isConvenio == true
//                   ? FieldsLevantamentoDigitado(
//                       lotacaoCtrl: convenioCtrl,
//                       tipo: "Convênio",
//                       keyboardType: TextInputType.number)
//                   : Container(),
//               isLacre == true
//                   ? FieldsLevantamentoDigitado(
//                       lotacaoCtrl: lacreCtrl,
//                       tipo: "Lacre",
//                       keyboardType: TextInputType.number)
//                   : Container(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                           backgroundColor: AppColors.cSecondaryColor,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10))),
//                       onPressed: () {
//                         //  context.go(AppRouterName.homeController);
//                       },
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.plus_one,
//                             color: Colors.white,
//                           ),
//                           Container(width: 10.w),
//                           Text(
//                             "Outro",
//                             style: Styles()
//                                 .mediumTextStyle()
//                                 .copyWith(color: Colors.white),
//                           )
//                         ],
//                       )),
//                   OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10))),
//                       onPressed: () {
//                         //context.push(AppRouterName.homeController);
//                       },
//                       child: Row(
//                         children: [
//                           const Icon(Icons.check),
//                           Container(width: 10.w),
//                           Text("Concluir", style: Styles().mediumTextStyle())
//                         ],
//                       )),
//                 ],
//               ),
//               Container(height: 20.h)
//             ],
//           ),
//         ));
//   }
// }

// class FieldsLevantamentoDigitado extends StatelessWidget {
//   const FieldsLevantamentoDigitado(
//       {super.key,
//       required this.lotacaoCtrl,
//       required this.tipo,
//       this.keyboardType});

//   final TextEditingController lotacaoCtrl;
//   final String tipo;
//   final TextInputType? keyboardType;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
//       child: TextFormField(
//         textInputAction: TextInputAction.next,
//         controller: lotacaoCtrl,
//         keyboardType: keyboardType ?? TextInputType.name,
//         decoration: InputDecoration(
//             alignLabelWithHint: true,
//             labelText: tipo,
//             labelStyle: Styles().mediumTextStyle(),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: const BorderSide(
//                     color: AppColors.cSecondaryColor, width: 2)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: const BorderSide(
//                     color: AppColors.cSecondaryColor, width: 2))),
//       ),
//     );
//   }
// }
