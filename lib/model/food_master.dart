import 'package:bestcannedfood_ecommerce/model/promotion_discount.dart';
import 'package:bestcannedfood_ecommerce/model/sub_category.dart';
import 'package:equatable/equatable.dart';

class FoodMaster extends Equatable {
  final int? fCategoryId;
  final String? itemCode;
  final String? slug;
  final int? unitPrice;
  final double? eptTime;
  final double? totalStars;
  int? feedbackCount;
  final String? id;
  final String? foodName;
  final int? orderQty;
  final String? imageA;
  final String? imageB;
  final String? imageC;
  final String? imageD;
  final String? imageE;
  final String? status;
  final String? description;
  final double? discountAmount;

  final String? choiceOfA;
  final String? choiceOfB;
  final String? choiceOfC;
  final String? choiceOfD;
  final int? choiceOfAPrice;
  final int? choiceOfBPrice;
  final int? choiceOfCPrice;
  final int? choiceOfDPrice;

  final String? addOnA;
  final String? addOnB;
  final String? addOnC;
  final String? addOnD;
  final String? addOnE;
  final int? addOnAPrice;
  final int? addOnBPrice;
  final int? addOnCPrice;
  final int? addOnDPrice;
  final int? addOnEPrice;

  // final Category? category;
  final String? category;
  final List<String>? sizes;
  final List<String>? spicyLevels;
  final List<PromotionDiscount>? promotionDiscount;
  final int? packageFee;
  final bool? isFavourite;
  final String? urlType;
  final String? facebookUrl;
  final String? youtubeUrl;
  final String? instagramUrl;
  final double? subTotal;
  final String? url;
  final String? itemColor;
  final String? poUnit;
  final int? unitValue;
  final String? whUnit;
  final SubCategory? subCategory;

  FoodMaster({
    this.id,
    this.itemCode,
    this.foodName,
    this.slug,
    this.orderQty,
    this.imageA,
    this.imageB,
    this.imageC,
    this.imageD,
    this.imageE,
    this.fCategoryId,
    this.unitPrice,
    this.eptTime,
    this.totalStars,
    this.feedbackCount,
    this.status,
    this.description,
    this.discountAmount,
    this.choiceOfA,
    this.choiceOfB,
    this.choiceOfC,
    this.choiceOfD,
    this.choiceOfAPrice,
    this.choiceOfBPrice,
    this.choiceOfCPrice,
    this.choiceOfDPrice,
    this.addOnA,
    this.addOnB,
    this.addOnC,
    this.addOnD,
    this.addOnE,
    this.addOnAPrice,
    this.addOnBPrice,
    this.addOnCPrice,
    this.addOnDPrice,
    this.addOnEPrice,
    this.category,
    this.sizes,
    this.spicyLevels,
    this.promotionDiscount,
    this.packageFee,
    this.isFavourite,
    this.urlType,
    this.facebookUrl,
    this.instagramUrl,
    this.youtubeUrl,
    this.subTotal,
    this.url,
    this.itemColor,
    this.poUnit,
    this.unitValue,
    this.whUnit,
    this.subCategory,
  });

