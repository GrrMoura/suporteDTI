import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/utils/app_colors.dart';

class GeneriAuxAppBar extends StatelessWidget {
  const GeneriAuxAppBar({super.key, required this.titulo});
  final String titulo;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.cSecondaryColor,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Center(
              child: Text(
                titulo,
                style: TextStyle(color: Colors.white, fontSize: 22.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
