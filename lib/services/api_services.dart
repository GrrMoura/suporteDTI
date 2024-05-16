import 'dart:developer' as developer;

class ApiServices {
  //produção
  static const String intranetUrl =
      "https://intranet.ssp.se.gov.br/API/Intranet/";
  // static const String suporteDti =
  //     "https://intranet.ssp.se.gov.br/API/sgi/dti/v3";

  // static const String suporteDti =
  //     "https://intranet.ssp.se.gov.br/API/sgi/dti/v3/sGIDTI/";

  static const String suporteDti =
      "https://intranet.ssp.se.gov.br/api/SgiDtiv3/";

  //maquina local
  // static final String intranetUrl = "http://10.10.1.71:3071/";
  // static final String suporteDti = "http://10.10.1.71:58477/";

  // intranet
  // static final String intranetUrl = "http://intradev.ssp.gov-se/Api/intranet/";
  // static final String suporteDti = "http://10.10.2.10/API/intranet/";
  // static final String suporteDti =
  //     "http://intradev.ssp.gov-se/Api/ConsultaIntegrada/";

  static String concatIntranetUrl(String url) {
    developer.log("", name: "Serviço de API");
    return intranetUrl + url;
  }

  static String concatConsultaIntegradaUrl(String url) => suporteDti + url;
}
