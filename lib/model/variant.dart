import 'package:equatable/equatable.dart';

class Variant extends Equatable {
  String? size;
  String? spicyLevel;
  String? choiceofA;
  int? choiceofAPrice;
  String? choiceofB;
  int? choiceofBPrice;
  String? choiceofC;
  int? choiceofCPrice;
  String? choiceofD;
  int? choiceofDPrice;
  String? choiceofAddA;
  int? choiceofAddAPrice;
  String? choiceofAddB;
  int? choiceofAddBPrice;
  String? choiceofAddC;
  int? choiceofAddCPrice;
  String? itemColor;

  Variant({
    this.size,
    this.spicyLevel,
    this.choiceofA,
    this.choiceofAPrice,
    this.choiceofB,
    this.choiceofAddAPrice,
    this.choiceofC,
    this.choiceofCPrice,
    this.choiceofD,
    this.choiceofDPrice,
    this.choiceofAddA,
    this.choiceofAddB,
    this.choiceofAddBPrice,
    this.choiceofAddC,
    this.choiceofBPrice,
    this.choiceofAddCPrice,
    this.itemColor,
  });

  static Variant fromVariantList(dynamic jsonData) {
    return Variant(
      size: jsonData['size'],
      spicyLevel: jsonData['spicy_level'],
      choiceofA: jsonData['choice_of_a'],
      choiceofAPrice: jsonData['choice_of_a_price'],
      choiceofB: jsonData['choice_of_b'],
      choiceofBPrice: jsonData['choice_of_b_price'],
      choiceofC: jsonData['choice_of_c'],
      choiceofCPrice: jsonData['choice_of_c_price'],
      choiceofD: jsonData['choice_of_d'],
      choiceofDPrice: jsonData['choice_of_d_price'],
      choiceofAddA: jsonData['choice_of_add_a'],
      choiceofAddAPrice: jsonData['choice_of_add_a_price'],
      choiceofAddB: jsonData['choice_of_add_b'],
      choiceofAddBPrice: jsonData['choice_of_add_b_price'],
      choiceofAddC: jsonData['choice_of_add_c'],
      choiceofAddCPrice: jsonData['choice_of_add_c_price'],
      itemColor: jsonData['item_color'],
    );
  }

  @override
  List<Object?> get props => [
        size,
        spicyLevel,
        choiceofA,
        choiceofAPrice,
        choiceofB,
        choiceofBPrice,
        choiceofC,
        choiceofCPrice,
        choiceofD,
        choiceofDPrice,
        choiceofAddA,
        choiceofAddAPrice,
        choiceofAddB,
        choiceofAddBPrice,
        choiceofAddC,
        choiceofAddCPrice,
        itemColor
      ];
}
