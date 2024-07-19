import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:suporte_dti/controller/levantamento_controller.dart';
import 'package:suporte_dti/model/levantamento_detalhe.dart';
import 'package:suporte_dti/utils/app_colors.dart';

class LevantamentoDetalheScreen extends StatefulWidget {
  final int idLevantamento;
  final String nomeArquivo;

  const LevantamentoDetalheScreen(
      {super.key, required this.idLevantamento, required this.nomeArquivo});

  @override
  LevantamentoDetalheScreenState createState() =>
      LevantamentoDetalheScreenState();
}

class LevantamentoDetalheScreenState extends State<LevantamentoDetalheScreen>
    with SingleTickerProviderStateMixin {
  final LevantamentoController _levantamentoController =
      LevantamentoController();
  DetalheLevantamentoModel? _detalheLevantamento;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _carregarDetalhesLevantamento();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhe do Levantamento',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.cSecondaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _detalheLevantamento == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FadeTransition(
              opacity: _animation,
              child: _buildDetalhes(),
            ),
    );
  }

  Widget _buildDetalhes() {
    final detalhes = _detalheLevantamento!.detalhes!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildInfoRow('Nome do Arquivo', widget.nomeArquivo),
          const SizedBox(height: 16.0),
          _buildInfoRow('Data Levantamento',
              DateFormat('dd/MM/yyyy').format(detalhes.dataLevantamento!)),
          SizedBox(height: 30.h),
          const Text(
            'Equipamentos Levantados',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.cSecondaryColor),
          ),
          const SizedBox(height: 12.0),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
