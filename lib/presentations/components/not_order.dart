import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotOrderScreen extends StatelessWidget {
  const NotOrderScreen({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Lottie.asset('assets/icons/noorder.json', repeat: true, height: 100),
          SizedBox(height: 10),
          Center(
            child: Text(
              message,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
