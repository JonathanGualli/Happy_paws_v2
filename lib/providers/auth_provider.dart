import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/BNavigation/bn_navigation.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/screens/login_screen.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';

enum AuthStatus {
  notAuthenticated,
  authenticating,
  authenticated,
  userNotFound,
  registering,
  error,
}

class AuthProvider extends ChangeNotifier {
  User? user;

  static AuthProvider instance = AuthProvider();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthStatus? status;

  AuthProvider() {
    _checkCurrentUserIsAuthenticated();
  }

  Future<void> _authoLogin() async {
    if (user != null) {
      return NavigationService.instance
          .navigateToReplacementName(BNavigation.routeName);
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    // ignore: await_only_futures
    user = await _auth.currentUser;
    if (user != null) {
      notifyListeners();
      await _authoLogin();
    } else {
      //notifyListeners();
      return NavigationService.instance
          .navigateToReplacementName(LoginScreen.routeName);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        user = result.user;
        PetsProvider.instance.petSelected =
            await DBService.instance.getSelectedPet();
        status = AuthStatus.authenticated;
        notifyListeners();
        SnackBarService.instance
            .showSnackBar("welcome ${result.user!.email}", true);
        NavigationService.instance
            .navigateToReplacementName(BNavigation.routeName);
      });
    } catch (e) {
      status = AuthStatus.error;
      notifyListeners();
      user = null;
      SnackBarService.instance.showSnackBar("Error al autenticar", false);
    }
  }

  void registerUserWithEmailAndPassword(String email, String password,
      Future<void> Function(String uid) onSuccess) async {
    status = AuthStatus.registering;
    notifyListeners();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      status = AuthStatus.notAuthenticated;
      await onSuccess(user!.uid);
      SnackBarService.instance
          .showSnackBar("Inicia sesión, ${user!.email}", true);
      NavigationService.instance.goBack();
      //Navigate to HomePage
    } catch (e) {
      status = AuthStatus.notAuthenticated;
      user = null;
      SnackBarService.instance.showSnackBar("Error Registering user", false);
      // ignore: avoid_print
      print(e);
    }
    notifyListeners();
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      user = null;
      PetsProvider.instance.petSelected = null;
      status = AuthStatus.notAuthenticated;
      await NavigationService.instance
          .navigateToReplacementName(LoginScreen.routeName);
    } catch (e) {
      SnackBarService.instance.showSnackBar("Error al cerrar sesión", false);
    }
    notifyListeners();
  }
}
