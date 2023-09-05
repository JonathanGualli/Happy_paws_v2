import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:happy_paws_v2/widgets/app_icon.dart';

class QRResultsScreen extends StatefulWidget {
  final String qrResult;
  const QRResultsScreen({super.key, required this.qrResult});

  @override
  State<QRResultsScreen> createState() => _QRResultsScreenState();
}

class _QRResultsScreenState extends State<QRResultsScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final htmlContent = """
      <p>¡Hola! Mi nombre es lukas, soy un adorable gatito. Mi amable dueño se llama Jonathan Gualli xd, y aquí te presento información relevante:</p>

      <h2>Para lukas:</h2>
      <p style="text-align: center;"><img src="https://firebasestorage.googleapis.com/v0/b/happypawsv2.appspot.com/o/pets_images%2FjEFLZbCrs3znxTyjFrlw?alt=media&token=06d25286-71de-4037-905c-307340236bf2" alt="Foto de lukas" width="200"></p>
      <ul>
        <li><strong>Apodo:</strong> lucas el wero</li>
        <li><strong>Edad:</strong> 5</li>
        <li><strong>Raza:</strong> gris</li>
        <li><strong>Sexo:</strong> Macho</li>
        <li><strong>Tamaño:</strong> 32</li>
        <li><strong>Peso:</strong> 52</li>
        <li><strong>Información adiciona:</strong> hol soy un gato</li>
      </ul>

      <h2>Para Jonathan Gualli xd:</h2>
      <p style="text-align: center;"><img src="https://firebasestorage.googleapis.com/v0/b/happypawsv2.appspot.com/o/profile_images%2FJ09fIm6ABaSJjmoSMg1Lnx4WN643?alt=media&token=09bf0f58-e6a4-4c70-9dbc-368c6d820676" alt="Foto de Jonathan Gualli" width="200"></p>
      <ul>
        <li><strong>Correo electrónico:</strong> jonathan.gualli@epn.edu.ec</li>
        <li><strong>Teléfono:</strong> 09876531</li>
        <li><strong>Dirección:</strong> nose xd</li>
        <li><strong>Informacion adicional:</strong> nose</li>
      </ul>

      <p>¡Gracias por conocerme a mí y a mi querido dueño! 🐾</p>
    """;
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
        title: const Text("Información QR"),
        iconTheme: const IconThemeData(color: Color(0xFF93329E)),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/fondo2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10.0), // Bordes redondeados
                  color: Colors.white.withOpacity(
                      0.8), // Color de fondo del contenedor con opacidad
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Sombra
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    HtmlWidget(
                      widget.qrResult,
                      textStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black), // Estilo del texto
                      // Permite cargar imágenes desde URL
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
