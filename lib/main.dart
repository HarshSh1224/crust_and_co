import 'package:crust_and_co/app.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(userRepository: DatabaseUserRepo()));
}
