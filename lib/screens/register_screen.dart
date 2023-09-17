//! VALIDAR CORRECTAMENTE ALGUNOS CAMPOS COMO, CONTRASEÑA, CORREO, TELEFONO, ETC.
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/providers/auth_provider.dart';
import 'package:happy_paws_v2/providers/global_variables_provider.dart';
import 'package:happy_paws_v2/services/cloud_storage.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/image_circle.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = "/userRegister";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider? _auth;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Align(
        alignment: Alignment.center,
        child: registerPageUI(),
      ),
    );
  }

  Widget registerPageUI() {
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildContext = context;
      _auth = Provider.of<AuthProvider>(context);
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.09, vertical: deviceHeight * 0.05),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              textTittle(),
              inputForm(),
              registerButtom(),
            ],
          )));
    });
  }

  Widget textTittle() {
    return const Align(
      alignment: Alignment.topLeft,
      child: Text(
        "Registrarse",
        style: TextStyle(
            color: Color(0xFF440A67),
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget inputForm() {
    return SizedBox(
      height: deviceHeight * 0.8,
      width: double.infinity,
      child: Form(
        key: formKey,
        onChanged: () {
          formKey.currentState!.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //imageSelectorWidget(),
            const ImageCircle(
              imagePath: "assets/profileImage.png",
              isRegister: true,
            ),
            nameTextField(),
            emailTextField(),
            phoneTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Nombre:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              controller: nameController,
              style: const TextStyle(color: Color(0xFF57419D)),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese su nombre';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.account_box_rounded),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Nombre del propietario",
                filled: true,
                fillColor: const Color(0xFFDADAFF),
                prefixIconColor: Colors.purple,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Dirección de correo:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              autocorrect: false,
              controller: emailController,
              style: const TextStyle(color: Color(0xFF57419D)),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese su correo electrónico';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.email),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Correo electrónico",
                filled: true,
                fillColor: const Color(0xFFDADAFF),
                prefixIconColor: Colors.purple,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget phoneTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Número telefónico:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              autocorrect: false,
              controller: phoneController,
              style: const TextStyle(color: Color(0xFF57419D)),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese su número de telefono';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.phone_android),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Número telefónico",
                filled: true,
                fillColor: const Color(0xFFDADAFF),
                prefixIconColor: Colors.purple,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Contraseña:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 35),
            width: deviceWidth * 0.7,
            child: TextFormField(
              autocorrect: false,
              obscureText: true,
              controller: passwordController,
              style: const TextStyle(color: Color(0xFF57419D)),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese su contraseña';
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.lock),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Contraseña",
                filled: true,
                fillColor: const Color(0xFFDADAFF),
                prefixIconColor: Colors.purple,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget registerButtom() {
    return SizedBox(
      width: deviceWidth * 0.9,
      height: deviceHeight * 0.055,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Color(0xFF57419D)),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        onPressed: _auth!.status == AuthStatus.registering
            ? null
            : () {
                if (GlobalVariables.instance.getTemporalImage() == null) {
                  SnackBarService.instance.showSnackBar(
                      "Por favor ingresa una imagen para tu perfil", false);
                } else {
                  if (formKey.currentState!.validate()) {
                    _auth!.registerUserWithEmailAndPassword(
                        emailController.text, passwordController.text,
                        (String uid) async {
                      await CloudStorageService.instance
                          .uploadImage(
                              uid,
                              GlobalVariables.instance.getTemporalImage()!,
                              "profile_images")
                          .then((result) async {
                        var imageURL = await result!.ref.getDownloadURL();
                        await DBService.instance.createdUserInDB(
                            uid,
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            imageURL);
                      });
                    });
                  }
                }
              },
        child: _auth!.status == AuthStatus.registering
            ? LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white, size: 30)
            : const Text(
                'Ingresar',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
      ),
    );
  }
}
