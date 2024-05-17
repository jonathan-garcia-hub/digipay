import 'package:flutter/material.dart';

import '../themes/digipay_theme.dart';
import 'login_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulate some initialization work
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          // pageBuilder: (context, animation, secondaryAnimation) => ScannerPage(),
          pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 1000),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ThemeConfig.smallLogo, height: 200,),
            SizedBox(height: 50), // Espaciado entre la imagen y el spinner
            const SpinKitCircle(
              color: ThemeConfig.primaryColor,
              size: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}