import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/features/auth/presentation/signup/view/signup_screen.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  static const route = '/login';

  static setRoute() => '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            Image.asset(
              'lib/images/LU_Assist__LOGO.png',
              height: screenSize.height * 0.20,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0,top: 10.0,right: 16.0,bottom: 10.0),
        
        
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
        
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        'lib/images/Login.jpg',
                        height: isWide ? screenSize.height * 0.2 : screenSize.height * 0.23,
                      ),
                      const SizedBox(height: 32),
                      Text('Username'),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
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
                      Text('Password'),
                      TextField(
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
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          'lib/images/google_img.png',
                          height: screenSize.height * 0.03,
                        ),
                        label: const Text('Sign in with Google'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.02,
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              context.go(SignupScreen.route);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
        
          ),
        ),
      ),
    );
  }
}

final passwordVisibilityProvider = StateProvider<bool>((ref) => false);
