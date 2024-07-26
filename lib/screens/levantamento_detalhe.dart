// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/controller/levantamento_controller.dart';
import 'package:suporte_dti/controller/usuario_controller.dart';
import 'package:suporte_dti/model/levantamento_detalhe.dart';
import 'package:suporte_dti/screens/pdf_screen.dart';
import 'package:suporte_dti/screens/widgets/loading_default.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_mask.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/app_validator.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

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
  bool isBaixando = false;
  bool isEnviando = false;

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

  Future<void> _uploadFile(String path) async {
    setState(() {
      isEnviando = true;
    });

    await _levantamentoController.levantamentoCadastrarAssinado(
        context: context, idLevantamento: widget.idLevantamento, path: path);

    setState(() {
      _carregarDetalhesLevantamento();
      isEnviando = false;
    });
  }

  Future<String?> showCpfDialog(BuildContext context) async {
    final TextEditingController cpfController = TextEditingController();

    String? cpf;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: AppColors.cWhiteColor,
          title: const Text(
            'Usuário da Assinatura',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.business,
                color: AppColors.cSecondaryColor,
                size: 40,
              ),
              const SizedBox(height: 20),
              TextFormField(
                inputFormatters: [MaskUtils.maskFormatterCpf()],
                decoration: InputDecoration(
                  hintText: 'Informe o setor',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: AppColors.cSecondaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: AppColors.cSecondaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem retorno
              },
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              //TODO: AQUI
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                if (Validador.cpfIsValid(cpfController.text)) {
                  String nome = UsuarioController.pegarDadosDoUsuarioPeloCpf(
                          context, cpfController.text)
                      .then((value) {});

                  Navigator.of(context).pop(cpf);
                } else {
                  Generic.snackBar(
                      context: context,
                      mensagem: "CPF inválido.",
                      duracao: 1,
                      tipo: AppName.erro);
                }
              },
              child:
                  const Text('Procurar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            isBaixando == false ? ' Detalhes Levantamento' : "Baixando arquivo",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.cSecondaryColor,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
                onPressed: isEnviando == false
                    ? () {
                        _downloadLevantamento();
                      }
                    : null,
                icon: const Icon(Icons.download))
          ],
        ),
        body: isBaixando == false
            ? _detalheLevantamento == null
                ? const Center(
                    child: SpinKitSpinningLines(
                        color: AppColors.contentColorBlue,
                        size: 120,
                        duration: Duration(milliseconds: 1500)),
                  )
                : isEnviando == false
                    ? _buildDetalhes()
                    : const SpinKitSpinningLines(
                        color: AppColors.contentColorBlue,
                        size: 120,
                        duration: Duration(milliseconds: 1500),
                      )
            : const LoadingDefault());
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
          _selectedFile == null
              ? Text(
                  'Cadastrar Levantamento Assinados',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.cSecondaryColor,
                      fontSize: 18.sp),
                )
              : Column(
                  children: [
                    Text(
                      'Arquivo selecionado',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.cSecondaryColor,
                          fontSize: 18.sp),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      pegarNome(_selectedFile!.path),
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
          IconButton(
              onPressed: () {
                _pickFile();
              },
              icon: Icon(Icons.upload, size: 35.sp)),
          _selectedFile != null
              ? SizedBox(
                  width: 200.w,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Enviar arquivo",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _uploadFile(_selectedFile!.path);
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  String pegarNome(String filePath) {
    List<String> parts = filePath.split('/');
    String fileName = parts.last; // Obter a última parte do caminho
    return fileName.split('.').first; // Remover a extensão .pdf
  }

  Future<void> _downloadLevantamento() async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      setState(() {
        isBaixando = true;
      });

      final filePath = await _levantamentoController.imprimirLevantamento(
          context: context,
          idLevantamento: widget.idLevantamento,
          assinado: widget.assinado);
      setState(() {
        isBaixando = false;
      });
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
    print("carreguei de novo");
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
