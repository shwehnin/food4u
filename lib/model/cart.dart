import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bestcannedfood_ecommerce/model/promotion_discount.dart';
import 'package:bestcannedfood_ecommerce/model/variant.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class FoodCart extends Equatable {
  String? id;
  int orderQuantity;
  double? total;
  double? subTotal;
  Variant? variants;
  FoodMaster? foodMasterCart;
  String? unitConversion;
  int freeQuantity;
  double? discountAmount;
  bool? isChanged;
  List<PromotionDiscount>? discounts;

  FoodCart({
    this.id,
    required this.orderQuantity,
    this.total,
    this.subTotal,
    this.variants,
    this.foodMasterCart,
    this.unitConversion,
    required this.freeQuantity,
    this.discountAmount,
    this.isChanged,
    this.discounts,
  });

  static FoodCart fromCartList(dynamic jsonData) {
    Map<dynamic, dynamic> foodMasterCart = jsonData['item_master'];
    Map<dynamic, dynamic> variants = jsonData['variants'];
    return FoodCart(
      id: jsonData['id'].toString(),
      orderQuantity: jsonData['order_qty'],
      total: jsonData['total'] != null
          ? double.parse(jsonData['total'].toString())
          : 0.0,
      subTotal: jsonData['sub_total'] != null
          ? double.parse(jsonData['sub_total'].toString())
          : 0.0,
      unitConversion: jsonData['unit_conversion'] != null
          ? jsonData['unit_conversion']
          : '',
      freeQuantity: jsonData['free_qty'],
      discountAmount: jsonData['discount_amount'] != null
          ? double.parse(jsonData['discount_amount'].toString())
          : 0.0,
      variants: Variant.fromVariantList(variants),
      foodMasterCart: FoodMaster.fromFoodMasterList(foodMasterCart),
      isChanged: jsonData['is_changed'],
      discounts: List<PromotionDiscount>.from(jsonData['discounts']
          .map((i) => PromotionDiscount.fromDiscount(i))).toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderQuantity,
        total,
        subTotal,
        variants,
        unitConversion,
        freeQuantity,
        discountAmount,
        discounts,
        isChanged
      ];
}
