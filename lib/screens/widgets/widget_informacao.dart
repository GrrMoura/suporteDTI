import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class InformacaoDetalhes extends StatelessWidget {
  const InformacaoDetalhes({
    required this.informacao,
    required this.titulo,
    super.key,
  });

  final String titulo, informacao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Styles().subTitleDetail()),
          Text(informacao,
              style: Styles().descriptionDetail().copyWith(
                    fontSize: informacao.length >= 15 ? 15 : 20,
                  )),
        ],
      ),
    );
  }
}