  static FoodMaster fromFoodMasterList(Map<dynamic, dynamic> jsonData) {
    return FoodMaster(
      id: jsonData['id'] == null ? '' : jsonData['id'].toString(),
      itemCode: jsonData['f_bcode_autoinc'] == null
          ? ''
          : jsonData['f_bcode_autoinc'].toString(),
      foodName: jsonData['item_name'],
      slug: jsonData['item_master'] != null
          ? jsonData['item_master']['slug']
          : jsonData['slug'],
      orderQty: jsonData['order_qty'],
      imageA: jsonData['item_master'] != null
          ? jsonData['item_master']['image_a']
          : jsonData['image_a'],
      imageB: jsonData['image_b'],
      imageC: jsonData['image_c'],
      imageD: jsonData['image_d'],
      imageE: jsonData['image_e'],
      fCategoryId: jsonData['f_category_id'],
      unitPrice: jsonData['unit_price'],
      eptTime: jsonData['ept_time'] != null
          ? double.parse(jsonData['ept_time'].toString())
          : 0.0,
      totalStars: jsonData['total_stars'] != null
          ? double.parse(jsonData['total_stars'].toString())
          : 0.0,
      feedbackCount: jsonData['feedback_count'],
      status: jsonData['status'],
      description: jsonData['details_description'] != null
          ? jsonData['details_description']
          : null,
      discountAmount: jsonData['discount_amount'],
      choiceOfA:
          jsonData['choice_of_a'] != null ? jsonData['choice_of_a'] : null,
      choiceOfB:
          jsonData['choice_of_b'] != null ? jsonData['choice_of_b'] : null,
      choiceOfC:
          jsonData['choice_of_c'] != null ? jsonData['choice_of_c'] : null,
      choiceOfD:
          jsonData['choice_of_d'] != null ? jsonData['choice_of_d'] : null,
      choiceOfAPrice: jsonData['choice_of_a_price'] != null
          ? jsonData['choice_of_a_price']
          : null,
      choiceOfBPrice: jsonData['choice_of_b_price'] != null
          ? jsonData['choice_of_b_price']
          : null,
      choiceOfCPrice: jsonData['choice_of_c_price'] != null
          ? jsonData['choice_of_c_price']
          : null,
      choiceOfDPrice: jsonData['choice_of_d_price'] != null
          ? jsonData['choice_of_d_price']
          : null,
      addOnA: jsonData['choice_of_add_a'] != null
          ? jsonData['choice_of_add_a']
          : null,
      addOnB: jsonData['choice_of_add_b'] != null
          ? jsonData['choice_of_add_b']
          : null,
      addOnC: jsonData['choice_of_add_c'] != null
          ? jsonData['choice_of_add_c']
          : null,
      addOnD: jsonData['choice_of_add_d'] != null
          ? jsonData['choice_of_add_d']
          : null,
      addOnE: jsonData['choice_of_add_e'] != null
          ? jsonData['choice_of_add_e']
          : null,
      addOnAPrice: jsonData['choice_of_add_a_price'] != null
          ? jsonData['choice_of_add_a_price']
          : null,
      addOnBPrice: jsonData['choice_of_add_b_price'] != null
          ? jsonData['choice_of_add_b_price']
          : null,
      addOnCPrice: jsonData['choice_of_add_c_price'] != null
          ? jsonData['choice_of_add_c_price']
          : null,
      addOnDPrice: jsonData['choice_of_add_d_price'] != null
          ? jsonData['choice_of_add_d_price']
          : null,
      addOnEPrice: jsonData['choice_of_add_e_price'] != null
          ? jsonData['choice_of_add_e_price']
          : null,
      // category: jsonData['category'] != null
      //     ? Category.fromCategoryList(jsonData['category'])
      //     : null,
      category: jsonData['category'] != null ? jsonData['category'] : null,
      sizes: jsonData['size'] != null ? jsonData['size'].cast<String>() : null,
      spicyLevels: jsonData['spicy_level'] != null
          ? jsonData['spicy_level'].cast<String>()
          : null,
      promotionDiscount: jsonData['promotion_discount'] != null
          ? List<PromotionDiscount>.from(jsonData['promotion_discount']
              .map((i) => PromotionDiscount.fromPromotionDiscount(i))).toList()
          : null,
      packageFee: jsonData['package_fee'],
      isFavourite: jsonData['bs_item_favourite'] != null &&
              jsonData['bs_item_favourite'].length != 0
          ? true
          : false,
      urlType: jsonData['url_type'],
      youtubeUrl: jsonData['youtube_url'],
      facebookUrl: jsonData['facebook_url'],
      instagramUrl: jsonData['instagram_url'],
      subTotal: jsonData['sub_total'] != null ? jsonData['sub_total'] : null,
      url: jsonData['url'],
      itemColor: jsonData['item_color'],
      poUnit: jsonData['po_unit'] != null ? jsonData['po_unit'] : '',
      unitValue: jsonData['unit_value'] != null ? jsonData['unit_value'] : 0,
      whUnit: jsonData['wh_unit'] != null ? jsonData['wh_unit'] : '',
      subCategory: jsonData['subcategory'] != null
          ? SubCategory.fromSubCategoryList(jsonData['subcategory'])
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        itemCode,
        foodName,
        slug,
        orderQty,
        imageA,
        imageB,
        imageC,
        imageD,
        imageE,
        fCategoryId,
        unitPrice,
        eptTime,
        totalStars,
        feedbackCount,
        status,
        sizes,
        spicyLevels,
        choiceOfA,
        choiceOfB,
        choiceOfC,
        choiceOfD,
        choiceOfAPrice,
        choiceOfBPrice,
        choiceOfCPrice,
        choiceOfDPrice,
        addOnA,
        addOnB,
        addOnC,
        addOnD,
        addOnE,
        addOnAPrice,
        addOnBPrice,
        addOnCPrice,
        addOnDPrice,
        addOnEPrice,
        category,
        promotionDiscount,
        packageFee,
        isFavourite,
        urlType,
        facebookUrl,
        youtubeUrl,
        instagramUrl,
        url,
        itemColor,
        subCategory,
      ];

  static FoodMaster fromFoodMasterForVoucher(dynamic json) {
    return FoodMaster(
      id: json['id'].toString(),
      foodName: json['item_name'],
    );
  }
}
