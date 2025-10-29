import 'package:ecommerce_app/common/bloc/button/button_state.dart';
import 'package:ecommerce_app/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce_app/common/helper/navigator/app_navigator.dart';
import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/button/basic_reactive_button.dart';
import 'package:ecommerce_app/data/auth/models/user_signin_req.dart';
import 'package:ecommerce_app/domain/auth/usecases/signin.dart';
import 'package:ecommerce_app/presentation/auth/pages/forgot_password.dart';
import 'package:ecommerce_app/presentation/home/pages/home.dart';
import 'package:ecommerce_app/presentation/admin/admin_dashboard.dart'; // ✅ Add this import
import 'package:ecommerce_app/widgets/success_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterPasswordPage extends StatelessWidget {
  final UserSigninReq signinReq;
  EnterPasswordPage({required this.signinReq, super.key});

  final TextEditingController _passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: Builder(
        builder: (context) {
          return BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }

              if (state is ButtonSuccessState) {
                Future.microtask(() async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    await user.getIdToken(true); // 🔄 Force refresh
                    final idTokenResult = await user.getIdTokenResult();
                    final isAdmin = idTokenResult.claims?['admin'] == true;

                    final docRef = FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid);
                    final doc = await docRef.get();

                    if (doc.exists) {
                      final data = doc.data();
                      final firstname = data?['firstName'];

                      if (firstname != null &&
                          firstname is String &&
                          firstname.isNotEmpty) {
                        showLoginSuccessDialog(context);

                        Future.delayed(const Duration(seconds: 2), () {
                          if (isAdmin) {
                            AppNavigator.pushAndRemove(
                              context,
                              const AdminDashboard(),
                            );
                          } else {
                            AppNavigator.pushAndRemove(
                              context,
                              HomePage(firstname: firstname),
                            );
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User profile incomplete.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User record not found.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Authentication failed.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                });
              }
            },
            child: Scaffold(
              appBar: const BasicAppbar(),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _signinText(context),
                    const SizedBox(height: 20),
                    _passwordField(context),
                    const SizedBox(height: 20),
                    _continueButton(context),
                    const SizedBox(height: 20),
                    _forgotPassword(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _signinText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sign in',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (signinReq.email != null && signinReq.email!.isNotEmpty)
          Text(
            'Email: ${signinReq.email}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
      ],
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordCon,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Enter Password'),
    );
  }

  Widget _continueButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          onPressed: () {
            signinReq.password = _passwordCon.text;
            context.read<ButtonStateCubit>().execute(
              usecase: SigninUseCase(),
              params: signinReq,
            );
          },
          title: 'Continue',
        );
      },
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: "Forgot password? "),
          TextSpan(
            text: 'Reset',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, ForgotPasswordPage());
              },
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
