import 'package:flutter/material.dart';
import 'package:md_pro/main.dart';

class EmailOrPasswordForm extends StatefulWidget {
  final bool isSignUpPage;
  const EmailOrPasswordForm({super.key, required this.isSignUpPage});
  @override
  State<StatefulWidget> createState() => _EmailOrPasswordFormState();
}

class _EmailOrPasswordFormState extends State<EmailOrPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _formController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _formController,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Container(
            child: widget.isSignUpPage
                ? TextFormField(
                    controller: _confirmPasswordController,
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
                      }
                    },
                  )
                : null,
          ),
          SizedBox(height: 24),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.isSignUpPage
                          ? "Successfully signed up!"
                          : "Succesfully logged in!",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
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
        ],
      ),
    );
  }
}
