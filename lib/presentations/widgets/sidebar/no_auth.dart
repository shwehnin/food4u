import 'package:flutter/material.dart';

class NoAuth extends StatelessWidget {
  const NoAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 30),
        child: Container(
          width: size.width * 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/logo.png',
                    ),
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('bizzsync'),
                        Text(
                          'Ecommerce',
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 250,
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Sign Up',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 280,
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'Expiry date : ',
                    ),
                    Text(
                      ' 2022-07-07',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                'Copyright \u00a9 2022 | bizzsync',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
