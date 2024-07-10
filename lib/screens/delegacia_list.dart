import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/delegacia_controller.dart';
import 'package:suporte_dti/model/itens_delegacia_model.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';

import 'package:suporte_dti/viewModel/delegacias_view_model.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class DelegaciaListScreen extends StatefulWidget {
  final DelegaciasViewModel? model;

  const DelegaciaListScreen({super.key, this.model});

  @override
  State<DelegaciaListScreen> createState() => _DelegaciaListScreenState();
}

class _DelegaciaListScreenState extends State<DelegaciaListScreen> {
  final DelegaciaController _delegaciaController = DelegaciaController();
  EquipamentoViewModel? modelEquipamento;
  DelegaciasViewModel? model;
  List<ItemDelegacia> delegacias = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    modelEquipamento = EquipamentoViewModel(
      itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []),
    );
    model = DelegaciasViewModel(
      itensDelegaciaModel: ItensDelegaciaModel(delegacias: []),
    );

    // Realiza a busca inicial apenas se o modelo de delegacias estiver vazio
    if (widget.model?.itensDelegaciaModel?.delegacias.isEmpty ?? true) {
      _fetchDelegacias();
    } else {
      delegacias.addAll(widget.model!.itensDelegaciaModel!.delegacias);
      _loading = false;
    }
  }

  Future<void> _fetchDelegacias() async {
    try {
      await _delegaciaController.buscarDelegacias(context, widget.model!);
      setState(() {
        delegacias.addAll(widget.model!.itensDelegaciaModel!.delegacias);
        _loading = false;
      });
    } catch (e) {
      // Tratar erro conforme necessário
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight - kToolbarHeight - 40.h,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(query: value);
              },
              decoration: const InputDecoration(
                labelText: "Pesquisar",
                hintText: "Nome, sigla,",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading ? const LoadingDefault() : _buildDelegaciasList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDelegaciasList() {
    return delegacias.isEmpty
        ? Center(
            child: Text(
              "Nenhum resultado encontrado.",
              style: TextStyle(fontSize: 16.sp),
            ),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: delegacias.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return _buildCardDelegacia(delegacias[index], index);
            },
          );
  }

  Widget _buildCardDelegacia(ItemDelegacia item, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
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
            context.push(
              AppRouterName.delegaciaDetalhe,
              extra: {
                "model": modelEquipamento,
                "sigla": item.sigla,
                "nome": item.nome,
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.sigla == null ? "Não informado" : item.sigla!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.nome!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void filterSearchResults({required String query}) {
    setState(() {
      delegacias.clear();
      List<ItemDelegacia> dummySearchList =
          List.from(widget.model!.itensDelegaciaModel!.delegacias);
      if (query.isNotEmpty) {
        dummySearchList.removeWhere((item) =>
            !item.nome!.toLowerCase().contains(query) &&
            !item.sigla!.toLowerCase().contains(query));
      }
      delegacias.addAll(dummySearchList);
    });
  }
}
