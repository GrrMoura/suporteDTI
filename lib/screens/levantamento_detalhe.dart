// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _carregarDetalhesLevantamento();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {}

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
                  _downloadLevantamento();
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
            _selectedFile == null
                ? 'Cadastrar Levantamento Assinados'
                : 'Arquivo selecionado: ${_selectedFile!.path}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.cSecondaryColor,
                fontSize: 18.sp),
          ),
          InkWell(
            child: IconButton(
                onPressed: () {
                  debugPrint("apertei adqui");
                  _pickFile();
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
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      final filePath = await _levantamentoController.imprimirLevantamento(
          context: context,
          idLevantamento: widget.idLevantamento,
          assinado: widget.assinado);

      if (filePath != null) {
        if (await File(filePath).exists()) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("${widget.idLevantamento}", filePath);
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
