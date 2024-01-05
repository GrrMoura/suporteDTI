import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class ResultadoScreen extends StatelessWidget {
  ResultadoScreen({super.key});
  final List<Map> myProducts =
      List.generate(5, (index) => {"id": index, "name": "Produto $index"})
          .toList();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const BoxSearchBar(),
          const Titulo(),
          GridviewEquipamentos(height: height, myProducts: myProducts),
        ],
      ),
    ));
  }
}

class GridviewEquipamentos extends StatelessWidget {
  const GridviewEquipamentos({
    super.key,
    required this.height,
    required this.myProducts,
  });

  final double height;
  final List<Map> myProducts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SizedBox(
        height: height - 200.h - 70.h,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.sp,
                childAspectRatio: 1.05,
                crossAxisSpacing: 5.sp,
                mainAxisSpacing: 10.sp),
            itemCount: myProducts.length,
            itemBuilder: (BuildContext ctx, index) {
              return const CardEquipamentosResultado(
                lotacao: "Lagarto",
                patrimonio: "172798",
                marca: "Dell/optiplex 3090",
                tag: "BR2313NC",
              );
              //  child: Text(myProducts[index]["name"]),
            }),
      ),
    );
  }
}

class Titulo extends StatelessWidget {
  const Titulo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
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
            height: 200.h,
            width: double.infinity,
            color: AppColors.cSecondaryColor,
          ),
          Positioned(
            left: 30.w,
            top: 70.h,
            right: 30.w,
            bottom: 80.h,
            child: SearchBar(
              textStyle: MaterialStateProperty.all(Styles().mediumTextStyle()),
              side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.grey)),
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
      Key? key})
      : super(key: key);

  final String? patrimonio, lotacao, marca, tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //TODO colocar a opção de escolher qual o dado que quer copiar
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: patrimonio!));
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
        child: Material(
          color: AppColors.cWhiteColor,
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.grey,
          child: Column(
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
              SizedBox(height: 3.h)
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
          Text(informacao ?? "Sem número", style: Styles().smallTextStyle()),
        ],
      ),
    );
  }
}
