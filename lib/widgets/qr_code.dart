import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;
  const QrCodeWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: data, // Los datos que deseas codificar en el código QR
        version: QrVersions.auto,
        size: 200.0, // Tamaño del código QR
      ),
    );
  }
}
