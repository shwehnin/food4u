import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ShowList extends StatelessWidget {
  final String title;
  final String image;
  const ShowList({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/product_detail');
              },
              child: Container(
                height: size.height * 0.3,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite),
                color: kPrimaryColor,
              ),
            ),
            Positioned(
              top: 20,
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_outline),
                color: kPrimaryColor,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: MaterialButton(
                padding: EdgeInsets.symmetric(horizontal: 7),
                onPressed: () {},
                child: Text(
                  'Buy One Get One',
                  style: TextStyle(
                      color: kPrimaryLightColor, fontWeight: FontWeight.bold),
                ),
                color: Colors.black,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/product_detail');
                },
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 17,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '22.34 (100)',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        HeroIcon(
                          HeroIcons.tag,
                          size: 17,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'All Seafood',
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        HeroIcon(
                          HeroIcons.clock,
                          size: 17,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '20 $deliveryTimeText',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 250,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: false,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'K 4,500',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        )
      ],
    );
  }
}
