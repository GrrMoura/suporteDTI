// ignore_for_file: must_be_immutable

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/screens/qr_code_scanner_screen.dart';
import 'package:suporte_dti/screens/search_screen.dart';
import 'package:suporte_dti/utils/app_colors.dart';

class HomeControler extends StatefulWidget {
  const HomeControler({super.key});
  // final LoginViewModel loginViewModel;

  @override
  State<HomeControler> createState() => _HomePageState();
}

class _HomePageState extends State<HomeControler> {
  int selectedPage = 0;

  late List<StatefulWidget> pageList = [
    const SearchScreen(),
    const QrCodeScanner(),
    //const LoginScreen(),

    //   const PerfilPage()
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   print("pssei aqui !!!");
  //   print(widget.nome);

  //   name = widget.nome;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageList[selectedPage],
        bottomNavigationBar: StyleProvider(
            style: StyleIconNavigator(),
            child: ConvexAppBar(
              height: 50.h,
              shadowColor: Colors.black38,
              activeColor: AppColors.cPrimaryColor,
              backgroundColor: AppColors.cSecondaryColor,
              elevation: 2,
              color: AppColors.cDescriptionIconColor,
              style: TabStyle.reactCircle,
              items: const [
                TabItem(icon: Icons.search_rounded),
                TabItem(icon: Icons.qr_code),
              ],
              initialActiveIndex: selectedPage,
              onTap: (int index) {
                setState(() {
                  selectedPage = index;
                });
              },
            )));
  }
}

class StyleIconNavigator extends StyleHook {
  @override
  double get activeIconSize => 45.sp;

  @override
  double get activeIconMargin => 8;

  @override
  double get iconSize => 30.sp;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 20.sp, color: color);
  }
}
