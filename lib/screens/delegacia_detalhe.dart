// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:suporte_dti/controller/equipamento_controller.dart';
import 'package:suporte_dti/controller/levantamento_controller.dart';
import 'package:suporte_dti/data/sqflite_helper.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/model/levantamento_cadastrados_model.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/card_item.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class DelegaciaDetalhe extends StatefulWidget {
  final String? sigla;
  final String nome;
  final EquipamentoViewModel? model;

  const DelegaciaDetalhe(
      {super.key, this.sigla, required this.nome, this.model});

  @override
  State<DelegaciaDetalhe> createState() => _DelegaciaDetalheState();
}

class _DelegaciaDetalheState extends State<DelegaciaDetalhe> {
  DatabaseHelper _db = DatabaseHelper();
  final ScrollController _scrollCtrl = ScrollController();
  final EquipamentoController _equipamentoCtlr = EquipamentoController();
  final LevantamentoController _levantamentoCtrl = LevantamentoController();
  final LevantamentoModel _levantamentoModel = LevantamentoModel();
  late Future<LevantamentocadastradoModel?> _levantamentoFuture;
  bool existemEquipamentos = false;
  bool isLoading = false;

  final Map<int, bool> _isLoadingMap = {};
  double _levantamentoHeight = 450.h;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_scrollListener);
    _fetchEquipamento();
    _levantamentoFuture = _fetchLevantamentos();
    _temEquipamento();
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_scrollListener);
    _scrollCtrl.dispose();
    widget.model?.itensEquipamentoModels.equipamentos = [];
    widget.model?.paginacao?.pagina = 1;
    widget.model?.paginacao?.totalPaginas = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            widget.model?.paginacao?.pagina = 1;
            widget.model?.paginacao?.totalPaginas = 1;
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Text(
            widget.sigla ?? "",
            style: Styles().titleStyle().copyWith(
                  color: AppColors.cWhiteColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cSecondaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Text(
                    widget.nome,
                    style: Styles().smallTextStyle(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Titulos(nome: "  Levantamentos  "),
                addBotao(context),
              ],
            ),
            SizedBox(
              height: _levantamentoHeight,
              child: ListView(
                children: [
                  FutureBuilder<LevantamentocadastradoModel?>(
                    future: _levantamentoFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: const SpinKitSpinningLines(
                              color: AppColors.contentColorBlue,
                              size: 120,
                              duration: Duration(milliseconds: 1500)),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                "Erro ao carregar dados: ${snapshot.error}"));
                      } else if (!snapshot.hasData ||
                          snapshot.data?.cadastrados == null) {
                        return Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off,
                                  color: Colors.grey, size: 40),
                              Text(
                                "Nenhum levantamento encontrado",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              DelegaciasCardLevantamento(
                                idUnidade: widget.model!.idUnidade!,
                                nome: "",
                                idLevantamento: 0,
                                data: formatDate(),
                                delegacia: "Resumo",
                                quantEquipamento: 0,
                              )
                            ],
                          ),
                        );
                      } else {
                        List<Widget> levantamentosCards = [];
                        levantamentosCards.add(
                          DelegaciasCardLevantamento(
                            idUnidade: widget.model!.idUnidade!,
                            nome: "",
                            idLevantamento: 0,
                            data: formatDate(),
                            delegacia: "Resumo",
                            quantEquipamento: 0,
                          ),
                        );
                        for (var levantamento in snapshot.data!.cadastrados!) {
                          levantamentosCards.add(
                            DelegaciasCardLevantamento(
                              nomeArquivo: levantamento
                                  .levantamentoAssinado?.nomeArquivo,
                              idLevantamentoAssinado: levantamento
                                  .levantamentoAssinado?.idLevantamentoAssinado,
                              assinado: levantamento.assinado,
                              idUnidade: widget.model!.idUnidade!,
                              nome: levantamento.usuario!,
                              idLevantamento: levantamento.idLevantamento!,
                              data: levantamento.dataLevantamento!,
                              delegacia: "",
                              quantEquipamento:
                                  levantamento.quantidadeEquipamentos!,
                              nomeAssinado: levantamento
                                  .levantamentoAssinado?.usuarioAssinatura,
                            ),
                          );
                          //TODO: CONSERTAR ISSO AQUI, MUITO POLUIDO
                        }

                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: levantamentosCards,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            //TODO: CoLOCOAR O ICON DE COMPARTILHAR.
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Titulos(nome: formatEquipamentoInfo(widget.model!)),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                height: 500.h,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 220,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  controller: _scrollCtrl,
                  itemCount:
                      widget.model?.itensEquipamentoModels.equipamentos.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return _buildCard(
                        widget
                            .model!.itensEquipamentoModels.equipamentos[index],
                        index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding searchBar(BuildContext context, bool ocupado, double? height) {
    return Padding(
      padding:
          EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w, bottom: 10.h),
      child: TextFormField(
        style: Styles().mediumTextStyle(),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          widget.model!.patrimonioSSP = value;
        },
        onFieldSubmitted: ((valor) async {
          if (valor.isNotEmpty) {
            if (context.mounted) {
              setState(() {
                widget.model!.itensEquipamentoModels.equipamentos = [];
                isLoading = true;
              });

              await _equipamentoCtlr.buscarEquipamentos(context, widget.model!);

              setState(() {
                isLoading = false;
                if (widget.model!.itensEquipamentoModels.equipamentos.isEmpty) {
                  Generic.snackBar(
                      context: context,
                      mensagem: "Não foi encontrado nenhum equipamento",
                      tipo: AppName.info);
                }
              });
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
          hintText: 'Patrimônio, Tag, SEAD ',
          hintStyle: Styles().hintTextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          prefixIcon: Icon(Icons.search,
              size: 25.sp, color: AppColors.cDescriptionIconColor),
        ),
      ),
    );
  }

  String formatEquipamentoInfo(EquipamentoViewModel model) {
    int totalEquipamentos = model.itensEquipamentoModels.equipamentos.length;
    int totalRegistros =
        totalEquipamentos == 0 ? 0 : (model.paginacao?.registros ?? 0);

    return " $totalEquipamentos de $totalRegistros equipamentos  ";
  }

  Future<void> _temEquipamento() async {
    existemEquipamentos = await _db.temEquipamentosCadastrados();
    setState(() {});
  }

  Future<LevantamentocadastradoModel?> _fetchLevantamentos() async {
    try {
      final levantamento =
          await _levantamentoCtrl.buscarLevantamentoPorIdUnidade(
              context,
              LevantamentoModel(
                  idUnidadeAdministrativa: widget.model?.idUnidade));

      if (levantamento == null || levantamento.cadastrados == null) {
        setState(() {
          _levantamentoHeight = (230.h);
        });
      } else if (levantamento.cadastrados!.length <= 2) {
        setState(() {
          _levantamentoHeight = 280.h;
        });
      }
      return levantamento;
    } catch (e) {
      setState(() {
        _levantamentoHeight = (existemEquipamentos ? 200.h : 100.h);
      });
      return null;
    }
  }

  Future<void> _fetchEquipamento() async {
    try {
      _levantamentoModel.idUnidadeAdministrativa = widget.model!.idUnidade;
      await _equipamentoCtlr.buscarEquipamentos(context, widget.model!);

      setState(() {});
    } catch (e) {
      debugPrint("erro $e");
    }
  }

  void _scrollListener() {
    if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
      if (widget.model?.paginacao == null ||
          !widget.model!.paginacao!
              .seChegouAoFinalDaPagina(widget.model!.paginacao!.pagina!)) {
        _fetchEquipamento();
      } else {
        Generic.snackBar(
          context: context,
          mensagem: "A lista chegou ao fim.",
          tipo: AppName.info,
        );
      }
    }
  }

  Widget _buildCard(ItemEquipamento item, int index) {
    bool isLoading = _isLoadingMap[index] ??
        false; // Verifica se está carregando para o índice atual

    return InkWell(
      onTap: () async {
        if (_isLoadingMap[index] == true) return; // Evita múltiplas execuções

        setState(() {
          _isLoadingMap[index] =
              true; // Ativa o indicador de carregamento para o índice atual
        });

        try {
          await _equipamentoCtlr.buscarEquipamentoPorId(context, item);
        } catch (e) {
          debugPrint("Erro ao buscar equipamento por ID: $e");
        } finally {
          setState(() {
            _isLoadingMap[index] =
                false; // Desativa o indicador de carregamento para o índice atual após a resposta
          });
        }
      },
      child: isLoading
          ? const LoadingDefault()
          : CardEquipamentosResultado(item: item),
    );
  }

  String formatDate() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  InkWell addBotao(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        mostrarAlertaComImagens(context);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: Container(
          height: 30.h,
          width: 30.w,
          decoration: const BoxDecoration(
              color: AppColors.cSecondaryColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0.0, 2.0), //(x,y)
                    blurRadius: 6.0)
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("assets/images/add.png"),
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  fit: BoxFit.contain)),
        ),
      ),
    );
  }

  void mostrarAlertaComImagens(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(child: Text('Forma de criação')),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Selecione como quer iniciar.'),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 100.w,
                  width: 95.w,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.pop('value');
                      context.push(AppRouterName.levantamentoDigitadoScreen);
                    },
                    child: Image.asset(
                      AppName.teclado!,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(
                  width: 90.w,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      context.pop('value');
                      context.push(AppRouterName.qrCodeScanner);
                    },
                    child: Image.asset(AppName.qrCode!),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Titulos extends StatelessWidget {
  const Titulos({required this.nome, super.key});
  final String nome;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: IntrinsicWidth(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.fiber_manual_record, size: 12.sp),
              Text(
                nome,
                style: Styles().mediumTextStyle().copyWith(
                    color: Colors.black, fontSize: AppDimens.smallTextSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DelegaciasCardLevantamento extends StatelessWidget {
  const DelegaciasCardLevantamento(
      {super.key,
      this.assinado,
      this.nomeArquivo,
      this.idLevantamentoAssinado,
      required this.nome,
      required this.idLevantamento,
      required this.data,
      required this.delegacia,
      required this.idUnidade,
      this.nomeAssinado,
      required this.quantEquipamento});

  final String nome;
  final int idLevantamento;
  final String data;
  final String delegacia;
  final int idUnidade;
  final int quantEquipamento;
  final bool? assinado;
  final int? idLevantamentoAssinado;
  final String? nomeArquivo;
  final String? nomeAssinado;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (delegacia == "Resumo") {
          context.push(AppRouterName.resumoLevantamento, extra: idUnidade);
        } else {
          context.push(AppRouterName.levantamentoDetalheScreen, extra: {
            'idLevantamento': idLevantamento,
            "nomeArquivo": nomeArquivo ?? "",
            'assinado': assinado ?? false
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 5,
          color: delegacia == "Resumo"
              ? AppColors.cSecondaryColor.withOpacity(0.6)
              : AppColors.cSecondaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      delegacia == "Resumo"
                          ? "Resumo"
                          : "Quantidade de Equipamento # $quantEquipamento",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Data: ${formatarData(data)}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    delegacia == "Resumo"
                        ? Container()
                        : Text(
                            "Levantado por ${formatarNome(nome)}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16.sp,
                            ),
                          ),
                    assinado == true
                        ? Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Text(
                              "Assinado: $nomeAssinado",
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Text(
                              "Não assinado",
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatarNome(String nomeCompleto) {
    List<String> partes = nomeCompleto.split(' ');

    if (partes.length >= 2) {
      String primeiroNome = partes[0];
      String ultimoNome = partes[partes.length - 1];
      return '$primeiroNome $ultimoNome';
    } else {
      return nomeCompleto;
    }
  }

  String formatarData(String data) {
    List<String> partes = data.split('/');
    String dia = partes[0];
    String mes = partes[1];
    String ano = partes[2];

    String anoFormatado = ano.substring(2);

    return '$dia/$mes/$anoFormatado';
  }
}
