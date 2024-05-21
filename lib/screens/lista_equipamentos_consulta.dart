import 'package:flutter/material.dart';
import 'package:suporte_dti/controller/consulta_controller.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/viewModel/consulta_view_model.dart';

class EquipamentoConsultaScreen extends StatefulWidget {
  final EquipamentoViewModel? model;
  const EquipamentoConsultaScreen({super.key, this.model});

  @override
  State<EquipamentoConsultaScreen> createState() =>
      _EquipamentoConsultaScreenState();
}

class _EquipamentoConsultaScreenState extends State<EquipamentoConsultaScreen> {
  ScrollController? _scrollController;
  var consultaController = ConsultaController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  // Controle do scroll: ao final do scroll é carregado novos elementos
  void _scrollListener() {
    if (_scrollController?.position.pixels ==
        _scrollController?.position.maxScrollExtent) {
      if (widget.model?.paginacao == null ||
          !widget.model!.paginacao!.seChegouAoFinalDaPagina()) {
        setState(() {});
        consultaController
            .buscarEquipamentos(context, widget.model!)
            .then((value) {
          setState(() {});
        });
      }
    }
  }

  Widget _buildRow(ItemEquipamento item) {
    return InkWell(
      onTap: () {
        setState(() {});
        consultaController.buscarEquipamentoPorId(context, item).then((value) {
          setState(() {});
        });
      },
      child: Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.descricao!,
                    style: Styles().descriptionDetail(),
                  ),
                  Text(item.patrimonioSSP ?? "")
                ],
              ),
            ),
            const SizedBox(
              height: 28,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
          ]),
        ),
        const Divider(
          color: Colors.amber,
        )
      ]),
    );
  }

  Widget _listViewScreen() {
    return Scaffold(
      backgroundColor: AppColors.cWhiteColor,
      appBar: AppBar(
        title: const Text("ola"),
      ),
      body: Center(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          controller: _scrollController,
          itemCount: widget.model?.itensEquipamentoModels?.equipamentos?.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return _buildRow(
                widget.model!.itensEquipamentoModels!.equipamentos![index]);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder _futureScreen() {
      return FutureBuilder(
          future: consultaController.buscarEquipamentos(context, widget.model!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Validador.listNotNullAndNotEmpty(widget
                        .model?.itensEquipamentoModels?.equipamentos ??= [])
                    ? _listViewScreen()
                    : const LoadingDefault(); // TALVEZ DE ERRO.

              default:
                return const LoadingDefault();
            }
          });
    }

    return Validador.listNotNullAndNotEmpty(
            widget.model?.itensEquipamentoModels?.equipamentos)
        ? _listViewScreen()
        : _futureScreen();
  }
}
