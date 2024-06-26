// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/model/itens_delegacia_model.dart';
import 'package:suporte_dti/utils/app_colors.dart';

import 'package:suporte_dti/utils/app_styles.dart';

class LevantamentoScreen extends StatefulWidget {
  const LevantamentoScreen({super.key});

  @override
  State<LevantamentoScreen> createState() => _LevantamentoScreenState();
}

class _LevantamentoScreenState extends State<LevantamentoScreen> {
  late List<ItensDelegaciaModel> delegaciaList;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.cWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text("Levantamento",
            style: Styles().titleStyle().copyWith(
                color: AppColors.cWhiteColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.normal)),
        centerTitle: true,
        backgroundColor: AppColors.cSecondaryColor,
      ),
      body: SizedBox(
        height: height,
        child: Column(
          children: [
            SizedBox(
              height: height - kBottomNavigationBarHeight - kToolbarHeight,
              child: ListView.builder(
                itemCount: delegaciaList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                          height: 40.h,
                          child: Divider(indent: 55.w, endIndent: 55.w))
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardDelegaciasLevantamento extends StatelessWidget {
  const CardDelegaciasLevantamento(
      {super.key,
      required this.contato,
      required this.image,
      required this.delegacia});

  final String image, delegacia, contato;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 5.h, 30.w, 5.h),
      child: Column(
        children: [
          Card(
            elevation: 0,
            child: Row(
              children: [
                Container(
                  height: 55.h,
                  width: 55.w,
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
                            image,
                          ),
                          fit: BoxFit.cover)),
                ),
                Expanded(child: SizedBox(width: 2.w)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        delegacia,
                        style: Styles().mediumTextStyle().copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text(contato, style: Styles().smallTextStyle()),
                    ),
                  ],
                ),
                Expanded(child: SizedBox(width: 2.w)),
                Row(
                  children: [
                    const Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(
                      width: 5.w,
                    ),
                    const Icon(Icons.edit_outlined)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
