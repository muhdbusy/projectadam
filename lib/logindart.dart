import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:day8_splash/fadeanimation.dart';
import 'package:day8_splash/register.dart';
import 'package:day8_splash/dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1E0A), // Dark green background
      body: Stack(
        children: [
          // Background image with overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/rr.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),

                // Logo and title
                FadeAnimation(
                  1.0,
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.eco, size: 60, color: Colors.lightGreenAccent),
                        SizedBox(height: 15),
                        Text(
                          "Smart Farming",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),

                FadeAnimation(
                  1.2,
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                FadeAnimation(
                  1.3,
                  Text(
                    "Sign in to monitor your farm",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Email Field
                FadeAnimation(
                  1.4,
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.email, color: Colors.lightGreenAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Password Field
                FadeAnimation(
                  1.5,
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.lock, color: Colors.lightGreenAccent),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.lightGreenAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // Forgot Password
                FadeAnimation(
                  1.5,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Add forgot password functionality
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.lightGreenAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Login Button
                FadeAnimation(
                  1.6,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text;

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter email and password"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter a valid email address"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        try {
                          final userCredential = await auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          if (userCredential.user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => DashboardPage()),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          String message = "Login failed";
                          if (e.code == 'user-not-found') {
                            message = "No user found with this email";
                          } else if (e.code == 'wrong-password') {
                            message = "Incorrect password";
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("An error occurred"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // Register Link
                FadeAnimation(
                  1.7,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New to Smart Farming?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        },
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            color: Colors.lightGreenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
