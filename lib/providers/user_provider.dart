import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserData? _user;

  UserData get userData => _user!;

}
