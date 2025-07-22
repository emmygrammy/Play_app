import 'package:flutter/material.dart';
import 'package:play_app/auth/signin_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Welcome to your profile!',
              style: TextStyle(fontSize: 24, color: Colors.black54),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle logout logic here
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SigninScreen()),
                (route) => false,
              );
            },
            child: ListTile(
              leading: Icon(Icons.account_circle, size: 40),
              title: Text('Log out'),
              trailing: Icon(Icons.logout, size: 30, color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }
}