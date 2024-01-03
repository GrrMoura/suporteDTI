import 'package:flutter/material.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_dimens.dart';
import 'package:suporte_dti/utils/app_fonts.dart';

class Styles {
  Styles();

  TextStyle titleStyle() {
    return TextStyle(
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.normal,
        letterSpacing: AppDimens.espacamentoMedio,
        color: AppColors.cWhiteColor,
        fontFamily: AppFonts.poppinsRegular,
        fontSize: AppDimens.titleSize);
  }

  TextStyle subTitleStyle() {
    return const TextStyle(
        fontStyle: FontStyle.italic,
        letterSpacing: AppDimens.espacamentoPequeno,
        color: AppColors.cSubTitleColor,
        fontSize: AppDimens.subTextSize);
  }

  TextStyle mediumTextStyle() {
    return TextStyle(
        color: AppColors.cTextColor,
        fontSize: AppDimens.mediumTextSize,
        fontFamily: AppFonts.robotoMedium,
        fontWeight: FontWeight.w400,
        letterSpacing: AppDimens.espacamentoMedio);
  }

  TextStyle smallTextStyle() {
    return TextStyle(
      color: AppColors.cSecondaryColor,
      fontStyle: FontStyle.normal,
      fontSize: AppDimens.smallTextSize,
    );
  }

  TextStyle errorTextStyle() {
    return TextStyle(
        color: AppColors.cWhiteColor,
        fontSize: AppDimens.smallTextSize,
        fontWeight: FontWeight.w400);
  }

  TextStyle hintTextStyle() {
    return TextStyle(
        color: AppColors.cDescriptionIconColor,
        fontSize: AppDimens.smallTextSize,
        fontFamily: AppFonts.poppinsRegular,
        fontWeight: FontWeight.w400,
        letterSpacing: AppDimens.espacamentoPequeno);
  }
}
