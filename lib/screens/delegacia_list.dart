import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/delegacia_controller.dart';
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
  final DelegaciaController _delegaciaController = DelegaciaController();

  EquipamentoViewModel? modelEquipamento = EquipamentoViewModel(
    itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []),
  );

  DelegaciasViewModel? model = DelegaciasViewModel(
    itensDelegaciaModel: ItensDelegaciaModel(delegacias: []),
  );

  List<ItemDelegacia> _delegacias = <ItemDelegacia>[];
  bool _inicio = true;

  Widget _listViewScreen() {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.cWhiteColor,
      appBar: AppBar(
        title: Text(
          "Resultado",
          style: TextStyle(color: Colors.white, fontSize: 22.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cSecondaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Correct usage of context
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox(
        height: screenHeight - kToolbarHeight - 40.h,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(query: value);
                },
                decoration: const InputDecoration(
                  labelText: "Pesquisar",
                  hintText: "Nome, sigla, n°",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            _inicio
                ? SizedBox(
                    height: screenHeight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        controller: _scrollController,
                        itemCount: widget
                            .model?.itensDelegaciaModel!.delegacias.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return cardDelegacia(
                            ctxt, // Pass ctxt as BuildContext
                            widget
                                .model!.itensDelegaciaModel!.delegacias[index],
                            index,
                          );
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
                        itemCount: _delegacias.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return cardDelegacia(
                            ctxt, // Pass ctxt as BuildContext
                            _delegacias[index],
                            index,
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder futureScreen() {
      return FutureBuilder(
        future: _delegaciaController.buscarDelegacias(context, widget.model!),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return _listViewScreen();
            default:
              return const LoadingDefault();
          }
        },
      );
    }

    return Validador.listNotNullAndNotEmpty(
            widget.model?.itensDelegaciaModel?.delegacias)
        ? _listViewScreen()
        : futureScreen();
  }

  Padding cardDelegacia(BuildContext context, ItemDelegacia item, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0, right: 5.w, left: 5.w),
      child: SizedBox(
        height: 90.h,
        child: Card(
          shadowColor: Colors.black,
          color: index.isEven
              ? AppColors.cSecondaryColor
              : AppColors.cSecondaryColor.withOpacity(0.85),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () async {
              modelEquipamento!.idUnidade = item.id;
              context.push(AppRouterName.delegaciaDetalhe, extra: {
                "model": modelEquipamento,
                "sigla": item.sigla,
                "nome": item.nome
              });
              //
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
              child: Column(
                children: [
                  Text(
                    item.sigla == null ? "Não informado" : item.sigla!,
                    style: Styles()
                        .descriptionDetail()
                        .copyWith(fontSize: 12.sp, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(""),
                      Icon(
                        Icons.arrow_outward_sharp,
                        color: AppColors.cWhiteColor,
                      )
                    ],
                  ),
                  Expanded(
                    child: Text(
                      item.nome!,
                      style: Styles().smallTextStyle().copyWith(
                            color: Colors.white,
                            fontSize: item.nome!.length > 40 ? 10 : 13,
                          ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void filterSearchResults({required String query}) {
    _inicio = false;
    List<ItemDelegacia> dummySearchList = <ItemDelegacia>[];
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
        _delegacias.clear();
        _delegacias.addAll(dummyListData);
        if (dummyListData.isEmpty) {
          _delegacias = [];
        }
      });
    } else {
      setState(() {
        _inicio = true;
        _delegacias.clear();
        _delegacias.addAll(dummySearchList);
      });
    }
  }
}
