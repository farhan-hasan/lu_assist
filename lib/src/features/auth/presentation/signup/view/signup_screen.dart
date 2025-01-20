import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/features/auth/presentation/signup/view_model/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  static const route = '/signup';

  static setRoute() => '/signup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupController = ref.watch(signUpProvider);
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final isConfirmPasswordVisible = ref.watch(confirmPasswordVisibilityProvider);
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
            const SizedBox(width: 8), // Spacing between logo and text
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05), // Responsive padding
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Signup illustration with responsive scaling
                    Center(
                      child: Image.asset(
                        'lib/images/Signup.jpg',
                        height: isWide ? screenSize.height * 0.2 : screenSize.height * 0.20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Username field
                    Text('Username'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isWide ? 6: 1),
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    Text('Email'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isWide ? 6 : 1),
                      child: TextField(
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
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    Text('Password'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isWide ? 6 : 1),
                      child: TextField(
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
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    Text('Confirm Password'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isWide ? 6 : 1),
                      child: TextField(
                        obscureText: !isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              ref.read(confirmPasswordVisibilityProvider.notifier).state =
                              !isConfirmPasswordVisible;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign up button
                    ElevatedButton(
                        onPressed: () {
                          // Sign-up logic goes here
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
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

final passwordVisibilityProvider = StateProvider<bool>((ref) => false);
final confirmPasswordVisibilityProvider = StateProvider<bool>((ref) => false);