import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:equatable/equatable.dart';

class PromotionDiscount extends Equatable {
  final getCounts, buyCounts, limitOrders;
  final double? preOrderedAmount;
  final String? strategy,
      id,
      type,
      holidayCampaign,
      limitDays,
      effectStartPlanDate,
      effectEndPlanDate,
      oneTimeFlag,
      promoCodeFlag,
      discountAmount,
      fromBuyCounts,
      toBuyCounts,
      discount2,
      fromBuyCounts2,
      toBuyCounts2,
      discount3,
      fromBuyCounts3,
      toBuyCounts3,
      discount4,
      fromBuyCounts4,
      toBuyCounts4;
  FoodMaster? foodMaster;

  PromotionDiscount(
      {this.id,
      this.strategy,
      this.type,
      this.holidayCampaign,
      this.limitOrders,
      this.limitDays,
      this.effectStartPlanDate,
      this.effectEndPlanDate,
      this.oneTimeFlag,
      this.promoCodeFlag,
      this.discountAmount,
      this.preOrderedAmount,
      this.getCounts,
      this.buyCounts,
      this.foodMaster,
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
      this.toBuyCounts4});

  static PromotionDiscount fromPromotionDiscount(
      Map<dynamic, dynamic> jsonData) {
    return PromotionDiscount(
      id: jsonData['id'].toString(),
      strategy: jsonData['strategy'],
      type: jsonData['type'],
      holidayCampaign: jsonData['holiday_campaign'],
      limitOrders: jsonData['limit_orders'],
      limitDays: jsonData['limit_days'],
      effectStartPlanDate: jsonData['effect_start_plan_date'],
      effectEndPlanDate: jsonData['effect_end_plan_date'],
      oneTimeFlag: jsonData['one_time_flg'],
      promoCodeFlag: jsonData['promo_code_flg'],
      discountAmount: jsonData['discount_amount'].toString(),
      preOrderedAmount: jsonData['pre_ordered_amount'] != null
          ? double.parse(jsonData['pre_ordered_amount'].toString())
          : 0.0,
      getCounts: jsonData['get_counts'],
      buyCounts: jsonData['buy_counts'],
      // foodMaster: jsonData['food_master'],
      foodMaster: jsonData['item_master'] != null
          ? FoodMaster.fromFoodMasterList(jsonData['item_master'])
          : null,
      fromBuyCounts: jsonData['from_buy_counts'] != null
          ? jsonData['from_buy_counts'].toString()
          : '',
      toBuyCounts: jsonData['to_buy_counts'] != null
          ? jsonData['to_buy_counts'].toString()
          : '',
      discount2: jsonData['discount_amount2'] != null
          ? jsonData['discount_amount2'].toString()
          : '',
      fromBuyCounts2: jsonData['from_buy_counts2'] != null
          ? jsonData['from_buy_counts2'].toString()
          : '',
      toBuyCounts2: jsonData['to_buy_counts2'] != null
          ? jsonData['to_buy_counts2'].toString()
          : '',
      discount3: jsonData['discount_amount3'] != null
          ? jsonData['discount_amount3'].toString()
          : '',
      fromBuyCounts3: jsonData['from_buy_counts3'] != null
          ? jsonData['from_buy_counts3'].toString()
          : '',
      toBuyCounts3: jsonData['to_buy_counts3'] != null
          ? jsonData['to_buy_counts3'].toString()
          : '',
      discount4: jsonData['discount_amount4'] != null
          ? jsonData['discount_amount4'].toString()
          : '',
      fromBuyCounts4: jsonData['from_buy_counts4'] != null
          ? jsonData['from_buy_counts4'].toString()
          : '',
      toBuyCounts4: jsonData['to_buy_counts4'] != null
          ? jsonData['to_buy_counts4'].toString()
          : '',
    );
  }

  static PromotionDiscount fromDiscount(dynamic jsonData) {
    return PromotionDiscount(
      strategy: jsonData['name'],
      preOrderedAmount: jsonData['value'] != null
          ? double.parse(jsonData['value'].toString())
          : 0.0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        strategy,
        type,
        holidayCampaign,
        limitOrders,
        limitDays,
        effectStartPlanDate,
        effectEndPlanDate,
        oneTimeFlag,
        promoCodeFlag,
        discountAmount,
        preOrderedAmount,
        getCounts,
        buyCounts,
        foodMaster,
        fromBuyCounts,
        toBuyCounts,
        discount2,
        fromBuyCounts2,
        toBuyCounts2,
        discount3,
        fromBuyCounts3,
        toBuyCounts3,
        discount4,
        fromBuyCounts4,
        toBuyCounts4
      ];

  static PromotionDiscount fromPromotionDiscountForVoucher(dynamic json) {
    return PromotionDiscount(
      id: json['id'].toString(),
      strategy: json['strategy'],
      type: json['type'],
      // foodMaster: json['food_master'],
      foodMaster: json['item_master'] != null
          ? FoodMaster.fromFoodMasterForVoucher(json['item_master'])
          : null,
    );
  }
}
