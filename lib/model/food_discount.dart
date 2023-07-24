import 'package:equatable/equatable.dart';

class FoodDiscount extends Equatable {
  final int? rewardLoyalCustomers;

  FoodDiscount({this.rewardLoyalCustomers});

  static FoodDiscount fromDiscountList(dynamic jsonData) {
    return FoodDiscount(
        rewardLoyalCustomers: jsonData['Reward Loyal Customers']);
  }

  @override
  List<Object?> get props => [rewardLoyalCustomers];
}
