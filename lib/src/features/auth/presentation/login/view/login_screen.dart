import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';
import 'package:lu_assist/src/features/auth/presentation/signup/view/signup_screen.dart';

import '../view_model/login_controller.dart';

final passwordVisibilityProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const route = '/login';

  static setRoute() => '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final loginController = ref.watch(loginProvider);
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);

    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Image.asset(
        //     'assets/images/LU_Assist__LOGO.png',
        //     height: screenSize.height * 0.20,
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0,top: 10.0,right: 16.0,bottom: 10.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/login.jpg',
                    //height: isWide ? screenSize.height * 0.2 : screenSize.height * 0.23,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 32),
                  //Text('Username'),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required.';
                      }
                      return null; // Input is valid
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required.';
                      }
                      return null; // Input is valid
                    },
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          ref.read(passwordVisibilityProvider.notifier).state =
                          !isPasswordVisible;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await ref.read(loginProvider.notifier).login(
                            email: emailController.text.trim(),
                            password: passwordController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: loginController.isLoading ?  LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ) :  Text(
                      'Login',
                      style: context.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text("Don't have an account?", style: context.bodySmall,),
                      TextButton(
                        onPressed: () {
                          context.go(SignupScreen.route);
                        },
                        child:  Text(
                          'Sign Up',
                          style: context.titleSmall?.copyWith(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )

        ),
      ),
    );
  }
}

