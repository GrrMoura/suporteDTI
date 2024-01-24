// ignore_for_file: constant_identifier_names

class ConfiguracoesGlobalUtils {
  static const int ID_SISTEMA = 57; //Produção
  // static final int ID_SISTEMA = 80; //Desenvolvimento
  static const String URL_SISTEMA = "/SISTEMA/sgi/dti/v3";
  static const String Versao_SISTEMA = "v2.0.10+1";
  static String getTopicFirebase() => "$ID_SISTEMA";
}
