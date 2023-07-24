import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return //Stack(children: [
        //BackgroundImage(),
        Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: MediaQuery.of(context).orientation == Orientation.landscape
            ? Image.asset('assets/images/splash_rotate.jpg', fit: BoxFit.fill)
            : Image.asset('assets/images/splash.jpg', fit: BoxFit.fill),
      ),
    );
    //]);
  }
}
