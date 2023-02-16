import 'package:flutter/material.dart';

import './number_trivia_app.dart';
import './injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const NumberTriviaApp());
}
