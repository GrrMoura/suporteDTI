// ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers, avoid_print, must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/model/itens_delegacia_model.dart';
import 'package:suporte_dti/model/equipamentos_historico_model.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/services/sqlite_service.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/delegacias_view_model.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<EquipamentoModel> equipamentoList;
  EquipamentosHistoricoModel historicoModel = EquipamentosHistoricoModel();
  EquipamentoViewModel? model = EquipamentoViewModel(
      itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []));

  String name = "oi", cpf = "";

  SqliteService db = SqliteService();
  // ignore: prefer_typing_uninitialized_variables

  @override
  initState() {
    super.initState();

    pegarIdentificacao();
  }

  void pegarIdentificacao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nome1 = prefs.getString("nome");
    String? nome2 = prefs.getString("segundoNome");
    String? cpfs = prefs.getString("cpf");
    String _nome = "$nome1 $nome2";
    String _cpf = cpfs!;
    name = _nome;
    cpf = _cpf;
    setState(() {});
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
                    const FastSearch(),
                    searchBar(context, model?.ocupado ?? false),
                    SizedBox(height: 25.h),
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
                if (!teveConflito) {
                  validateInput(value);
                }
              });

              if (context.mounted) {
                //   model!.idUnidade = null;
                context.push(AppRouterName.resultadoEquipamentoConsulta,
                    extra: model);
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
                child: CircleAvatar(
                    backgroundColor: AppColors.cSecondaryColor,
                    radius: 40.h,
                    backgroundImage: AssetImage(AppName.semFoto!)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(name,
                            style: Styles().titleStyle().copyWith(
                                  fontSize: name.length >= 17 ? 16.sp : 22.sp,
                                ))),
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
}

class FastSearch extends StatelessWidget {
  const FastSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: SizedBox(
          height: 107.h,
          width: double.infinity,
          child: Row(
            children: [
              DelegaciasIcones(
                path: AppName.dpLagarto,
                name: "DP Lagarto",
              ),
              DelegaciasIcones(
                path: AppName.dpItabaiana,
                name: "DP Itabaiana",
              ),
              DelegaciasIcones(
                path: AppName.dpDeotap,
                name: "DEOTAP",
              ),
              PesquisarDelegacias()
            ],
          )),
    );
  }
}

class PesquisarDelegacias extends StatelessWidget {
  PesquisarDelegacias({super.key});

  DelegaciasViewModel delegaciasViewModel = DelegaciasViewModel(
      itensDelegaciaModel: ItensDelegaciaModel(delegacias: []));

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
              context.push(AppRouterName.delegaciaLista,
                  extra: delegaciasViewModel);
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

class DelegaciasIcones extends StatelessWidget {
  final String? path;
  final String? name;

  EquipamentoViewModel? model = EquipamentoViewModel(
      itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []));

  DelegaciasIcones({
    required this.path,
    required this.name,
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
          if (context.mounted) {
            switch (name) {
              case "DP Lagarto":
                model!.idUnidade = 468;
                break;
              case "DEOTAP":
                model!.idUnidade = 63;
                break;
              case "DP Itabaiana":
                model!.idUnidade = 102;
                break;

              default:
            }
            context.push(AppRouterName.delegaciaDetalhe,
                extra: {"model": model, "sigla": name, "nome": ""});
          } else {
            Generic.snackBar(
              context: context,
              mensagem: "Tente novamente",
            );
          }
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
