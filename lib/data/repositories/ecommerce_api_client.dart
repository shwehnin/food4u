import 'dart:io';

import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/model/reviews.dart';
import 'package:bestcannedfood_ecommerce/model/sub_category.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class EcommerceApiClient {
  Dio dio = new Dio();

  //User Login
  Future<Map<dynamic, dynamic>> getUserLogin(
      String phoneNumber, String password, String fcmToken) async {
    final String urlString = baseUrl + 'login';
    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();

    var data;
    try {
      Response response = await dio.post(urlString, data: {
        "phone": phoneNumber,
        "password": password,
        "fcm_token": fcmToken
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception('${error.response!.data['message']}');
      }
    }

    return data;
  }

  //User Register
  Future<Map<dynamic, dynamic>> createUserAccount(
      String name,
      String phone,
      String password,
      String deliveryLocation,
      int deliAreaId,
      String fcmToken) async {
    final String urlString = baseUrl + 'register';

    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.post(urlString, data: {
        "customer_name": name,
        "phone": phone,
        "password": password,
        "delivery_location": deliveryLocation,
        "deli_areas_id": deliAreaId != -1 ? deliAreaId : '',
        "fcm_token": fcmToken
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }

    return data;
  }

  //User Register with facebook
  Future<Map<dynamic, dynamic>> registerWithFacebook(String facebookProfileId,
      String name, String email, String fcmToken) async {
    final String urlString = baseUrl + 'auth/facebook';

    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.post(urlString, data: {
        "id": facebookProfileId,
        "customer_name": name,
        //"phone": phone,
        "email": email,
        //"delivery_location": deliveryLocation,
        //"deli_areas_id": deliAreaId,
        "fcm_token": fcmToken
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response!.data));
      }
    }
    return data;
  }

  //User Forgot Password
  Future<String> forgotPassword(String phone) async {
    final String urlString = baseUrl + 'forget';
    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.post(urlString, data: {
        "phone": getPhoneNumberFormat(phone),
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(error.response?.data['message']);
      }
    }

    return data['message'];
  }

  //User Reset Password
  Future<Map<dynamic, dynamic>> resetPassword(String phone, String password,
      String confirmPassword, String fcmToken) async {
    final String urlString = baseUrl + 'reset';
    dio.options.headers['Accept'] = 'application/json';

    _dioAdapter();
    var data;

    try {
      Response response = await dio.post(urlString, data: {
        "phone": getPhoneNumberFormat(phone),
        "password": password,
        "confirm_password": confirmPassword,
        "api_token": forgotToken,
        "fcm_token": fcmToken
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(error.response?.data['message']);
      }
    }

    return data;
  }

  //GET Log out
  Future<Map<dynamic, dynamic>> getUserLogout(
    String token,
  ) async {
    final urlString = baseUrl + 'logout';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.get(urlString);

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }

    return data;
  }

  //GET Foods List

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
    final urlString = baseUrl + 'items';

    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();
    // ignore: unnecessary_null_comparison
    if (token != null) {
      dio.options.headers['authorization'] = 'Bearer $token';
    }

    var data;
    try {
      Response response = await dio.get(urlString, queryParameters: {
        'subcategory': subCategory,
        'category': category,
        'size': size,
        'sort': sort,
        'spicy_level': spicyLevel,
        'min_price': minPrice,
        'max_price': maxPrice,
        'keyword': keyword,
        'order': order,
        'paginate': paginate,
        'page': page
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }

    return data;
  }

  Future<List<FoodMaster>> getFoodsLimitList(int limit, String token) async {
    final urlString = baseUrl + 'items';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.get(urlString, queryParameters: {
        'limit': limit,
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    List<FoodMaster> list = List<FoodMaster>.from(
        data.map((i) => FoodMaster.fromFoodMasterList(i)));

    return list;
  }

  Future<FoodMaster> getFoodsDetails(
    String int,
  ) async {
    final urlString = baseUrl + 'items/$int';

    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.get(urlString);

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        showErrorMessage(getErrorText(error.response?.data));
        throw Exception(getErrorText(error.response?.data));
      }
    }
    FoodMaster foodMaster = FoodMaster.fromFoodMasterList(data);
    return foodMaster;
  }

  //Get News List API
  Future<Map<dynamic, dynamic>> getNewsList(
      String keyword, String sort, String order, int paginate, int page) async {
    final urlString = baseUrl + 'news';

    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();

    Response response = await dio.get(urlString, queryParameters: {
      'keyword': keyword,
      'sort': sort,
      'order': order,
      'paginate': paginate,
      'page': page
    });

    if (response.statusCode != 200) {
      throw Exception('error getting News list request');
    }

    return response.data;
  }

  //Get News Detail API
  Future<News> getNewsDetail(String slug) async {
    final urlString = baseUrl + 'news/$slug';

    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.get(urlString);

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }

    return News.fromNewsDetails(data);
  }

  //Get DeliveryArea List Api
  Future<List<dynamic>> getDeliveryAreaIds(
      String keyword, String sort, String order) async {
    final urlString = baseUrl + 'deli_limited_areas';

    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.get(urlString, queryParameters: {
        'keyword': keyword,
        'sort': sort,
        'order': order,
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }

    return data;
  }

  //GET categories list api
  Future<List<Category>> getCategoriesList(
      String keyword, String sort, String order) async {
    final urlString = baseUrl + 'categories';
    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.get(urlString, queryParameters: {
        'keyword': keyword,
        'sort': sort,
        'order': order,
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }
    List<Category> _categoriesList =
        List<Category>.from(data.map((i) => Category.fromCategoryList(i)));

    return _categoriesList;
  }

  //GET favourite list api
  Future<Map<dynamic, dynamic>> getFavouriteList(
    String keyword,
    String sort,
    String order,
    int paginate,
    int page,
    String token,
  ) async {
    final urlString = baseUrl + 'favourite';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.get(urlString, queryParameters: {
        'keyword': keyword,
        'sort': sort,
        'order': order,
        'paginate': paginate,
        'page': page,
        'token': token,
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    return data;
  }

  //Create favourite food list api
  Future<String> createFavouriteFood(String token, int foodId) async {
    final urlString = baseUrl + 'favourite';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.post(urlString, data: {
        "token": token,
        "item_id": foodId,
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(error.response?.data['message']);
      }
    }

    return data['message'];
  }

  //Get Voucher List API
  Future<Map<dynamic, dynamic>> getVoucherList(
      String token, String sort, String order, int paginate, int page) async {
    final urlString = baseUrl + 'vouchers';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] =
        "Bearer " + token; //"Bearer ${token}";
    _dioAdapter();

    Response response = await dio.get(urlString, queryParameters: {
      'token': token,
      'sort': sort,
      'order': order,
      'paginate': paginate,
      'page': page
    });
    if (response.statusCode != 200) {
      throw Exception('error getting Vouchers list request');
    }

    return response.data;
  }

  //Get Voucher List API
  Future<Map<dynamic, dynamic>> getVoucherVerify(
      String token, String voucher) async {
    final urlString = baseUrl + 'voucher/verify';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.post(urlString, data: {
        'token': token,
        'voucher': voucher,
      });

      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(error.response?.data['message']);
      }
    }
    return data;
  }

  //Create checkout
  Future<Map<dynamic, dynamic>> getCreateCheckOut(
      String token,
      String voucher,
      String preferredDate,
      String preferredTime,
      String deliveryNote,
      int paymentType,
      String receiptFile,
      double grandTotal) async {
    final urlString = baseUrl + 'checkout';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;
    FormData formData = FormData.fromMap({
      'token': token,
      "voucher": voucher,
      "preferred_date": preferredDate,
      "preferred_time": preferredTime,
      "delivery_note": deliveryNote,
      "payment_id": paymentType,
      "grand_total": grandTotal
    });

    if (receiptFile != '') {
      formData.files.add(
        MapEntry(
            "receipt_evidence_file", await MultipartFile.fromFile(receiptFile)),
      );
    }

    try {
      Response response = await dio.post(urlString, data: formData);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }

    return data;
  }

  //Get reviews list
  Future<List<Reviews>> getReviewList(String sort, String order, int paginate,
      int page, int foodId, String token) async {
    final urlString = baseUrl + 'items/$foodId/reviews/';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.get(urlString, queryParameters: {
        'sort': sort,
        'order': order,
        'paginate': paginate,
        'page': page,
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }
    List<Reviews> list = List<Reviews>.from(
        data['data'].map((i) => Reviews.fromReviewsLists(i)));
    return list;
  }

  //Create reviews
  Future<String> createdReview(String message, double rating, int foodId,
      String foodName, String token) async {
    final urlString = baseUrl + 'reviews/';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.post(urlString, data: {
        'message': message,
        'rating': rating,
        'item_id': foodId,
        'item_name': foodName
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }

    return LocaleKeys.added_reviews.tr();
  }

  //Delete reviews
  Future<String> deleteReview(int reviewId, String token) async {
    final urlString = baseUrl + 'reviews/$reviewId';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.delete(urlString);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }

    return data['message'];
  }

  //Add to cart
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
    final urlString = baseUrl + 'cart';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.post(urlString, data: {
        "item_id": foodId,
        "order_qty": 1,
        "variants": {
          "item_color": itemColor,
          "size": size,
          'spicy_level': spicyLevel,
          "choice_of_a": choiceOfA,
          "choice_of_b": choiceOfB,
          "choice_of_c": choiceOfC,
          "choice_of_d": choiceOfD,
          "choice_of_add_a": addOnA,
          "choice_of_add_b": addOnB,
          "choice_of_add_c": addOnC,
          "choice_of_add_d": addOnD,
          "choice_of_add_e": addOnE,
        }
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response!.data));
      }
    }
    String message =
        data != null ? '1 new item(s) have been added to your cart.' : '';
    return message;
  }

  //Delete cart
  Future<Map<dynamic, dynamic>> cartDelete(String token, int cartItemId) async {
    final cartDeleteUrl = baseUrl + 'cart/$cartItemId';
    Dio dio = new Dio();
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;
    try {
      Response response = await dio.delete(cartDeleteUrl, queryParameters: {
        'token': token,
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }
    return data;
  }

  Future<Map<dynamic, dynamic>> updateCart(
      String token, int cartItemId, int orderQty) async {
    final cartUpdateUrl = baseUrl + 'cart/$cartItemId';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;
    try {
      Response response = await dio.put(cartUpdateUrl, queryParameters: {
        'token': token,
      }, data: {
        'order_qty': orderQty
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }

    return data;
  }

  Future<Map<dynamic, dynamic>> getCartList(String token) async {
    final urlString = baseUrl + 'cart';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();
    var data;
    try {
      Response response =
          await dio.get(urlString, queryParameters: {'token': token});
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response!.data));
      }
    }
    return data.length == 0 ? {} : data;
  }

  //Get Profile API
  Future<User> getProfile(String token) async {
    final urlString = baseUrl + 'profile';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + token;
    _dioAdapter();

    var data;
    try {
      Response response = await dio.get(urlString);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }

    return User.fromUserForProfile(data);
  }

  //Update Profile Location API
  Future<Map<dynamic, dynamic>> updateProfileInformation(
    String token,
    String customerName,
    String deliveryLocation,
    int deliAreasId,
    String email,
  ) async {
    final urlString = baseUrl + 'change/profile';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + token;
    _dioAdapter();

    var requestParameter = {
      'customer_name': customerName,
      'delivery_location': deliveryLocation,
      'deli_areas_id': deliAreasId,
      'email': email
    };

    if (email == '') {
      requestParameter.remove('email');
    }
    var data;
    try {
      Response response =
          await dio.put(urlString, queryParameters: requestParameter);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    return data;
  }

  //Update Profile Phone API
  Future<Map<String, dynamic>> updateProfilePhone(
    String token,
    String phone,
  ) async {
    final urlString = baseUrl + 'change/phone';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + token;
    _dioAdapter();

    var data;

    try {
      Response response = await dio.put(urlString, queryParameters: {
        'token': token,
        'phone': getPhoneNumberFormat(phone)
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }

    return data;
  }

  //Verify Profile Phone API
  Future<User> verifyProfilePhone(
    String token,
    String phone,
  ) async {
    final urlString = baseUrl + 'verify/phone';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + token;
    _dioAdapter();
    var data;

    try {
      Response response = await dio.put(urlString, queryParameters: {
        'token': token,
        'phone': getPhoneNumberFormat(phone)
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    EasyLoading.showSuccess(data['message'], duration: Duration(seconds: 3));
    return User.fromUserForProfile(data['data']);
  }

  //Update Profile Password API
  Future<Map<dynamic, dynamic>> updateProfilePassword(
    String token,
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final urlString = baseUrl + 'change/password';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + token;
    _dioAdapter();
    var data;

    try {
      Response response = await dio.put(urlString, queryParameters: {
        'token': token,
        'current_password': currentPassword,
        'password': newPassword,
        'confirm_password': confirmPassword,
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    return data;
  }

  //Get My Orders List API
  Future<Map<dynamic, dynamic>> getAllMyOrdersList(String token, String sort,
      String order, int paginate, int page, String status) async {
    final urlString = baseUrl + 'orders';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + token;
    _dioAdapter();

    var data;

    try {
      Response response = await dio.get(urlString, queryParameters: {
        'token': token,
        'sort': sort,
        'order': order,
        'paginate': paginate,
        'status': status,
        'page': page
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    return data;
  }

  //Get My Order Detail API
  Future<MyOrder> getOrderDetail(String token, int id) async {
    final urlString = baseUrl + 'orders/$id';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + token;
    _dioAdapter();
    var data;

    try {
      Response response = await dio.get(urlString);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    return MyOrder.fromMyOrdersList(data);
  }

  //Get Notifications List API start
  Future<Map<dynamic, dynamic>> getNotificationList(String token) async {
    final urlString = baseUrl + 'notifications';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.get(urlString);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    return data;
  }

  //Get Payment List API start
  Future<List<PaymentTypes>> getPaymentList(String token) async {
    final urlString = baseUrl + 'payment_types';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.get(urlString);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    List<PaymentTypes> list =
        List<PaymentTypes>.from(data.map((i) => PaymentTypes.fromJson(i)));
    return list;
  }

  Future<Map<dynamic, dynamic>> getNotificationDetails(
      String token, int notificationId) async {
    final urlString = baseUrl + 'notifications/$notificationId';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.get(urlString);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    return data;
  }

  //Notification Read
  Future<String> getNotificationDelete(String token, String id) async {
    final urlString = baseUrl + 'notifications/$id';

    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['authorization'] = 'Bearer $token';
    _dioAdapter();

    final response = await dio.get(urlString);

    if (response.statusCode != 200) {
      throw Exception('error creating in notification deleted');
    }

    var data;

    try {
      Response response = await dio.get(urlString);
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    return data['success'];
  }

  //Get Companies List API start
  Future<List<Company>> getCompaniesList(
      String keyword, String sort, String order) async {
    final urlString = baseUrl + 'companies';

    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();

    var data;

    try {
      Response response = await dio.get(urlString, queryParameters: {
        'keyword': keyword,
        'sort': sort,
        'order': order,
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception(getErrorText(error.response?.data));
      }
    }
    List<Company> list =
        List<Company>.from(data.map((i) => Company.fromCompanyList(i)));

    return list;
  }

  _dioAdapter() {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }

  //GET Sub Categories List api
  Future<List<SubCategory>> getSubCategoriesList(
    int categoryId,
    String category,
    String sort,
    String order,
  ) async {
    final urlString =
        baseUrl + 'subcategories?category_id=$categoryId&category=$category';
    dio.options.headers['Accept'] = 'application/json';
    _dioAdapter();
    var data;

    try {
      Response response = await dio.get(urlString, queryParameters: {
        'categoryId': categoryId,
        'sort': sort,
        'order': order
      });
      data = response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.receiveTimeout) {}
      if (error.response?.statusCode != 200) {
        throw Exception();
      }
    }
    List<SubCategory> _subCategoriesList = List<SubCategory>.from(
        data.map((i) => SubCategory.fromSubCategoryList(i)));
    return _subCategoriesList;
  }
}
