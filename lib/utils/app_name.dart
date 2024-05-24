import 'package:suporte_dti/model/itens_equipamento_model.dart';

class AppName {
  static String? erro = "erro";
  static String? sucesso = "sucesso";
  static String? info = "info";

  //erros
  static String? eSemConexao = "Sem conexão com a internet.";
  static String? eTempoLimite =
      " Tempo para tentativa de conexão foi excedido, tente novamente.";

// alertDialogs
  static String? nSerie = 'N° de Série';
  static String? patri = 'Patrimônio';

// imagens
  static String? teclado = 'assets/images/qwerty.png';
  static String? sspLogo = 'assets/images/ssp_logo.png';
  static String? qrCode = 'assets/images/qrCode.png';
  static String? logoDti = 'assets/images/logo_azul.png';
  static String? add = 'assets/images/add.png';
  static String? semFoto = "assets/images/semfotos.png";

  static String? cpu = "assets/images/cpu.png";
  static String? impressora = "assets/images/impressora.png";
  static String? nobreak = "assets/images/nobreak.png";
  static String? estabilizador = "assets/images/nobreak.png";
  static String? notebook = "assets/images/notebook.png";
  static String? scanner = "assets/images/scanner.png";
  static String? roteador = "assets/images/roteador.png";
  static String? switche = "assets/images/switch.png";
  static String? webcam = "assets/images/webcam.png";
  static String? projetor = "assets/images/projetor.png";
  static String? semImagem = "assets/images/semimagem.png";
  static String? monitor = "assets/images/monitor.png";
  static String? hd = "assets/images/hds.png";

  static String fotoEquipamento(String tipoEquipamento) {
    switch (tipoEquipamento) {
      case "MONITOR":
        return AppName.monitor!;

      case "CPU":
        return AppName.cpu!;

      case "NOTEBOOK":
        return AppName.notebook!;

      case "NETBOOK":
        return AppName.notebook!;

      case "ESTABILIZADOR":
        return AppName.estabilizador!;

      case "NOBREAK":
        return AppName.nobreak!;

      case "IMPRESSORA":
        return AppName.impressora!;

      case "SCANNER":
        return AppName.scanner!;

      case "ROTEADOR 3G":
        return AppName.roteador!;

      case "SWITCH":
        return AppName.switche!;

      case "WEBCAM":
        return AppName.webcam!;

      case "PROJETOR":
        return AppName.projetor!;

      case "TECLADO":
        return AppName.teclado!;

      default:
        return AppName.semImagem!;
    }
  }
}
