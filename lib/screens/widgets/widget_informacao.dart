import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: Styles().subTitleDetail()),
        Text(informacao, style: Styles().descriptionDetail()),
      ],
    );
  }
}
