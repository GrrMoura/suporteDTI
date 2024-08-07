// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

class PdfViewerScreen extends StatelessWidget {
  final String filePath;

  const PdfViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Levantamento',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cSecondaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                _sharePdf(context: context, path: filePath);
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
      ),
    );
  }

  Future<void> _sharePdf(
      {required String path, required BuildContext context}) async {
    try {
      await Share.shareXFiles([XFile(path)]);
    } catch (e) {
      Generic.snackBar(
          context: context, mensagem: "Não foi possível compartilhar ");
    }
  }
}
