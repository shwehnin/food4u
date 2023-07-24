import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_api_client.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/model/reviews.dart';
import 'package:bestcannedfood_ecommerce/model/sub_category.dart';

class EcommerceRepository {
  final EcommerceApiClient ecommerceApiClient;

  EcommerceRepository({required this.ecommerceApiClient});

  //User
  Future<Map<dynamic, dynamic>> getUserLogin(
      String phone, String password, String fcmToken) async {
    return ecommerceApiClient.getUserLogin(phone, password, fcmToken);
  }

  Future<Map<dynamic, dynamic>> createUserAccount(
      String name,
      String phone,
      String password,
      String deliveryLocation,
      int deliveryAreaId,
      String fcmToken) async {
    return ecommerceApiClient.createUserAccount(
        name, phone, password, deliveryLocation, deliveryAreaId, fcmToken);
  }

  Future<Map<dynamic, dynamic>> registerWithFacebook(
      String facebookId, String name, String email, String fcmToken) async {
    return ecommerceApiClient.registerWithFacebook(
        facebookId, name, email, fcmToken);
  }

  Future<String> getForgotPassword(String phone) async {
    return ecommerceApiClient.forgotPassword(phone);
  }

  Future<Map<dynamic, dynamic>> getResetPassword(String phone, String password,
      String confirmPassword, String fcmToken) async {
    return ecommerceApiClient.resetPassword(
        phone, password, confirmPassword, fcmToken);
  }

  Future<Map<dynamic, dynamic>> getLogout(String token) async {
    return ecommerceApiClient.getUserLogout(token);
  }

  Future<List<dynamic>> getDeliveryAreaIds(
      String keyword, String sort, String order) async {
    return ecommerceApiClient.getDeliveryAreaIds(keyword, sort, order);
  }

  Future<List<Category>> getCategoriesList(
      String keyword, String sort, String order) async {
    return ecommerceApiClient.getCategoriesList(keyword, sort, order);
  }

  //Foods
  Future<Map<dynamic, dynamic>> getFoodsList(
      String category,
      String subCategory,
      String size,
      String spicyLevel,
      String minPrice,
      String maxPrice,
      String keyword,
      String order,
      int paginate,
      int page,
      String token,
      String sort) async {
    return ecommerceApiClient.getFoodsList(
        category,
        subCategory,
        size,
        spicyLevel,
        minPrice,
        maxPrice,
        keyword,
        order,
        paginate,
        page,
        token,
        sort);
  }

  Future<List<FoodMaster>> getFoodsLimitList(int limit, String token) async {
    return ecommerceApiClient.getFoodsLimitList(limit, token);
  }

  Future<FoodMaster> getFoodsDetails(
    String id,
  ) async {
    return ecommerceApiClient.getFoodsDetails(id);
  }

  //News
  Future<Map<dynamic, dynamic>> getNewsList(
      String keyword, String sort, String order, int paginate, int page) async {
    return ecommerceApiClient.getNewsList(keyword, sort, order, paginate, page);
  }

  Future<News> getNewsDetail(String slug) async {
    return ecommerceApiClient.getNewsDetail(slug);
  }

  //Favourites
  Future<Map<dynamic, dynamic>> getFavouriteList(
    String keyword,
    String sort,
    String order,
    int paginate,
    int page,
    String token,
  ) async {
    return ecommerceApiClient.getFavouriteList(
      keyword,
      sort,
      order,
      paginate,
      page,
      token,
    );
  }

  //Get Voucher List
  Future<Map<dynamic, dynamic>> getVoucherList(
      String token, String sort, String order, int paginate, int page) async {
    return ecommerceApiClient.getVoucherList(
        token, sort, order, paginate, page);
  }

  Future<Map<dynamic, dynamic>> getVoucherVerify(
      String token, String voucher) async {
    return ecommerceApiClient.getVoucherVerify(token, voucher);
  }

  //Favourite Foods
  Future<String> createFavouriteFood(String token, int foodId) async {
    return ecommerceApiClient.createFavouriteFood(token, foodId);
  }

  Future<Map<dynamic, dynamic>> getCreateCheckOut(
      String token,
      String voucher,
      String preferredDate,
      String preferredTime,
      String deliveryNote,
      int paymentType,
      String receiptFile,
      double grandTotal) async {
    return ecommerceApiClient.getCreateCheckOut(token, voucher, preferredDate,
        preferredTime, deliveryNote, paymentType, receiptFile, grandTotal);
  }

