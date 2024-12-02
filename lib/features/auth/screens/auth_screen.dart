import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_textfield.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth {
  signIn,
  signUp,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signIn;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void showResetPasswordDialog() {
    final TextEditingController newPasswordController = TextEditingController();
    //String? resetToken; 

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              textController: _emailController,
              hintText: 'Enter your email',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Bước 1: Gửi yêu cầu reset password
              await authService
                  .resetPassword(
                context: context,
                email: _emailController.text,
              )
                  .then((token) {
                if (token != null) {
                  // Bước 2: Nếu nhận được token, hiển thị dialog nhập mật khẩu mới
                  Navigator.pop(context); // Đóng dialog hiện tại
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Enter New Password'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            textController: newPasswordController,
                            hintText: 'Enter new password',
                            isPass: true,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Bước 3: Cập nhật mật khẩu mới
                            authService.updatePassword(
                              context: context,
                              resetToken: token,
                              newPassword: newPasswordController.text,
                            );
                          },
                          child: const Text('Update Password'),
                        ),
                      ],
                    ),
                  );
                }
              });
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Add this to prevent overflow
          padding:
              const EdgeInsets.symmetric(horizontal: 25), // Increased padding
          child: Column(
            children: [
              const SizedBox(height: 100), // Increased top spacing
              // Logo Amazon
              Image.asset(
                'assets/images/amazon_in.png',
                height: 80,
                color: Colors.black,
              ),
              const SizedBox(height: 35), // Increased spacing

              // Login/Signup Toggle
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _auth = Auth.signIn),
                        child: Column(
                          children: [
                            Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _auth == Auth.signIn
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 3,
                              color: _auth == Auth.signIn
                                  ? GlobalVariables.secondaryColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _auth = Auth.signUp),
                        child: Column(
                          children: [
                            Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: _auth == Auth.signUp
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 3,
                              color: _auth == Auth.signUp
                                  ? GlobalVariables.secondaryColor
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30), // Increased spacing

              // Forms section
              if (_auth == Auth.signUp)
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        textController: _nameController,
                        hintText: 'Username',
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        textController: _emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        textController: _passwordController,
                        hintText: 'Password',
                        isPass: true,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        textController: TextEditingController(),
                        hintText: 'Re-enter Password',
                        isPass: true,
                      ),
                      const SizedBox(height: 25),
                      CustomButton(
                        text: 'Sign Up',
                        function: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            signUpUser();
                          }
                        },
                      ),
                    ],
                  ),
                ),

              if (_auth == Auth.signIn)
                Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        textController: _emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        textController: _passwordController,
                        hintText: 'Password',
                        isPass: true,
                      ),
                      
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: showResetPasswordDialog,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      CustomButton(
                        text: 'Sign In',
                        function: () {
                          if (_signInFormKey.currentState!.validate()) {
                            signInUser();
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
