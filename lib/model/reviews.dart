import 'package:equatable/equatable.dart';

class Reviews extends Equatable {
  final int id;
  final String name;
  final String description;
  final int starCount;
  final int userId;
  final int foodId;
  final String date;
  final String foodName;

  Reviews({
    required this.id,
    required this.name,
    required this.description,
    required this.starCount,
    required this.userId,
    required this.foodId,
    required this.date,
    required this.foodName
  });

  @override
  List<Object> get props => [
        id,
        name,
        description,
        starCount,
        userId,
        foodId,
        date
      ];

  static Reviews fromReviewsLists(dynamic json) {
    return Reviews(
      id: int.parse(json['id'].toString()),
      name: json['customer_name'],
      description: json['feedback_message'].toString(),
      starCount: int.parse(json['star_rating'].toString()),
      userId: int.parse(json['feedback_cust_id'].toString()),
      foodId: int.parse(json['feedback_f_masters_id'].toString()),
      date: json['updated_at'],
      foodName: json['item_name']
    );
  }
}
