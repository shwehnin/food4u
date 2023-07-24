class Api {
  static Future<bool> getAllCats() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  static Future<bool> getAllItems() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}
