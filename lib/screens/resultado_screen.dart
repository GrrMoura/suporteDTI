import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/model/equipamentos_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/widgets/widget_gridview_itens.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

class ResultadoScreen extends StatelessWidget {
  ResultadoScreen({super.key, this.model});
  final List<Map> myProducts =
      List.generate(10, (index) => {"id": index, "name": "Produto $index"})
          .toList();
  final EquipamentosModel? model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const BoxSearchBar(),
          const Titulo(),
          GridviewEquipamentos(
              myProducts: myProducts,
              widget: const CardEquipamentosResultado(
                lotacao: "Lagarto",
                patrimonio: "172798",
                marca: "Dell/optiplex 3090",
                tag: "GN0N2D7T",
              )),
        ],
      ),
    ));
  }
}

class Titulo extends StatelessWidget {
  const Titulo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Text(
        "Resultados para \"Monitor\"  ",
        style: Styles()
            .subTitleStyle()
            .copyWith(color: AppColors.cDescriptionIconColor),
      ),
    );
  }
}

class BoxSearchBar extends StatelessWidget {
  const BoxSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Stack(
        children: [
          Container(
            height: 180.h,
            width: double.infinity,
            color: AppColors.cSecondaryColor,
          ),
          Positioned(
              top: 30.h,
              child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 25.sp,
                    color: Colors.white,
                  ))),
          Positioned(
            left: 30.w,
            top: 70.h,
            right: 30.w,
            bottom: 80.h,
            child: SearchBar(
              textStyle: MaterialStateProperty.all(
                Styles().mediumTextStyle(),
              ),
              side: MaterialStateProperty.all(
                const BorderSide(color: Colors.grey),
              ),
              elevation: MaterialStateProperty.all(10),
              trailing: [
                IconButton(
                    icon: Icon(Icons.close, size: 22.sp), onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.tune, size: 22.sp), onPressed: () {}),
              ],
              leading: Icon(Icons.search, size: 22.sp),
              backgroundColor: MaterialStateProperty.all(AppColors.cWhiteColor),
              constraints: BoxConstraints(maxWidth: 300.w),
              shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class CardEquipamentosResultado extends StatelessWidget {
  const CardEquipamentosResultado(
      {required this.lotacao,
      required this.patrimonio,
      required this.marca,
      required this.tag,
      super.key});

  final String? patrimonio, lotacao, marca, tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRouterName.detalhe);
      },
      //TODO colocar a opção de escolher qual o dado que quer copiar
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: patrimonio!));
        Generic.snackBar(
            color: Colors.blue,
            context: context,
            conteudo: "Copiado para área de transferência",
            barBehavior: SnackBarBehavior.floating);
      },
      child: Material(
        color: AppColors.cWhiteColor,
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 3.h),
              Text(marca ?? "Sem marca", style: Styles().smallTextStyle()),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Image.asset("assets/images/nobreak.jpg", height: 70.h),
              ),
              LinhaDescricao(informacao: patrimonio, nome: "Patrimônio"),
              LinhaDescricao(informacao: lotacao, nome: "Lotação"),
              LinhaDescricao(informacao: tag, nome: "TAG"),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}

class LinhaDescricao extends StatelessWidget {
  const LinhaDescricao(
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
                style: Styles().smallTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
