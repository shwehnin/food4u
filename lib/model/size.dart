class SizeSearch {
  String name;

  SizeSearch({
    required this.name,
  });

  factory SizeSearch.fromJson(dynamic data) {
    return SizeSearch(
      name: data['name'],
    );
  }
}
