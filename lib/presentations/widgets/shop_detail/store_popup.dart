import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

class StoresPopup extends StatefulWidget {
  final Marker marker;
  final List<Company> company;

  const StoresPopup({
    Key? key,
    required this.marker,
    required this.company,
  });

  @override
  _StoresPopupState createState() => _StoresPopupState();
}

class _StoresPopupState extends State<StoresPopup> {
  late Company company;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.company.length; i++) {
      if (widget.company[i].gpsPoint![0].latitude ==
              widget.marker.point.latitude &&
          widget.company[i].gpsPoint![1].longitude ==
              widget.marker.point.longitude) {
        company = widget.company[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: CachedNetworkImageProvider(
                            '${company.logo}',
                          ),
                          //closed width
                          // width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${company.companyName}',
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: const TextStyle(
                        color: kBlackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    Text(
                      '${company.companyAddress}',
                      style:
                          const TextStyle(fontSize: 12.0, color: kBlackColor),
                    ),
                    SizedBox(
                      width: 160,
                      child: InkWell(
                        onTap: () => launch(
                            "tel:${company.companyPhone.toString().replaceAll('-', '')}"),
                        child: Text(
                          '${company.companyPhone}',
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 12.0, color: kBlackColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
