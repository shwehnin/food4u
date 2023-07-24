import 'package:equatable/equatable.dart';

class SubCategory extends Equatable {
  final int? id;
  final String? subCategory;
  final int? categoryId;

  SubCategory({this.id, this.subCategory, this.categoryId});

  static SubCategory fromSubCategoryList(dynamic jsonData) {
    return SubCategory(
      id: jsonData['id'] != null ? jsonData['id'] : null,
      subCategory: jsonData['sub_category'],
      categoryId:
          jsonData['category_id'] != null ? jsonData['category_id'] : null,
    );
  }

  @override
  List<Object?> get props => [id, subCategory, categoryId];
}
