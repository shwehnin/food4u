import 'package:bestcannedfood_ecommerce/model/promotion_discount.dart';
import 'package:equatable/equatable.dart';

class Voucher extends Equatable {
  final int id;
  final String startDate;
  final String endDate;
  final String voucher;
  final int oneTimeFlg;
  final int discountAmount;
  final PromotionDiscount promotionDiscount;
  // To add 'voucherImage' later after API response updated
  // final String voucherImage;

  Voucher({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.voucher,
    required this.oneTimeFlg,
    required this.discountAmount,
    required this.promotionDiscount,
    //required this.voucherImage,
  });

  @override
  List<Object> get props => [
        id,
        startDate,
        endDate,
        voucher,
        oneTimeFlg,
        discountAmount,
        promotionDiscount,
        //voucherImage
      ];

  static Voucher fromVoucherList(dynamic json) {
    return Voucher(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      voucher: json['voucher'],
      oneTimeFlg: json['one_time_flg'],
      discountAmount: json['discount_amount'],
      promotionDiscount: PromotionDiscount.fromPromotionDiscountForVoucher(
          json['promotion_discount']),
      //voucherImage: json['data']['voucher_image'],
    );
  }
}
