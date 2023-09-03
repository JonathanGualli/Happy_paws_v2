import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/BNavigation/bn_navigation.dart';
import 'package:happy_paws_v2/providers/auth_provider.dart';
import 'package:happy_paws_v2/providers/global_variables_provider.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/screens/login_screen.dart';
import 'package:happy_paws_v2/screens/pets_screen.dart';
import 'package:happy_paws_v2/screens/register_pet_screen.dart';
import 'package:happy_paws_v2/screens/register_screen.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider.instance,
        ),
        ChangeNotifierProvider<GlobalVariables>(
            create: (context) => GlobalVariables.instance),
        ChangeNotifierProvider<PetsProvider>(
            create: (context) => PetsProvider.instance),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.instance.navigatorKey,
        title: 'Happy Paws',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          BNavigation.routeName: (context) => const BNavigation(),
          RegisterPetScreen.routeName: (context) => const RegisterPetScreen(),
          PetsScreen.routeName: (context) => const PetsScreen(),
          //ProfilePetScreen.routeName: (context) => const ProfilePetScreen(),
        },
      ),
    );
  }
}
