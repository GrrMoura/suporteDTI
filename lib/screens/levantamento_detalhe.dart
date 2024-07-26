// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suporte_dti/controller/levantamento_controller.dart';
import 'package:suporte_dti/model/levantamento_detalhe.dart';
import 'package:suporte_dti/screens/pdf_screen.dart';
import 'package:suporte_dti/utils/app_colors.dart';

class LevantamentoDetalheScreen extends StatefulWidget {
  final int idLevantamento;
  final String nomeArquivo;
  final bool assinado;

  const LevantamentoDetalheScreen(
      {super.key,
      required this.idLevantamento,
      required this.nomeArquivo,
      required this.assinado});

  @override
  LevantamentoDetalheScreenState createState() =>
      LevantamentoDetalheScreenState();
}

class LevantamentoDetalheScreenState extends State<LevantamentoDetalheScreen>
    with SingleTickerProviderStateMixin {
  final LevantamentoController _levantamentoController =
      LevantamentoController();
  DetalheLevantamentoModel? _detalheLevantamento;

  @override
  void initState() {
    super.initState();
    _carregarDetalhesLevantamento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            ' Detalhes Levantamento',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.cSecondaryColor,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
                onPressed: () {
                  widget.assinado
                      ? _downloadLevantamentoAssinado()
                      : _downloadLevantamento();
                },
                icon: const Icon(Icons.download))
          ],
        ),
        body: _detalheLevantamento == null
            ? const Center(
                child: SpinKitSpinningLines(
                    color: AppColors.contentColorBlue,
                    size: 120,
                    duration: Duration(milliseconds: 1500)),
              )
            : _buildDetalhes());
  }

  Widget _buildDetalhes() {
    final detalhes = _detalheLevantamento!.detalhes!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.assinado
              ? _buildInfoRow('Nome do Arquivo', widget.nomeArquivo)
              : _buildIUploadRow(),
          SizedBox(height: 16.h),
          _buildInfoRow('Data Levantamento',
              DateFormat('dd/MM/yyyy').format(detalhes.dataLevantamento!)),
          SizedBox(height: 30.h),
          Text(
            'Equipamentos Levantados',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.cSecondaryColor),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: detalhes.equipamentosLevantados!.length,
              itemBuilder: (context, index) {
                final equipamento = detalhes.equipamentosLevantados![index];
                return _buildEquipamentoTile(equipamento);
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildIUploadRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Cadastrar Levantamento Assinado ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.cSecondaryColor,
                fontSize: 18.sp),
          ),
          InkWell(
            child: IconButton(
                onPressed: () {
                  _downloadLevantamento();
                },
                icon: Icon(
                  Icons.upload,
                  size: 35.sp,
                )),
          )
        ],
      ),
    );
  }

  Future<void> _downloadLevantamento() async {
    _openPdf('');
    // try {
    //   var status = await Permission.storage.request();
    //   if (!status.isGranted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Permissão de armazenamento negada.'),
    //       ),
    //     );
    //     return;
    //   }

    //   // Inicia o download do PDF
    //   final fileName = await _levantamentoController.imprimirLevantamento(
    //       context, widget.idLevantamento);

    //   // Suponha que o arquivo foi salvo no diretório de downloads

    //   if (fileName != null) {
    //     // Use o nome do arquivo retornado
    //     final directory = await getExternalStorageDirectory();
    //     final filePath =
    //         '${directory?.path}/Download/$fileName'; // Caminho completo do arquivo

    //     if (await File(filePath).exists()) {
    //       _showDownloadOptions(filePath);
    //     } else {
    //       debugPrint('Arquivo não encontrado em: $filePath');
    //     }
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Erro ao fazer download do PDF: $e'),
    //     ),
    //   );
    // }
  }

  Future<void> _downloadLevantamentoAssinado() async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão de armazenamento negada.'),
          ),
        );
        return;
      }

      // Inicia o download do PDF
      final fileName = await _levantamentoController.imprimirLevantamento(
          widget.assinado, context, widget.idLevantamento);

      // Suponha que o arquivo foi salvo no diretório de downloads

      if (fileName != null) {
        // Use o nome do arquivo retornado
        final directory = await getExternalStorageDirectory();
        final filePath =
            '${directory?.path}/Download/$fileName'; // Caminho completo do arquivo

        if (await File(filePath).exists()) {
          _openPdf(filePath);
        } else {
          debugPrint('Arquivo não encontrado em: $filePath');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer download do PDF: $e'),
        ),
      );
    }
  }

  Future<void> _openPdf(String path) async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PdfViewerScreen(filePath: path)),
    );
  }

  Future<void> _carregarDetalhesLevantamento() async {
    try {
      final detalheLevantamento = await _levantamentoController
          .levantamentoDetalhe(context, widget.idLevantamento);
      if (detalheLevantamento != null) {
        setState(() {
          _detalheLevantamento = detalheLevantamento;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Detalhes do levantamento não encontrados'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar detalhes do levantamento: $e'),
        ),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.cSecondaryColor,
                fontSize: 18.sp),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          label == "Nome do Arquivo"
              ? InkWell(
                  child: IconButton(
                      onPressed: () {
                        _downloadLevantamento();
                        // _levantamentoController.downloadLevantamentoAssinado(
                        //     context, widget.idLevantamento);
                      },
                      icon: Icon(
                        Icons.download,
                        size: 35.sp,
                      )),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildEquipamentoTile(EquipamentoLevantado equipamento) {
    return Card(
      elevation: 2,
      color: AppColors.cSecondaryColor,
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      child: ListTile(
        title: Text(
          equipamento.descricao ?? 'Sem descrição',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          'Sala: ${equipamento.descricaoSala ?? 'Não especificada'}',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}
