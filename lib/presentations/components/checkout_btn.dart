import 'package:flutter/material.dart';

class CheckoutBtn extends StatefulWidget {
  const CheckoutBtn({Key? key}) : super(key: key);

  @override
  _CheckoutBtnState createState() => _CheckoutBtnState();
}

class _CheckoutBtnState extends State<CheckoutBtn> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        height: 45,
        width: size.width,
        child: MaterialButton(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/checkout');
          },
          child: Text(
            'Go to checkout',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
