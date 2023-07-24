import 'package:equatable/equatable.dart';

import 'food_master.dart';

class Favourite extends Equatable {
  final String? id;
  final FoodMaster? foodMaster;

  Favourite({
    this.id,
    this.foodMaster,
  });

  @override
  List<Object?> get props => [id, foodMaster];

  static Favourite fromFavouritesList(dynamic jsonData) {
    Map<dynamic, dynamic> testJson = jsonData['item_master'];
    return Favourite(
      id: jsonData['id'].toString(),
      foodMaster: FoodMaster.fromFoodMasterList(testJson),
    );
  }
}
