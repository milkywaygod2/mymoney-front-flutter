import 'package:flutter/material.dart';

import 'app/MyMoneyApp.dart';
import 'app/di/Injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyMoneyApp());
}
