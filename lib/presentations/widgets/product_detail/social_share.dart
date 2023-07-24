import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:social_share/social_share.dart';

class SocialShareWidget extends StatelessWidget {
  const SocialShareWidget({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share To Social Medias',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                elevation: 1,
                child: Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _copyItemUrl(),
                        icon: Icon(
                          Icons.copy,
                          size: 30,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        'Copy Link',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 1,
                child: Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.facebook,
                            size: 30, color: kPrimaryColor),
                      ),
                      Text(
                        'Facebook',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 1,
                child: Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: HeroIcon(HeroIcons.chat,
                            size: 30, color: kPrimaryColor),
                      ),
                      Text(
                        'Viber',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 1,
                child: Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          SocialShare.shareTelegram(url);
                        },
                        icon: HeroIcon(
                          HeroIcons.trendingUp,
                          size: 30,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        'Telegram',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _copyItemUrl() {
    String val = '';
    FlutterClipboard.copy(url).then((value) {
      FlutterClipboard.paste().then((value) => val = value);
      showSuccessMessage('Item url is copied.');
    });
  }
}
