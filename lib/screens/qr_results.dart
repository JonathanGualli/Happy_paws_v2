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
                      BorderRadius.circular(10.0), 
                  color: Colors.white.withOpacity(
                      0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), 
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
                      textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black),
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
