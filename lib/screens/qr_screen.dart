import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_paws_v2/models/pet_model.dart';
import 'package:happy_paws_v2/models/user_model.dart';
import 'package:happy_paws_v2/providers/auth_provider.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/screens/qr_options.dart';
import 'package:happy_paws_v2/screens/qr_results.dart';
import 'package:happy_paws_v2/services/cloud_storage.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:happy_paws_v2/widgets/no_pets_qr.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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

  bool isTap = false;

  String mensaje = "";

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
          padding: EdgeInsets.fromLTRB(deviceWidth * 0.09, deviceWidth * 0.05,
              deviceWidth * 0.09, deviceWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                pet.qrImage == "" ? noCodigoQR(pet) : codigoQR(pet),
                escanearQR(context),
                //inputForm(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget noCodigoQR(PetData petData) {
    return SizedBox(
      height: deviceHeight * 0.45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Crear QR para ${petData.name}',
            style: TextStyle(
              color: Colors.purple[300],
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          isTap
              ? Text(
                  "Estamos generando y guardando tu codigo QR, ten paciencia\nSolo tomara unos segundos nwyaa",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]))
              : Text(
                  "Genera un código QR con los detalles de tu mascota y asegúrate de mantener la información tanto tuya como de tu compañero peludo siempre actualizada para garantizar su eficacia.",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700])),
          GestureDetector(
            onTap: isTap
                ? null
                : () async {
                    setState(() {
                      isTap = true;
                    });

                    UserData? userData;
                    DocumentSnapshot snapshot = await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(AuthProvider.instance.user!.uid)
                        .get();

                    if (snapshot.exists) {
                      // Si el documento existe, crea una instancia de UserData
                      userData = UserData.fromFirestore(snapshot);
                    }

                    String type = "perrito";
                    setState(() {
                      if (petData.type == "Gato") {
                        type = "gatito";
                      }
                      mensaje = """
                      <p>¡Hola! Mi nombre es ${petData.name}, soy un adorable $type. Mi amable dueño se llama ${userData!.name}, y aquí te presento información relevante:</p>

                      <h2>Para ${petData.name}:</h2>
                      <p style="text-align: center;"><img src="${petData.profileImage}" alt="Foto de ${petData.name}" width="200"></p>
                      <ul>
                        <li><strong>Apodo:</strong> ${petData.nickname}</li>
    <li><strong>Edad:</strong> ${petData.age}</li>
    <li><strong>Raza:</strong> ${petData.race}</li>
    <li><strong>Sexo:</strong> ${petData.sex}</li>
    <li><strong>Tamaño:</strong> ${petData.size}</li>
    <li><strong>Peso:</strong> ${petData.weight}</li>
    <li><strong>Información adicional:</strong> ${petData.aboutMe}</li>
  </ul>

  <h2>Para ${userData.name}:</h2>
  <p style="text-align: center;"><img src="${userData.image}" alt="Foto de ${userData.name}" width="200"></p>
  <ul>
    <li><strong>Correo electrónico:</strong> ${userData.email}</li>
    <li><strong>Teléfono:</strong> ${userData.phone}</li>
    <li><strong>Dirección:</strong> ${userData.address}</li>
    <li><strong>Información adicional:</strong> ${userData.aboutMe}</li>
  </ul>

  <p>¡Gracias por conocerme a mí y a mi querido dueño! 🐾</p>
""";
                    });
                    final image = await screenshotController.capture();
                    Uint8List? imageBytes = Uint8List.fromList(image!);

                    // Guardar la imagen temporalmente en el sistema de archivos temporal
                    final tempDirectory = await getTemporaryDirectory();
                    final tempFilePath = '${tempDirectory.path}/temp_image.png';
                    final tempFile = File(tempFilePath);
                    await tempFile.writeAsBytes(imageBytes);

                    await CloudStorageService.instance
                        .uploadImage(PetsProvider.instance.petSelected!,
                            tempFile, "qr_images")
                        .then((result) async {
                      var imageURL = await result!.ref.getDownloadURL();
                      await DBService.instance
                          .updateQR(
                              PetsProvider.instance.petSelected!, imageURL)
                          .then((value) => isTap = false);
                    });
                  },
            child: isTap
                ? Screenshot(
                    controller: screenshotController,
                    child: Container(
                      //color: Color(0xFFF5F5FA),
                      color: Colors.white,
                      child: QrImageView(
                        data: mensaje,
                        version: QrVersions.auto,
                        size: deviceWidth * 0.5,
                      ),
                    ),
                  )
                : Image.asset(
                    "assets/QrImage.png",
                    height: deviceWidth * 0.5,
                  ),
          ),
        ],
      ),
    );
  }

  Widget codigoQR(PetData petData) {
    return SizedBox(
      height: deviceHeight * 0.45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'QR de ${petData.name}',
            style: TextStyle(
              color: Colors.purple[300],
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Puedes pulsar el codigo QR para ver más opciones.",
              style: TextStyle(fontSize: 15, color: Colors.grey[700])),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QROptionsScreen(petData: petData.toMap()),
                ),
              );
            },
            child: Image.network(
              petData.qrImage,
              width: deviceWidth * 0.55,
              //scale: deviceWidth * 0.005,
            ),
          ),
        ],
      ),
    );
  }

  Widget escanearQR(BuildContext context) {
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
          GestureDetector(
            onTap: () {
              scanQR(context);
            },
            child: Image.asset(
              "assets/sadPets.png",
              height: deviceWidth * 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> scanQR(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (barcodeScanRes != "-1") {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRResultsScreen(qrResult: barcodeScanRes),
          ),
        );
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
  }
}
