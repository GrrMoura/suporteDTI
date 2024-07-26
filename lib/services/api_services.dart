class ApiServices {
  //produção
  static const String intranetUrl =
      "https://intranet.ssp.se.gov.br/API/Intranet/";
  static const String sistema = "https://intranet.ssp.se.gov.br/api/SgiDtiv3/";

  // //DESENVOLVIMENTO
  // static const String intranetUrl = "http://10.10.2.10/Api/intranet/";

  // static const String sistema = "http://intradev.ssp.gov-se/api/SgiDtiv3/";

  static String concatIntranetUrl(String url) => intranetUrl + url;

  static String concatSGIUrl(String url) => sistema + url;
}
