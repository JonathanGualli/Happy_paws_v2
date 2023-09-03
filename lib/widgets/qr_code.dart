import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;
  const QrCodeWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    final screenshotController = ScreenshotController();

    /*return Center(
      child: QrImageView(
        data: data, // Los datos que deseas codificar en el código QR
        version: QrVersions.auto,
        size: deviceWidth * 0.5, // Tamaño del código QR
      ),
    );*/
    return Screenshot(
      controller: screenshotController,
      child: Container(
        padding: EdgeInsets.all(8),
        //color: Color(0xFFF5F5FA),
        color: Colors.white,
        child: QrImageView(
          data: "prueba porfavor funciona caracj",
          version: QrVersions.auto,
          size: deviceWidth * 0.4,
        ),
      ),
    );
  }

}
