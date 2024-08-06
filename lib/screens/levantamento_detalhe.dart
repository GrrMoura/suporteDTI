// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
import 'package:suporte_dti/viewModel/dados_usuario_view_model.dart';

class LevantamentoDetalheScreen extends StatefulWidget {
  final int idLevantamento;
  final String nomeArquivo;
  final bool assinado;

  const LevantamentoDetalheScreen(
      {super.key,
      required this.idLevantamento,
      required this.nomeArquivo,
      required this.assinado});
//TODO: AO FECHAR OU CONFIRMAR O LEVANTAMENTO FAZER ATUALIZAR A TELA
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

  Future<void> _uploadFile({required int idUsuario}) async {
    await _levantamentoController.levantamentoCadastrarAssinado(
        idUsuario: idUsuario,
        context: context,
        idLevantamento: widget.idLevantamento,
        path: _selectedFile!.path);
  }

  Future<String?> showCpfDialog(BuildContext context) async {
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController nomeController = TextEditingController();
    bool isEncontrado = false;
    bool isOcupado = false;
    bool isUploading = false;

    Dados? dados;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                isUploading || isOcupado
                    ? Center(
                        child: SpinKitSpinningLines(
                            color: AppColors.contentColorBlue,
                            size: 80.h,
                            duration: const Duration(milliseconds: 1500)),
                      )
                    : const Icon(Icons.person,
                        color: AppColors.cSecondaryColor, size: 40),
                const SizedBox(height: 20),
                isEncontrado == true
                    ? TextFormField(
                        controller: nomeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Nome do Usuário',
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 16.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: AppColors.cSecondaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: AppColors.cSecondaryColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 6.h,
                ),
                TextFormField(
                  controller: cpfController,
                  inputFormatters: [MaskUtils.maskFormatterCpf()],
                  decoration: InputDecoration(
                    hintText: 'CPF',
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (Validador.cpfIsValid(cpfController.text)) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isOcupado = true;
                        });
                        dados =
                            await UsuarioController.pegarDadosDoUsuarioPeloCpf(
                                context,
                                cpfController.text
                                    .replaceAll(RegExp(r'\D'), ''));
                        setState(() {
                          nomeController.text = formatNome(dados!.nome!);
                          isEncontrado = true;
                          isOcupado = false;
                        });
                      } else {
                        Generic.snackBar(
                            context: context,
                            mensagem: "CPF inválido.",
                            duracao: 1,
                            tipo: AppName.erro);
                      }
                    },
                    child: const Text('Procurar',
                        style: TextStyle(color: AppColors.cSecondaryColor)),
                  ),
                  isEncontrado
                      ? TextButton(
                          onPressed: () async {
                            setState(() {
                              isUploading = true;
                            });
                            await _uploadFile(idUsuario: dados!.id!);
                            setState(() {
                              isUploading = false;
                            });
                          },
                          child: const Text('Continuar',
                              style: TextStyle(color: Colors.green)),
                        )
                      : Container(),
                ],
              )
            ],
          );
        });
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
    double height = MediaQuery.of(context).size.height;
    final detalhes = _detalheLevantamento!.detalhes!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: height - kToolbarHeight,
        child: SingleChildScrollView(
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
              SizedBox(
                height: 450.h,
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
        ),
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
                      showCpfDialog(context);
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  String formatNome(String nome) {
    List<String> partes = nome.split(' ');

    if (partes.length <= 2) {
      return nome;
    }

    String primeiroNome = partes.first;
    String ultimoNome = partes.last;

    List<String> iniciais = [];
    for (int i = 1; i < partes.length - 1; i++) {
      if (partes[i].length > 1 &&
          !['de', 'da', 'dos', 'do'].contains(partes[i].toLowerCase())) {
        iniciais.add('${partes[i][0]}.');
      }
    }

    return '$primeiroNome ${iniciais.join(' ')} $ultimoNome';
  }

  String pegarNome(String filePath) {
    List<String> parts = filePath.split('/');
    String fileName = parts.last;
    return fileName.split('.').first;
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
