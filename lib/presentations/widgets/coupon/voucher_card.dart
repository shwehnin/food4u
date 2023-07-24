import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/promotion_discount.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class VoucherCard extends StatelessWidget {
  final int id;
  final String startDate;
  final String endDate;
  final String voucher;
  final int oneTimeFlg;
  final int discountAmount;
  final PromotionDiscount promotionDiscount;
  String val = '';

  VoucherCard({
    Key? key,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.voucher,
    required this.oneTimeFlg,
    required this.discountAmount,
    required this.promotionDiscount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      color: Colors.white,
      elevation: 4,
      shadowColor: Color(0xFFE4E4E4),
      clipper: TicketClipper(),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: TicketClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      child: InkWell(
                        onTap: () {
                          // Copy tapped voucher code to Clipboard and show with Alertbox
                          FlutterClipboard.copy(voucher).then((value) {
                            FlutterClipboard.paste()
                                .then((value) => val = value);
                            showSuccessMessage(
                                'Voucher code $voucher is copied.');
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Reward',
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      'Get $discountAmount% off',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(startDate + ' ~ ' + endDate),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            voucher != ''
                                ? Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        voucher,
                                        style: TextStyle(
                                          color: kPrimaryLightColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(size.width * 0.7, 0.0);
    path.relativeArcToPoint(const Offset(20, 0),
        radius: const Radius.circular(10.0), largeArc: true, clockwise: false);
    path.lineTo(size.width - 10, 0);
    path.quadraticBezierTo(size.width, 0.0, size.width, 10.0);
    path.lineTo(size.width, size.height - 10);
    path.quadraticBezierTo(
        size.width, size.height, size.width - 10, size.height);
    path.lineTo(size.width * 0.7 + 20, size.height);
    path.arcToPoint(Offset((size.width * 0.7), size.height),
        radius: const Radius.circular(10.0), clockwise: false);
    path.lineTo(10.0, size.height);
    path.quadraticBezierTo(0.0, size.height, 0.0, size.height - 10);
    path.lineTo(0.0, 10.0);
    path.quadraticBezierTo(0.0, 0.0, 10.0, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
