import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/data/delegacia_data.dart';
import 'package:suporte_dti/data/equipamentos_data.dart';
import 'package:suporte_dti/model/equipamentos_model.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

import '../model/delegacia_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<DelegaciaModel> delegaciaList;
  late List<EquipamentosModel> equipamentoList;
  @override
  initState() {
    super.initState();

    delegaciaList = delegaciaData;
    todosOsEquipamentos = equipamentosData;
  }

  List<EquipamentosModel> todosOsEquipamentos = [];
  List<EquipamentosModel> _acharEquipamentos = [];

  void _runFilter(String enteredKeyword) {
    // List<EquipamentosModel> results = [];
    // if (enteredKeyword.isEmpty) {
    //   results = todosOsEquipamentos;
    // } else {
    //   results = todosOsEquipamentos
    //       .where((equipamento) => equipamento.patrimonio
    //           .toLowerCase()
    //           .contains(enteredKeyword.toLowerCase()))
    //       .toList();
    // }

    // setState(() {
    //   _acharEquipamentos = results;
    // });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppColors.cPrimaryColor,
        body: Container(
          height: height,
          child: Column(
            children: [
              heading(),
              pesquisaRapida(),
              Padding(
                padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.cSecondaryColor,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    style: Styles().mediumTextStyle(),
                    onChanged: _runFilter,
                    decoration: InputDecoration(
                      fillColor: AppColors.cWhiteColor,
                      filled: true,
                      isDense: true,
                      hintText: 'Patrimônio, Marca, Tipo, Modelo, Tag...',
                      hintStyle: Styles().hintTextStyle(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      prefixIcon: Icon(Icons.search,
                          size: 25.sp, color: AppColors.cDescriptionIconColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // !_acharEquipamentos.isNotEmpty
              //     ? ListView.builder(
              //         scrollDirection: Axis.horizontal,
              //         itemCount: _acharEquipamentos.length,
              //         itemBuilder: (context, index) => Card(
              //           key: ValueKey(_acharEquipamentos[index]),
              //           color: Colors.amberAccent,
              //           elevation: 4,
              //           margin: const EdgeInsets.symmetric(vertical: 10),
              //           child: ListTile(
              //             leading: Text(
              //               _acharEquipamentos[index].lotacao.toString(),
              //               style: const TextStyle(fontSize: 24),
              //             ),
              //             title: Text(_acharEquipamentos[index].patrimonio),
              //             subtitle: Text(
              //                 '${_acharEquipamentos[index].marcaModelo.toString()} years old'),
              //           ),
              //         ),
              //       )
              //     : const Text(
              //         'No results found',
              //         style: TextStyle(fontSize: 24),
              //       ),
            ],
          ),
        ));

    // Padding(
    //   padding: EdgeInsets.only(top: 10.h),
    //   child: SizedBox(
    //       height: 150.h,
    //       child: ListView(
    //         scrollDirection: Axis.horizontal,
    //         children: [cardUltimas(), cardUltimas()],
    //       )),
    // )
  }

  Padding cardUltimas() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0),
      child: Material(
        color: AppColors.cWhiteColor,
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.black,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Image.asset(
                  "assets/images/impressora.png",
                  height: 70.h,
                ),
              ),
              Text(
                "172671",
                style: Styles().smallTextStyle(),
              ),
              Text(
                "LAGARTO",
                style: Styles().smallTextStyle(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding pesquisaRapida() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: SizedBox(
        height: 107.h,
        width: double.infinity,
        child: ListView.builder(
          itemCount: delegaciaList.length,
          itemBuilder: (context, index) {
            final delegacia = delegaciaList[index];

            return DelegaciasIcones(
              path: delegacia.path,
              id: delegacia.id,
              name: delegacia.name,
              region: delegacia.region,
            );
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Container heading() {
    return Container(
      color: AppColors.cSecondaryColor,
      height: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 55.h,
                backgroundColor: AppColors.cWhiteColor,
                child: CircleAvatar(
                    radius: 50.h,
                    backgroundImage:
                        const AssetImage("assets/images/people1.jpg")),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Fabiana Maria",
                    style: Styles().titleStyle(),
                  ),
                  Row(
                    children: [
                      Text("DESENVOLVEDORA", style: Styles().subTitleStyle()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Text("-", style: Styles().subTitleStyle()),
                      ),
                      Text("1023322", style: Styles().subTitleStyle())
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DelegaciasIcones extends StatelessWidget {
  final String? path;
  final int? id;
  final String? name;
  final String? region;
  const DelegaciasIcones({
    required this.id,
    required this.path,
    required this.name,
    required this.region,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              height: 80.h,
              width: 80.w,
              decoration: BoxDecoration(
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

class SearchBar2 extends StatefulWidget {
  const SearchBar2({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar2> {
  String? query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      print(newQuery);
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.cSecondaryColor,
        ),
        padding: const EdgeInsets.all(8),
        child: TextField(
          style: Styles().mediumTextStyle(),
          onChanged: onQueryChanged,
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
}
