import 'package:flutter/material.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:happy_paws_v2/widgets/qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Align(
        alignment: Alignment.center,
        child: qrPageUI(),
      ),
    );
  }

  Widget qrPageUI() {
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildContext = context;
      return SafeArea(
        child: Container(
          alignment: Alignment.center,
          // padding: EdgeInsets.symmetric(
          //     horizontal: deviceWidth * 0.09, vertical: deviceHeight * 0.04),
          padding: EdgeInsets.fromLTRB(deviceWidth * 0.09, deviceWidth * 0.01,
              deviceWidth * 0.09, deviceWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                codigoQR(),
                escanearQR(),

                //inputForm(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget codigoQR() {
    return SizedBox(
      height: deviceHeight * 0.45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Crear QR',
            style: TextStyle(
              color: Colors.purple[300],
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
              "Genera un código QR con los detalles de tu mascota y asegúrate de mantener la información tanto tuya como de tu compañero peludo siempre actualizada para garantizar su eficacia.",
              style: TextStyle(fontSize: 15, color: Colors.grey[700])),
          Image.asset(
            "assets/QrImage.png",
            height: deviceWidth * 0.5,
          ),
        ],
      ),
    );
  }

  Widget escanearQR() {
    return SizedBox(
      height: deviceHeight * 0.45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Escanear QR',
            style: TextStyle(
              color: Colors.purple[300],
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
              "Has encontrado a un peludito perdido. ¡Vamos, escanea su código y ayudémoslo a reunirse con su familia!",
              style: TextStyle(fontSize: 15, color: Colors.grey[700])),
          Image.asset(
            "assets/sadPets.png",
            height: deviceWidth * 0.5,
          ),
        ],
      ),
    );
  }
}
