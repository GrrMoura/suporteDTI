import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Generic {
  static void snackBar(
      {required BuildContext context,
      required String mensagem,
      String? tipo = "erro",
      int duracaoFixa = 3,
      int? duracao}) {
    switch (tipo) {
      case "erro":
        showTopSnackBar(
            displayDuration: Duration(seconds: duracao ?? duracaoFixa),
            Overlay.of(context),
            CustomSnackBar.error(message: mensagem));
        break;

      case "sucesso":
        showTopSnackBar(
            displayDuration: Duration(seconds: duracao ?? duracaoFixa),
            Overlay.of(context),
            CustomSnackBar.success(message: mensagem));
        break;
      case "info":
        showTopSnackBar(
            displayDuration: Duration(seconds: duracao ?? duracaoFixa),
            Overlay.of(context),
            CustomSnackBar.info(message: mensagem));
        break;
      default:
    }
    //tipo == sucesso, info ou erro
  }
}
