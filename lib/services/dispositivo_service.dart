import 'package:connectivity_plus/connectivity_plus.dart';

class DispositivoServices {
  static Future<bool> verificarConexao() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }

    return false;
  }
}
