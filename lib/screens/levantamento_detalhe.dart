import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suporte_dti/controller/levantamento_controller.dart';
import 'package:suporte_dti/model/levantamento_detalhe.dart';

class LevantamentoDetalheScreen extends StatefulWidget {
  final int idLevantamento;

  const LevantamentoDetalheScreen({Key? key, required this.idLevantamento})
      : super(key: key);

  @override
  _LevantamentoDetalheScreenState createState() =>
      _LevantamentoDetalheScreenState();
}

class _LevantamentoDetalheScreenState extends State<LevantamentoDetalheScreen>
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
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
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
        title: const Text('Detalhe do Levantamento'),
      ),
      body: _detalheLevantamento == null
          ? Center(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Nome Unidade', detalhes.nomeUnidade!),
          const SizedBox(height: 16.0),
          _buildInfoRow('Data Levantamento',
              DateFormat('dd/MM/yyyy').format(detalhes.dataLevantamento!)),
          const SizedBox(height: 16.0),
          const Text(
            'Equipamentos Levantados:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipamentoTile(EquipamentoLevantado equipamento) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          equipamento.descricao ?? 'Sem descrição',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          'Sala: ${equipamento.descricaoSala ?? 'Não especificada'}',
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          'ID: ${equipamento.idEquipamento}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
