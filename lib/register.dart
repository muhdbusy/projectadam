import 'package:day8_splash/fadeanimation.dart';
import 'package:day8_splash/logindart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Color(0xAA1A1B1E),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
                1.2,
                Text(
                  "Create an account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 30),
            FadeAnimation(
                1.5,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xAA1A1B1E),
                      border: Border.all(color: Color(0xFF373A3F))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                BorderSide(color: Color(0xFF373A3F)))),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFF5C5F65)),
                              hintText: "Full Name"),
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                BorderSide(color: Color(0xFF373A3F)))),
                        child: TextField(
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFF5C5F65)),
                              hintText: "Email"),
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFF5C5F65)),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color: Color(0xFF5C5F65),
                                  )),
                              hintText: "Password"),
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: TextField(
                          obscureText: !isConfirmPasswordVisible,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFF5C5F65)),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color: Color(0xFF5C5F65),
                                  )),
                              hintText: "Confirm Password"),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 40),
            FadeAnimation(
                1.6,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Color(0xFF5C5F65)),
                    ),
                    SizedBox(width: 6),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    }, child: Text('Login')),
                  ],
                )),
            SizedBox(height: 20),
            FadeAnimation(
                1.8,
                Center(
                  child: MaterialButton(
                    onPressed: () async {
                      try{
                        final userCredential = await auth.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text
                        );
                        final user = userCredential.user;


                        if(user == null){
                          throw Exception('Registration Failed');
                        }
                      } catch(e){print('Error: ${e}');}
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    color: Color(0xAA3A5BDA),
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white, fontSize: 16),
                        )),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
