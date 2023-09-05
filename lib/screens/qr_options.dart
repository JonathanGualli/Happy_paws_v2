import 'dart:io';

import 'package:flutter/services.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:happy_paws_v2/widgets/app_icon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class QROptionsScreen extends StatefulWidget {
  final Map<String, dynamic> petData;
  const QROptionsScreen({super.key, required this.petData});

  @override
  State<QROptionsScreen> createState() => _QROptionsScreenState();
}

class _QROptionsScreenState extends State<QROptionsScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const AppIcon(icon: Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            NavigationService.instance.goBack();
          },
        ),
        elevation: 0,
        titleTextStyle: const TextStyle(
            color: Colors.purple, fontSize: 25, fontWeight: FontWeight.bold),
        backgroundColor: const Color(0xFFF5F5FA),
        centerTitle: true,
        title: Text("${widget.petData['name']}"),
        iconTheme: const IconThemeData(color: Color(0xFF93329E)),
      ),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: deviceHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                widget.petData["qrImage"],
                width: deviceWidth * 0.8,
              ),
              SizedBox(
                height: deviceHeight * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.7,
                      height: deviceHeight * 0.055,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                                Color(0xFFF16767)),
                            shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)))),
                        onPressed: () async {
                          NavigationService.instance.goBack();
                          await DBService.instance
                              .updateQR(widget.petData["id"], "");
                        },
                        child: const Text(
                          'Eliminar QR',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.7,
                      height: deviceHeight * 0.055,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                                Color(0xFFF16767)),
                            shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)))),
                        onPressed: () async {
                          final url = Uri.parse(widget.petData["qrImage"]);
                          final response = await http.get(url);
                          final bytes = response.bodyBytes;

                          final temp = await getTemporaryDirectory();
                          final path = '${temp.path}/image.jpg';
                          File(path).writeAsBytesSync(bytes);

                          await Share.shareFiles([path],
                              text:
                                  "Hola, ¡conoce a mi adorable mascota! En este QR encontrarás información relevante sobre ella. 🐾💖");
                        },
                        child: const Text(
                          'Compartir',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.7,
                      height: deviceHeight * 0.055,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                                Color(0xFFF16767)),
                            shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)))),
                        onPressed: () async {
                          final response = await http
                              .get(Uri.parse(widget.petData["qrImage"]));

                          if (response.statusCode == 200) {
                            final Uint8List imageBytes = response.bodyBytes;
                            final result =
                                await ImageGallerySaver.saveImage(imageBytes);

                            if (result != null && result['isSuccess'] == true) {
                              SnackBarService.instance.showSnackBar(
                                  "Imagen guardada en la galería", true);
                            } else {
                              SnackBarService.instance.showSnackBar(
                                  "No se pudo guardar la imagen, intentalo denuevo",
                                  true);
                            }
                          } else {
                            print('Error al descargar la imagen');
                          }
                        },
                        child: const Text(
                          'Guardar Como Imagen',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
