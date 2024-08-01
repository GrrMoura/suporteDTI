import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/model/itens_delegacia_model.dart';
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
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  late List<EquipamentoModel> equipamentoList;
  EquipamentoViewModel? model = EquipamentoViewModel(
    itensEquipamentoModels: ItensEquipamentoModels(equipamentos: []),
  );

  String name = "", cpf = "";
  SqliteService db = SqliteService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nome1 = prefs.getString("nome") ?? "";
    String? nome2 = prefs.getString("segundoNome") ?? "";
    String? cpfs = prefs.getString("cpf") ?? "";

    setState(() {
      name = "$nome1 $nome2";
      cpf = cpfs;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return isLoading == false
        ? Scaffold(
            backgroundColor: AppColors.cPrimaryColor,
            body: SizedBox(
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeading(),
                    const FastSearch(),
                    _buildSearchBar(context),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            ),
          )
        : const LoadingDefault();
  }

  Widget _buildHeading() {
    return Container(
      color: AppColors.cSecondaryColor,
      height: 160.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 45.h,
                backgroundColor: AppColors.cWhiteColor,
                child: CircleAvatar(
                  backgroundColor: AppColors.cSecondaryColor,
                  radius: 40.h,
                  backgroundImage: AssetImage(AppName.semFoto!),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: Styles().titleStyle().copyWith(
                            fontSize: name.length > 18 ? 14.sp : 20.sp,
                          ),
                    ),
                    Text(cpf, style: Styles().subTitleStyle()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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
          onChanged: (value) {
            model!.descricao = value;
          },
          onFieldSubmitted: (value) async {
            if (value.isNotEmpty) {
              if (context.mounted) {
                context.push(AppRouterName.resultadoEquipamentoConsulta,
                    extra: model);
              } else {
                if (context.mounted) {
                  Generic.snackBar(
                      context: context, mensagem: "Tente novamente");
                }
              }
            } else {
              Generic.snackBar(
                context: context,
                mensagem: "O campo \"pesquisa\" precisa ser preenchido!",
              );
            }
          },
          decoration: InputDecoration(
            fillColor: AppColors.cWhiteColor,
            filled: true,
            isDense: true,
            hintText: 'Patrimônio, Marca, Tipo, Modelo, Tag...',
            hintStyle: Styles().hintTextStyle(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 25.sp,
              color: AppColors.cDescriptionIconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class FastSearch extends StatelessWidget {
  const FastSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 5.w),
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
            const PesquisarDelegacias(),
          ],
        ),
      ),
    );
  }
}

class PesquisarDelegacias extends StatelessWidget {
  const PesquisarDelegacias({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              context.push(AppRouterName.delegaciaLista,
                  extra: DelegaciasViewModel(
                    itensDelegaciaModel: ItensDelegaciaModel(delegacias: []),
                  ));
            },
            child: Container(
              height: 75.h,
              width: 75.w,
              decoration: BoxDecoration(
                color: AppColors.cSecondaryColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  )
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AppName.add!),
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text("OUTRA", style: Styles().smallTextStyle()),
        ],
      ),
    );
  }
}

class DelegaciasIcones extends StatelessWidget {
  final String? path;
  final String? name;

  const DelegaciasIcones({
    required this.path,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sp),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          int? idUnidade;
          switch (name) {
            case "DP Lagarto":
              idUnidade = 468;
              break;
            case "DEOTAP":
              idUnidade = 63;
              break;
            case "DP Itabaiana":
              idUnidade = 102;
              break;
          }
          if (idUnidade != null) {
            context.push(
              AppRouterName.delegaciaDetalhe,
              extra: {
                "model": EquipamentoViewModel(
                  itensEquipamentoModels:
                      ItensEquipamentoModels(equipamentos: []),
                  idUnidade: idUnidade,
                ),
                "sigla": name,
                "nome": "",
              },
            );
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
              height: 75.h,
              width: 75.w,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  )
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(path!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(name!, style: Styles().smallTextStyle()),
          ],
        ),
      ),
    );
  }
}
