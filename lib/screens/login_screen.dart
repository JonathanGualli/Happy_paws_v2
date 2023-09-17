//! Lo unico que no es responsive son los botones de facebook y google.

import 'package:flutter/material.dart';
import 'package:happy_paws_v2/providers/auth_provider.dart';
import 'package:happy_paws_v2/screens/register_screen.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthProvider? _auth;

  bool formEmailStatus = false;
  bool formPasswordStatus = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthProvider>(context);

    SnackBarService.instance.buildContext = context;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Align(
        alignment: Alignment.center,
        child: loginPageUI(),
      ),
    );
  }

  Widget loginPageUI() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.09, vertical: deviceHeight * 0.05),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageLogin(),
            loginWithSocialNetoworks(),
            inputForm(),
            registerButtom(),
            loginButtom(),
          ],
        )));
  }

  Widget imageLogin() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 23),
      child: Center(
        child: Image.asset(
          "assets/loginImage.png",
          height: deviceWidth * 0.68,
        ),
      ),
    );
  }

  Widget loginWithSocialNetoworks() {
    return SizedBox(
      height: deviceHeight * 0.2,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Iniciar sesión con: ",
            style: TextStyle(
                color: Color(0xFF440A67),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              facebookButton(),
              googleButton(),
            ],
          ),
          const Center(
            child: Text("- O -",
                style: TextStyle(
                    color: Color(0xFF93329E),
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget facebookButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Color(0xFF3B5998)),
          fixedSize: const MaterialStatePropertyAll(Size(122, 44)),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.facebook_sharp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget googleButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Color(0xFFDB4A39)),
          fixedSize: const MaterialStatePropertyAll(Size(122, 44)),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.g_mobiledata_rounded,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget inputForm() {
    return SizedBox(
      height: deviceHeight * 0.17,
      width: double.infinity,
      child: Form(
        key: formKey,
        onChanged: () {
          formKey.currentState!.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emailTextField(),
            passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Center(
      child: SizedBox(
        width: deviceWidth * 0.7,
        child: TextFormField(
          controller: emailController,
          autocorrect: false,
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
    );
  }

  Widget passwordTextField() {
    return Center(
      child: SizedBox(
        width: deviceWidth * 0.7,
        child: TextFormField(
          controller: passwordController,
          autocorrect: false,
          obscureText: true,
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
    );
  }

  Widget registerButtom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No estás registrado?',
              style: TextStyle(color: Color(0xFF440A67), fontSize: 14)),
          TextButton(
            onPressed: () {
              NavigationService.instance
                  .navigatePushName(RegisterScreen.routeName);
            },
            child: const Text(
              'Crear Cuenta',
              style: TextStyle(
                  color: Color(0xFFFF00E5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButtom() {
    return SizedBox(
      width: deviceWidth * 0.9,
      height: deviceHeight * 0.055,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Color(0xFF57419D)),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)))),
        onPressed: _auth!.status == AuthStatus.authenticating
            ? null
            : () async {
                if (formKey.currentState!.validate()) {
                  _auth!.loginWithEmailAndPassword(
                      emailController.text, passwordController.text);
                }
              },
        child: _auth!.status == AuthStatus.authenticating
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
