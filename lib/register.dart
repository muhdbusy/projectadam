import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:day8_splash/fadeanimation.dart';
import 'package:day8_splash/logindart.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/farm_background.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken),
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeAnimation(
                  1.2,
                  Text(
                    "Create Farmer's Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                FadeAnimation(
                  1.5,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      children: [
                        buildInputField("Full Name", Icons.person, null),
                        buildInputField("Email", Icons.email, emailController),
                        buildInputField("Password", Icons.lock, passwordController,
                            obscureText: !isPasswordVisible,
                            isPassword: true,
                            toggleVisibility: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            }),
                        buildInputField("Confirm Password", Icons.lock,
                            null,
                            obscureText: !isConfirmPasswordVisible,
                            toggleVisibility: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                              });
                            }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FadeAnimation(
                  1.6,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already registered?",
                          style: TextStyle(color: Colors.white70)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Text("Login",
                              style: TextStyle(color: Colors.greenAccent))),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                FadeAnimation(
                  1.8,
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          final userCredential =
                          await auth.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                          final user = userCredential.user;

                          if (user == null) {
                            throw Exception('Registration Failed');
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        } catch (e) {
                          print('Error: ${e}');
                        }
                      },
                      color: Colors.green.shade700,
                      padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Text("Register",
                          style:
                          TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildInputField(String hint, IconData icon, TextEditingController? controller,
      {bool obscureText = false,
        bool isPassword = false,
        VoidCallback? toggleVisibility}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.green.shade200, width: 0.8))),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.greenAccent),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.greenAccent,
            ),
            onPressed: toggleVisibility,
          )
              : null,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
