import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:play_app/nav_screens/bottomNavBar.dart';
 

class AuthServices {
  // FirebaseAuth instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to sign up with email and password
  static Future<String> signUpwithEmail(String email, String password) 
  async {
    if (email.isEmpty || password.isEmpty) {
      return "Email and Password cannot be empty";
    }
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "User signed up successfully";
    }
    catch (e) {
      return "Error during signup :${e.toString()}";
    }
  }

static handleSignUp(String email, String password, BuildContext context) 
async {
  String message = await signUpwithEmail(email, password);
  showSnackbar(context, message);
  if (message == "User signed up successfully") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar()),
      (route) => false,
    );
  }else {
    // Optionally, you can handle the error case here
    print("Signup failed: $message");
  }
}

// Sign in with email and password
static Future<String> signInwithEmail(String email, String password) 
  async {
    if (email.isEmpty || password.isEmpty) {
      return "Email and Password cannot be empty";
    }
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Sign in successfully";
    }
    catch (e) {
      return "Error during sign in :${e.toString()}";
    }
  }

static handleSignIn(String email, String password, BuildContext context) 
async {
  String message = await signInwithEmail(email, password);
  showSnackbar(context, message);
  if (message == "Sign in successfully") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar()),
      (route) => false,
    );
  }else {
    // Optionally, you can handle the error case here
    print("Signin failed: $message");
  }
}
// Sign in with Google
static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // 1. Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        showSnackbar(context, "Google Sign-In cancelled");
        return;
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the Google credentials
      await FirebaseAuth.instance.signInWithCredential(credential);

      // 5. Navigate to main screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (route) => false,
      );
    } catch (e) {
      showSnackbar(context, "Sign-In failed: ${e.toString()}");
    }
  }
// Sign out from Firebase and Google
Future<void> signOutFromGoogle() async {
  // Sign out from Firebase
  await FirebaseAuth.instance.signOut();

  // Sign out from Google account
  await GoogleSignIn().signOut();
}

//forgot password fire base method
static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent. Check your email.'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for this email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is invalid.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  // Show a snackbar with a message
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}