import 'package:day8_splash/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'fadeanimation.dart';
import 'logindart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Farming IoT',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green[800],
        colorScheme: ColorScheme.dark(
          primary: Colors.green[800]!,
          secondary: Colors.lightGreen[400]!,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _scale2Controller;
  late AnimationController _widthController;
  late AnimationController _positionController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _scale2Animation;
  late Animation<double> _widthAnimation;
  late Animation<double> _positionAnimation;

  bool hideIcon = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _scaleAnimation =
    Tween<double>(begin: 1.0, end: 0.8).animate(_scaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _widthController.forward();
        }
      });

    _widthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _widthAnimation =
    Tween<double>(begin: 80.0, end: 300.0).animate(_widthController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _positionController.forward();
        }
      });

    _positionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _positionAnimation =
    Tween<double>(begin: 0.0, end: 215.0).animate(_positionController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            hideIcon = true;
          });
          _scale2Controller.forward();
        }
      });

    _scale2Controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _scale2Animation =
    Tween<double>(begin: 1.0, end: 32.0).animate(_scale2Controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: LoginPage(),
            ),
          );
        }
      });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _scale2Controller.dispose();
    _widthController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(1, 20, 12, 1), // Dark green background
      body: Stack(
        children: <Widget>[
          // Animated background layers with farming imagery
          for (double i = -50, j = 1.0; i >= -150; i -= 50, j += 0.3)
            Positioned(
              top: i,
              left: 0,
              child: FadeAnimation(
                j,
                Container(
                  width: width,
                  height: 400,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/farm_background.png'), // Replace with your farm image
                      fit: BoxFit.cover,
                    ),
                    color: Colors.black.withOpacity(0.4),
                    backgroundBlendMode: BlendMode.darken,
                  ),
                ),
              ),
            ),

          // Green overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const FadeAnimation(
                  1,
                  Text(
                    "Smart Farming",
                    style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeAnimation(
                  1.3,
                  Row(
                    children: [
                      Icon(Icons.eco, color: Colors.lightGreen[400], size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "IoT Monitoring System",
                        style: TextStyle(
                          color: Colors.lightGreen[200],
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                FadeAnimation(
                  1.3,
                  Text(
                    "Monitor your crops, soil, and environment\nwith our precision agriculture solution.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      height: 1.4,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 100), // Increased spacing
                FadeAnimation(
                  1.6,
                  AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) => Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _widthController,
                          builder: (context, child) => Container(
                            width: _widthAnimation.value,
                            height: 80,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.lightGreen[800]!.withOpacity(0.7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green[900]!.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                _scaleController.forward();
                              },
                              child: Stack(
                                children: <Widget>[
                                  AnimatedBuilder(
                                    animation: _positionController,
                                    builder: (context, child) => Positioned(
                                      left: _positionAnimation.value,
                                      child: AnimatedBuilder(
                                        animation: _scale2Controller,
                                        builder: (context, child) => Transform.scale(
                                          scale: _scale2Animation.value,
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.lightGreen[400],
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.lightGreen[400]!.withOpacity(0.5),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: hideIcon == false
                                                ? const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}