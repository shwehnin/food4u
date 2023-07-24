import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*List images = [
      "home_bg.jpg",
      "home_screen.jpg",
      "home_2.jpg",
      "home_7.jpg"
    ];
    */
    List images = [
      "home_2.jpg",
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MediaQuery.of(context).orientation == Orientation.landscape
              ? AssetImage('')
              : AssetImage(
                  'assets/images/${images[0]}',
                ),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
    );
  }
}
