import 'package:equatable/equatable.dart';

class News extends Equatable {
  final int id;
  String? status;
  final String title;
  String? description;
  final String newsImage;
  String? referUrl;
  String? updatedAt;
  List<News>? relatedNews;
  String? slug;

  News(
      {required this.id,
      this.status,
      required this.title,
      this.description,
      required this.newsImage,
      this.referUrl,
      this.updatedAt,
      this.relatedNews,
      this.slug});

  @override
  List<Object> get props => [
        id,
        slug ?? '',
        status ?? '',
        title,
        description ?? '',
        newsImage,
        referUrl ?? '',
        updatedAt ?? '',
        relatedNews ?? [],
      ];

  static News fromNewsLists(dynamic json) {
    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      slug: json['slug'],
      newsImage: json['news_image'],
      updatedAt: json['updated_at'],
    );
  }

  static News fromNewsDetails(dynamic json) {
    return News(
        id: json['id'],
        status: json['status'],
        title: json['title'],
        slug: json['slug'],
        description: json['description'],
        newsImage: json['news_image'],
        referUrl: json['refer_url'],
        updatedAt: json['updated_at'],
        relatedNews:
            List<News>.from(json['related'].map((i) => News.fromNewsLists(i)))
                .toList());
  }
}
