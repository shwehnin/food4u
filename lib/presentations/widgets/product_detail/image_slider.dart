import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List images = ["pizza.jpg", "spicy.jpg", "burger.jpg", "seafood.jpg"];
    return Column(
      children: [
        Container(
          width: 500,
          height: 300,
          child: Swiper(
            itemCount: images.length,
            itemWidth: 300,
            // viewportFraction: 0.5,
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                  color: kPrimaryLightColor, activeColor: kPrimaryColor),
            ),
            // control: SwiperControl(),
            scale: 0.5,
            autoplay: false,
            itemBuilder: (context, index) {
              fit:
              BoxFit.fill;
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(15),
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    'assets/images/${images[index]}',
                                    width: 200,
                                    height: 250,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/${images[index]}',
                      ),
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black45, BlendMode.darken),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
