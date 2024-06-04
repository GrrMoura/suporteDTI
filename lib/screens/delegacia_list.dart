import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/consulta_controller.dart';
import 'package:suporte_dti/model/itens_delegacia_model.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/viewModel/delegacias_view_model.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class DelegaciaListScreen extends StatefulWidget {
  final DelegaciasViewModel? model;
  const DelegaciaListScreen({super.key, this.model});

  @override
  State<DelegaciaListScreen> createState() => _DelegaciaListScreenState();
}

class _DelegaciaListScreenState extends State<DelegaciaListScreen> {
  ScrollController? _scrollController;
  ConsultaController consultaController = ConsultaController();

  EquipamentoViewModel? modelEquipamento = EquipamentoViewModel(
      itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []));

  DelegaciasViewModel? model = DelegaciasViewModel(
      itensDelegaciaModel: ItensDelegaciaModel(delegacias: []));

  List<ItemDelegacia> delegacias = <ItemDelegacia>[];
  bool inicio = true;

  // Widget _buildCard(ItemDelegacia item) {
  //   return InkWell(
  //       onTap: () {

  //       },
  //       child: cardDelegacia(context, ItemDelegacia item));
  // }

  Widget _listViewScreen() {
    double screenHeight = MediaQuery.of(context).size.height;
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
                    left: 120.w,
                    right: 120.w,
                    top: 0.h,
                    child: Text(
                      "Resultado",
                      style: TextStyle(color: Colors.white, fontSize: 22.sp),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(query: value);
              },
              //   controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Pesquisar",
                  hintText: "Nome, sigla, n°",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
            ),
          ),
          inicio == true
              ? SizedBox(
                  height: screenHeight,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      controller: _scrollController,
                      itemCount:
                          widget.model?.itensDelegaciaModel!.delegacias.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return cardDelegacia(
                            context,
                            widget
                                .model!.itensDelegaciaModel!.delegacias[index]);
                      },
                    ),
                  ),
                )
              : SizedBox(
                  height: screenHeight - 220.h,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      controller: _scrollController,
                      itemCount: delegacias.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return cardDelegacia(context, delegacias[index]);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
  // TODO: SABER COMO BLOQUEAR UMA VERSÃO DO ANDROID DE BAIXAR O APP

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    FutureBuilder _futureScreen() {
      return FutureBuilder(
          future: consultaController.buscarDelegacias(context, widget.model!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return _listViewScreen();
              // TALVEZ DE ERRO.

              default:
                return const LoadingDefault();
            }
          });
    }

    return Validador.listNotNullAndNotEmpty(
            widget.model?.itensDelegaciaModel?.delegacias)
        ? _listViewScreen()
        : _futureScreen();
  }

  Padding cardDelegacia(BuildContext context, ItemDelegacia item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0, right: 5.w, left: 5.w),
      child: SizedBox(
        height: 90.h,
        child: Card(
            color: Colors.white,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              onTap: () async {
                modelEquipamento!.idUnidade = item.id;

                context.push(AppRouterName.delegaciaDetalhe,
                    extra: {"model": modelEquipamento, "sigla": item.sigla});
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.sigla == null ? "Não informado" : item.sigla!,
                      style: Styles()
                          .descriptionDetail()
                          .copyWith(fontSize: 12.sp),
                    ),
                    Text(
                      item.nome!,
                      style: Styles()
                          .smallTextStyle()
                          .copyWith(fontSize: item.nome!.length > 60 ? 11 : 13),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
  //widget                            .model!.itensDelegaciaModel!.delegacias

  filterSearchResults({required String query}) {
    inicio = false;
    List<ItemDelegacia> dummySearchList = <ItemDelegacia>[];
    // recebendo os dados da model ou banco para adicionar a lista falsa
    dummySearchList.addAll(widget.model!.itensDelegaciaModel!.delegacias);
    if (query.isNotEmpty) {
      List<ItemDelegacia> dummyListData = <ItemDelegacia>[];
      for (var item in dummySearchList) {
        if (item.nome!.toLowerCase().contains(query) ||
            item.sigla!.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        delegacias.clear();
        delegacias.addAll(dummyListData);
        if (dummyListData.isEmpty) {
          delegacias = [];
        }
      });
      return;
    } else {
      setState(() {
        inicio = true;
        delegacias.clear();
        delegacias.addAll(delegacias);
      });
    }
  }
}
