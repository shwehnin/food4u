import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Category extends Equatable {
  int? id;
  String? category;
  String? image;

  Category({this.id, this.category, this.image});

  static Category fromCategoryList(dynamic jsonData) {
    return Category(
        id: jsonData['id'],
        category: jsonData['category'],
        image: jsonData['image']);
  }

  @override
  List<Object?> get props => [id, category ?? '', image ?? ''];

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "image": image,
      };
}
