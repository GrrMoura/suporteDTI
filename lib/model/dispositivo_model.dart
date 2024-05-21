import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/utils/configuracoes_global_utils.dart';

class DispositivoModels {
  String? idDispositivo;
  String? fabricante;
  String? modelo;
  String? so;
  String? versaoSo;
  bool? cadastrado;
  bool? liberado = true;

  DispositivoModels(
      {this.idDispositivo,
      this.fabricante,
      this.modelo,
      this.so,
      this.versaoSo});

  String getHeader() => "MobileInformation";

  String getHeaderData() =>
      "${ConfiguracoesGlobalUtils.ID_SISTEMA};$idDispositivo;$fabricante;$modelo;$so;$versaoSo;";

  DispositivoModels.getPreferences(SharedPreferences prefs) {
    cadastrado = prefs.getBool('cadastrado') ?? true;
    liberado = prefs.getBool('liberado') ?? true;
  }

  setPreferences(SharedPreferences prefs) {
    prefs.setBool("cadastrado", cadastrado!);
    prefs.setBool("liberado", liberado!);
  }
}
