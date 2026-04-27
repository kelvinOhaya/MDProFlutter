import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:md_pro/main.dart';
import 'package:md_pro/services/auth_service.dart';

class EmailOrPasswordForm extends StatefulWidget {
  final bool isSignUpPage;
  const EmailOrPasswordForm({super.key, required this.isSignUpPage});
  @override
  State<StatefulWidget> createState() => _EmailOrPasswordFormState();
}

class _EmailOrPasswordFormState extends State<EmailOrPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _authError;
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUpOrLogin() async {
    widget.isSignUpPage
        ? await AuthService.register(
            email: _emailController.text,
            password: _passwordController.text,
          )
        : await AuthService.login(
            email: _emailController.text,
            password: _passwordController.text,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            style: TextStyle(fontSize: 16),
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a valid email';
              }
              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email format';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            style: TextStyle(fontSize: 16),
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Container(
            child: widget.isSignUpPage
                ? TextFormField(
                    style: TextStyle(fontSize: 16),
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 6, 0, 187),
                          width: 3,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text) {
                        return 'Make sure passwords match';
                      } else {
                        return null;
                      }
                    },
                  )
                : null,
          ),
          SizedBox(height: 24),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: _isLoading
                ? null
                : () async {
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                      _authError = null;
                    });

                    try {
                      await signUpOrLogin();
                      if (!context.mounted) return;
                      context.go('/dashboard');
                    } on Exception catch (e) {
                      if (mounted) {
                        setState(() {
                          _authError = e.toString().replaceFirst(
                            'Exception: ',
                            '',
                          );
                        });
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(180),
            ),
            label: Text(
              widget.isSignUpPage ? "SIGN UP" : "LOGIN",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('Authenticating user...'),
            ),
          if (_authError != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _authError!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }
}
