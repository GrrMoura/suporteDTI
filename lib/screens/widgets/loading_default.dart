import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:suporte_dti/utils/app_colors.dart';

class LoadingDefault extends StatelessWidget {
  // final bool _visible = true;
  const LoadingDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.cPrimaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitSpinningLines(
                  color: AppColors.contentColorBlue,
                  size: 120,
                  duration: Duration(milliseconds: 1500)),
            ],
          ),
        ),
      ),
    );
  }
}
