import 'package:lu_assist/src/core/app/app.dart';
import 'package:lu_assist/src/core/global/global_variables.dart';
import 'package:lu_assist/src/features/onboarding/onboarding_screen.dart';
import 'package:lu_assist/src/shared/dependency_injection/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  setupService();
  runApp(UncontrolledProviderScope(container: container,child: const App()));
}

