import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:suporte_dti/model/dispositivo_model.dart';

class DispositivoServices {
  static Future<bool> verificarConexao() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }

    return false;
  }

  static Future<DispositivoModels> carregarInformacoesDispositivo() async {
    final DeviceInfoPlugin dispositivoInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      return _readAndroidBuildData(await dispositivoInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      return _readIosDeviceInfo(await dispositivoInfoPlugin.iosInfo);
    }

    return DispositivoModels();
  }

  static Future<DispositivoModels> _readAndroidBuildData(
      AndroidDeviceInfo build) async {
    const AndroidId androidIdPlugin = AndroidId();

    final String? androidId = await androidIdPlugin.getId();

    var dispositivo = DispositivoModels(
        idDispositivo: androidId,
        fabricante: build.manufacturer,
        modelo: build.model,
        so: "Android",
        versaoSo: build.version.release);

    return dispositivo;
  }

  static Future<DispositivoModels> _readIosDeviceInfo(
      IosDeviceInfo data) async {
    var dispositivo = DispositivoModels(
        idDispositivo: data.identifierForVendor,
        fabricante: "Apple",
        modelo: data.model,
        so: data.systemName,
        versaoSo: data.systemVersion);
    return dispositivo;
  }
}
