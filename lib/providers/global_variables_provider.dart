import 'dart:io';

import 'package:flutter/material.dart';

class GlobalVariables extends ChangeNotifier {
  static GlobalVariables instance = GlobalVariables();

  File? image;
  bool isChange = false;

// Para una imagen temporal
  void setTemporalImage(File? imageTemp) {
    image = imageTemp;
    notifyListeners();
  }

  File? getTemporalImage() {
    return image;
  }

  void disposeTemporalImage() {
    image = null;
    isChange = false;
    notifyListeners();
  }

}
