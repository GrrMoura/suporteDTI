// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/utils/app_colors.dart';
import 'package:suporte_dti/utils/app_styles.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  String overlayText = "Por favor, Escanei o QRCode";

  bool isScanCompleted = false;
  String? codigo;

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    autoStart: true,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onBarcodeDetect(BarcodeCapture barcodeCapture) {
    final barcode = barcodeCapture.barcodes.last;
    setState(() {
      codigo = barcode.rawValue;

      if (codigo!.isNotEmpty) {
        context.push(AppRouterName.qrCodeResult);

        return;
      }

      overlayText = barcodeCapture.barcodes.last.displayValue ??
          barcode.rawValue ??
          'O código de barras não tem valor exibível';
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cSecondaryColor,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.construction,
                size: 100,
                color: AppColors.cSecondaryColor,
              ),
              SizedBox(height: 20),
              Text(
                'Método para QrCode em Construção',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Esta funcionalidade está atualmente em desenvolvimento.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     iconTheme: const IconThemeData(color: Colors.white),
    //     leading: IconButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //         icon: const Icon(Icons.arrow_back_ios_new)),
    //     title: Text("Scanner",
    //         style: Styles().titleStyle().copyWith(
    //             color: AppColors.cWhiteColor,
    //             fontSize: 22.sp,
    //             fontWeight: FontWeight.normal)),
    //     centerTitle: true,
    //     backgroundColor: AppColors.cSecondaryColor,
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Expanded(
    //             child: Stack(
    //           fit: StackFit.expand,
    //           children: [
    //             Center(
    //               child: MobileScanner(
    //                 fit: BoxFit.contain,
    //                 onDetect: onBarcodeDetect,
    //                 overlay: Padding(
    //                   padding: const EdgeInsets.all(16.0),
    //                   child: Align(
    //                     alignment: Alignment.bottomCenter,
    //                     child: Opacity(
    //                       opacity: 0.7,
    //                       child: Text(
    //                         overlayText,
    //                         style: const TextStyle(
    //                           backgroundColor: Colors.black26,
    //                           color: Colors.white,
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: 24,
    //                           overflow: TextOverflow.ellipsis,
    //                         ),
    //                         maxLines: 1,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 controller: controller,
    //                 scanWindow: scanWindow,
    //                 errorBuilder: (context, error, child) {
    //                   return ScannerErrorWidget(error: error);
    //                 },
    //               ),
    //             ),
    //             CustomPaint(
    //               painter: ScannerOverlay(scanWindow),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: Align(
    //                 alignment: Alignment.topLeft,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: [
    //                     ValueListenableBuilder<TorchState>(
    //                       valueListenable: controller.torchState,
    //                       builder: (context, value, child) {
    //                         final Color iconColor;

    //                         switch (value) {
    //                           case TorchState.off:
    //                             iconColor = Colors.black;
    //                             break;
    //                           case TorchState.on:
    //                             iconColor = Colors.yellow;
    //                             break;
    //                         }

    //                         return TextButton.icon(
    //                           label: Text(
    //                             "Lanterna",
    //                             style: TextStyle(
    //                                 color: Colors.black, fontSize: 15.sp),
    //                           ),
    //                           onPressed: () => controller.toggleTorch(),
    //                           icon: Icon(
    //                             Icons.flashlight_on,
    //                             color: iconColor,
    //                             size: 25.sp,
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;
  final double borderRadius = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    // Create a Paint object for the white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Adjust the border width as needed

    // Calculate the border rectangle with rounded corners
// Adjust the radius as needed
    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // Draw the white border
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: const Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