  //Reviews
  Future<List<Reviews>> getReviewList(String sort, String order, int paginate,
      int page, int foodId, String token) async {
    return ecommerceApiClient.getReviewList(
        sort, order, paginate, page, foodId, token);
  }

  Future<String> createdReview(String message, double rating, int foodId,
      String foodName, String token) async {
    return ecommerceApiClient.createdReview(
        message, rating, foodId, foodName, token);
  }

  Future<String> deleteReview(int reviewId, String token) async {
    return ecommerceApiClient.deleteReview(reviewId, token);
  }

  //Cart
  Future<String> getAddToCart(
    int foodId,
    int orderQty,
    String size,
    String spicyLevel,
    bool choiceOfA,
    bool choiceOfB,
    bool choiceOfC,
    bool choiceOfD,
    bool addOnA,
    bool addOnB,
    bool addOnC,
    bool addOnD,
    bool addOnE,
    String token,
    String itemColor,
  ) async {
    return ecommerceApiClient.getAddToCart(
      foodId,
      orderQty,
      size,
      spicyLevel,
      choiceOfA,
      choiceOfB,
      choiceOfC,
      choiceOfD,
      addOnA,
      addOnB,
      addOnC,
      addOnD,
      addOnE,
      token,
      itemColor,
    );
  }

  //get carts start
  Future<Map<dynamic, dynamic>> getCarts(String token) async {
    return ecommerceApiClient.getCartList(token);
  }
  //get carts end

  //update cart start
  Future<Map<dynamic, dynamic>> updateCart(
      String token, int cartItemId, int orderQty) async {
    return ecommerceApiClient.updateCart(token, cartItemId, orderQty);
  }

  //update cart end

  //delete cart start
  Future<Map<dynamic, dynamic>> deleteCart(String token, int cartItemId) async {
    return ecommerceApiClient.cartDelete(token, cartItemId);
  }
  //delete cart end

  Future<User> getProfile(String token) async {
    return ecommerceApiClient.getProfile(token);
  }

  // Future<User> updateProfileLocation(
  Future<Map<dynamic, dynamic>> updateProfileLocation(
    String token,
    String customerName,
    String deliveryLocation,
    int deliAreasId,
    String email,
  ) async {
    return ecommerceApiClient.updateProfileInformation(
        token, customerName, deliveryLocation, deliAreasId, email);
  }

  Future<Map<String, dynamic>> updateProfilePhone(
    String token,
    String phone,
  ) async {
    return ecommerceApiClient.updateProfilePhone(token, phone);
  }

  Future<User> verifyProfilePhone(
    String token,
    String phone,
  ) async {
    return ecommerceApiClient.verifyProfilePhone(token, phone);
  }

  Future<Map<dynamic, dynamic>> updateProfilePassword(
    String token,
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    return ecommerceApiClient.updateProfilePassword(
        token, currentPassword, newPassword, confirmPassword);
  }

  Future<Map<dynamic, dynamic>> getAllMyOrdersList(String token, String sort,
      String order, int paginate, int page, String status) async {
    return ecommerceApiClient.getAllMyOrdersList(
        token, sort, order, paginate, page, status);
  }

  Future<MyOrder> getOrderDetail(String token, int id) async {
    return ecommerceApiClient.getOrderDetail(token, id);
  }

  //get notitications start
  Future<Map<dynamic, dynamic>> getNotificationList(String token) async {
    return ecommerceApiClient.getNotificationList(token);
  }

  Future<Map<dynamic, dynamic>> getNotificationDetails(
      String token, int notificationId) async {
    return ecommerceApiClient.getNotificationDetails(token, notificationId);
  }

  Future<String> getNotificationDelete(String token, String id) async {
    return ecommerceApiClient.getNotificationDelete(token, id);
  }

  //get Companies
  Future<List<Company>> getCompaniesList(
      String keyword, String sort, String order) async {
    return ecommerceApiClient.getCompaniesList(keyword, sort, order);
  }

  //Payments
  Future<List<PaymentTypes>> getPaymentList(String token) async {
    return ecommerceApiClient.getPaymentList(token);
  }

  //get Sub Categories
  Future<List<SubCategory>> getSubCategoriesList(
      int categoryId, String category, String sort, String order) async {
    return ecommerceApiClient.getSubCategoriesList(
        categoryId, category, sort, order);
  }
}
