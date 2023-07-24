class Order {
  String name;
  Order({required this.name});

  factory Order.fromJson(dynamic data) {
    return Order(name: data['name']);
  }
}
