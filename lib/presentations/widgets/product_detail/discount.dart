import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class Discount extends StatelessWidget {
  final String title;
  final String discount;
  final String? usage;
  final String? limit;
  final String? expireDate;
  final String? promoFlag;
  final String? holidayCampaign;
  final String? discount1;
  final String? fromBuyCounts;
  final String? toBuyCounts;
  final String? discount2;
  final String? fromBuyCounts2;
  final String? toBuyCounts2;
  final String? discount3;
  final String? fromBuyCounts3;
  final String? toBuyCounts3;
  final String? discount4;
  final String? fromBuyCounts4;
  final String? toBuyCounts4;
  final int? unitPrice;
  final String? poUnit;
  final String? unitConversion;

  const Discount(
      {Key? key,
      required this.title,
      required this.discount,
      this.usage,
      this.limit,
      this.promoFlag,
      this.expireDate,
      this.holidayCampaign,
      this.discount1,
      this.fromBuyCounts,
      this.toBuyCounts,
      this.discount2,
      this.fromBuyCounts2,
      this.toBuyCounts2,
      this.discount3,
      this.fromBuyCounts3,
      this.toBuyCounts3,
      this.discount4,
      this.fromBuyCounts4,
      this.toBuyCounts4,
      this.unitPrice,
      this.poUnit,
      this.unitConversion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(
              left: BorderSide(color: kPrimaryColor, width: 4.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    title != 'Range Offer'
                        ? Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                discount,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Container(),
                    title != 'Range Offer'
                        ? SizedBox(
                            width: 10,
                          )
                        : Container(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getPromotionTitle,
                          _getUnitConversionTitle,
                          SizedBox(
                            height: 10,
                          ),
                          limit != 'null'
                              ? _bottomItem(
                                  HeroIcon(
                                    HeroIcons.badgeCheck,
                                    size: 14,
                                  ),
                                  limit.toString())
                              : Container(),
                          promoFlag != null && promoFlag == 'Yes'
                              ? _bottomItem(
                                  HeroIcon(
                                    HeroIcons.ticket,
                                    size: 14,
                                  ),
                                  'Get promo')
                              : Container(),
                          usage != null
                              ? _bottomItem(
                                  HeroIcon(
                                    HeroIcons.lightBulb,
                                    size: 14,
                                  ),
                                  usage.toString())
                              : Container(),
                          expireDate != null
                              ? _bottomItem(
                                  HeroIcon(
                                    HeroIcons.clock,
                                    size: 14,
                                  ),
                                  expireDate.toString())
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                title == 'Range Offer' ? _getRangeOfferPromotion : Container(),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _getPromotionTitle {
    String data = title;

    if (data == 'Buy x Get x Free') data = 'Buy Get Offer';
    if (data == 'Range Offer') {
      String _poUnit = poUnit!;
      if (poUnit == null || poUnit == '') _poUnit = 'items';
      data = 'Wholesale Offer - $_poUnit';
    }

    return Text(
      holidayCampaign.toString() != 'null'
          ? '$data - $holidayCampaign'
          : '$data',
      style: TextStyle(
          color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget get _getUnitConversionTitle {
    return unitConversion != ''
        ? Text(
            unitConversion!,
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          )
        : Container();
  }

  _bottomItem(HeroIcon icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 3), child: icon),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 150,
            child: Text(
              text,
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget get _getRangeOfferPromotion {
    List<String> _fromBuyCountsList = [
      fromBuyCounts.toString(),
      fromBuyCounts2.toString(),
      fromBuyCounts3.toString(),
      fromBuyCounts4.toString()
    ];
    List<String> _toBuyCountsList = [
      toBuyCounts.toString(),
      toBuyCounts2.toString(),
      toBuyCounts3.toString(),
      toBuyCounts4.toString()
    ];
    List<String> _discountList = [
      '-K ${((double.tryParse(discount1.toString())! / 100) * unitPrice!).toStringAsFixed(2)}',
      '-K ${((double.tryParse(discount2.toString())! / 100) * unitPrice!).toStringAsFixed(2)}',
      '-K ${((double.tryParse(discount3.toString())! / 100) * unitPrice!).toStringAsFixed(2)}',
      '-K ${((double.tryParse(discount4.toString())! / 100) * unitPrice!).toStringAsFixed(2)}'
    ];
    String _poUnit = poUnit!;
    if (poUnit == null || poUnit == '') _poUnit = 'items';

    //Buy x Get x Free
    return Container(
      //modify height
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < 4; i++)
            _fromBuyCountsList[i] != '' &&
                    _toBuyCountsList[i] != '' &&
                    _discountList[i] != ''
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: InkWell(
                      onTap: () => showInfoMessage(
                          'Buy from ${_fromBuyCountsList[i]} $_poUnit to ${_toBuyCountsList[i].toString()} $_poUnit to get ${_discountList[i].toString()}'),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 80,
                                  child: Text(
                                    '${_fromBuyCountsList[i]} - ${_toBuyCountsList[i].toString()} $_poUnit',
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                width: 80,
                                child: Text(
                                  _discountList[i].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 80,
                                child: Text(
                                  'OFF',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
        ],
      ),
    );
  }
}
