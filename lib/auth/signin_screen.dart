import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_app/auth/forgot_password_screen.dart';
import 'package:play_app/auth/services/authServices/auth_services.dart';
import 'package:play_app/auth/signup_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';




class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isLoadingGoogle = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Sign In',style: TextStyle(color: Colors.white),),
         backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.only(top:0 ,left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/signup.jpg', 
                     
                  ),
                ),
                TextFormField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email adress',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.deepPurple, width: 8),
                    ),
                    fillColor: Colors.grey[100],
                    filled: true,
                    prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordcontroller,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    fillColor: Colors.grey[100],
                    filled: true,
                    prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, 
                      color: Colors.deepPurple),
                      onPressed: () {
                        // Handle visibility toggle
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => ForgotPasswordScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                            print('Forgot password tapped');
                          },
                          child: Text(
                            'Reset password?',
                            style: TextStyle(
                              color: Colors.deepPurple, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
          
                const SizedBox(height: 16.0),
                FilledButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                          setState(() {
                            _isLoading = true;
                          });
                          await AuthServices.handleSignIn(
                            emailcontroller.text.trim(),
                            passwordcontroller.text.trim(),
                            context,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        }
                 
                      },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Full width
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurpleAccent,
                          ),
                        )
                      : const Text('Sign in'),
                  
          
                ),
                const SizedBox(height: 10.0),
                Text.rich(TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                          );
                        },
                    ),
                  ],
                )),
          
                const SizedBox(height: 20.0),
                //sigin with google
               ElevatedButton.icon(
                    onPressed: _isLoadingGoogle
                        ? null
                        : () async {
                            setState(() {
                              _isLoadingGoogle = true;
                            });
          
                            await AuthServices.signInWithGoogle(context);
          
                            setState(() {
                              _isLoadingGoogle = false;
                            });
                          },
                    icon: _isLoadingGoogle
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FontAwesomeIcons.google, color: Colors.red),
                              SizedBox(width: 25.0),
                            ],
                          ),
                    label: Text(_isLoadingGoogle ? 'Signing in...' : 'Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromARGB(255, 236, 233, 240),
                    ),
                  ),
          
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}