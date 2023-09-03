import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/pet_model.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:happy_paws_v2/widgets/no_pets_qr.dart';
import 'package:happy_paws_v2/widgets/qr_code.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';


class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey globalKey = GlobalKey();
  final screenshotController = ScreenshotController();
  double deviceHeight = 0;
  double deviceWidth = 0;

  String? _petSelected;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    _petSelected = Provider.of<PetsProvider>(context).petSelected;

    return _petSelected == null
        ? const NoPetQRScreen()
        : Scaffold(
            body: StreamBuilder<PetData>(
              stream: PetsProvider.instance.petStream(_petSelected!),
              builder: (BuildContext context, snapshot) {
                var petData = snapshot.data;

                return snapshot.hasData
                    ? Align(
                        alignment: Alignment.center,
                        child: qrPageUI(petData),
                      )
                    : Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.purple, size: 30),
                      );
              },
            ),
          );
  }

  Widget qrPageUI(pet) {
    // print("${petData!.name}");
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildContext = context;
      return SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(deviceWidth * 0.09, deviceWidth * 0.01,
              deviceWidth * 0.09, deviceWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                pet.qrImage == "" ? NoCodigoQR(pet) : codigoQR(pet),
                escanearQR(),
                //inputForm(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget NoCodigoQR(petData) {
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
          GestureDetector(
              onTap: () async {
              },
              child: Image.asset(
                "assets/QrImage.png",
                height: deviceWidth * 0.5,
              )),
        ],
      ),
    );
  }

  Widget codigoQR(petData) {
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
          GestureDetector(
            onTap: () {
              DBService.instance
                  .getPetDataFromFirestore(PetsProvider.instance.petSelected!)
                  .then((data) {
                setState(() {
                  petData = data;
                });
              });
            },
            child: petData == null
                ? Image.asset(
                    "assets/QrImage.png",
                    height: deviceWidth * 0.5,
                  )
                : QrCodeWidget(data: petData == null ? "nada" : petData!.id),
          ),
/*
          Screenshot(
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
            ),*/
/*
          ElevatedButton(
            onPressed: () async {
              final image = await screenshotController.capture();
              final savedFile =
                  await ImageGallerySaver.saveImage(Uint8List.fromList(image!));

              if (savedFile != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Imagen guardada en la galería'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No se pudo guardar la imagen en la galería'),
                  ),
                );
              }
            },
            child: Text("holi"),
          ),
          */
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
