import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/core/app/app.dart';
import 'package:lu_assist/src/core/global/global_variables.dart';
import 'package:lu_assist/src/shared/dependency_injection/dependency_injection.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await setupService();
  runApp(UncontrolledProviderScope(container: container,child: const App()));
}

