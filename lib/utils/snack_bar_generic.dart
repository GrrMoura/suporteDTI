import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class Generic {
  static snackBar({
    required BuildContext context,
    required String conteudo,
    Color? color,
    SnackBarBehavior? barBehavior,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(conteudo, style: Styles().errorTextStyle()),
        padding: EdgeInsets.only(bottom: 5.h, left: 10.w, top: 5.w, right: 0),
        elevation: 30,
        margin: barBehavior == SnackBarBehavior.floating
            ? EdgeInsets.fromLTRB(20.w, 1, 20.w, 30.h)
            : null,
        backgroundColor: color ?? Colors.red,
        behavior: barBehavior ?? SnackBarBehavior.fixed));
  }
}
