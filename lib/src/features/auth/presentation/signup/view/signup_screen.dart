import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/core/styles/theme/app_theme.dart';
import 'package:lu_assist/src/features/auth/data/model/user_model.dart';
import 'package:lu_assist/src/features/auth/presentation/login/view/login_screen.dart';
import 'package:lu_assist/src/features/auth/presentation/signup/view_model/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_assist/src/features/profile/presentation/view_model/profile_controller.dart';

import '../../../../../core/network/responses/failure_response.dart';
import '../../../../../core/utils/constants/enum.dart';
import '../../../../../core/utils/validator/validator.dart';

final passwordVisibilityProvider = StateProvider<bool>((ref) => false);
final confirmPasswordVisibilityProvider = StateProvider<bool>((ref) => false);

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  static const route = '/signup';

  static setRoute() => '/signup';

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  @override
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signupController = ref.watch(signUpProvider);
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final isConfirmPasswordVisible =
        ref.watch(confirmPasswordVisibilityProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            Image.asset(
              'assets/images/LU_Assist__LOGO.png',
              height: screenSize.height * 0.20,
            ),
            const SizedBox(width: 8), // Spacing between logo and text
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.05),
            // Responsive padding
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Signup illustration with responsive scaling
                    Center(
                      child: Image.asset(
                        'assets/images/Signup.jpg',
                        //height: isWide ? screenSize.height * 0.2 : screenSize.height * 0.20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Username field
                    //Text('Username'),
                    Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    //Text('Email'),
                    TextFormField(
                      validator: Validators.emailValidator,
                      controller: emailController,
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

                    // Password field
                    //Text('Password'),
                    TextFormField(
                      validator: Validators.passwordValidator,
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        helperStyle: TextStyle(overflow: TextOverflow.visible),
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
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            ref
                                .read(passwordVisibilityProvider.notifier)
                                .state = !isPasswordVisible;
                          },
                        ),
                      ),
                    ),
                    Text(
                      'At least 8 characters including an uppercase, a lowercase, a digit, and a special character',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    //Text('Confirm Password'),
                    TextFormField(
                      controller: confirmPasswordController,
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
                            ref
                                .read(
                                    confirmPasswordVisibilityProvider.notifier)
                                .state = !isConfirmPasswordVisible;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign up button
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          String uid =
                              await ref.read(signUpProvider.notifier).signUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                          if (uid.isNotEmpty) {
                            showDialog<void>(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 50,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "A verification email has been sent to your email. please verify the email from the link.",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () async {
                                        // ProfileEntity profileEntity =
                                        // ProfileEntity(
                                        //   uid: uid,
                                        //   name: nameController.text.trim(),
                                        //   email: emailController.text.trim(),
                                        //   createdAt: DateTime.now(),
                                        // );
                                        // await ref
                                        //     .read(profileProvider.notifier)
                                        //     .createProfile(profileEntity);
                                        context.pop();
                                        UserModel user = UserModel(
                                            role: Role.student.name,
                                            batch: -1,
                                            department: "",
                                            email:
                                            emailController.text.trim(),
                                            id: uid,
                                            image: "",
                                            name: nameController.text,
                                            route: -1,
                                            section: "",
                                            studentId: -1, deviceToken: "");

                                        await ref
                                            .read(profileProvider.notifier)
                                            .createProfile(userModel: user);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
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
                      child: signupController.isLoading ? const CircularProgressIndicator() : const Text(
                        'Sign Up',
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            context.go(LoginScreen.route);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
