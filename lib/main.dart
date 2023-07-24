import 'dart:io';

import 'package:bestcannedfood_ecommerce/blocs/carts/carts_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/categories/categories_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/companies/companies_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/delivery_ares/delivery_areas_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/foods/foods_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/my_order/my_order_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/news/news_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/news_detail/news_detail_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/notifications/notifications_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/payments_types/payment_types_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/popular_foods/popular_foods_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/profile/profile_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/reviews/reviews_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/sub_categories/sub_categories_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/users/users_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/voucher/voucher_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/themes/theme.dart';
import 'package:bestcannedfood_ecommerce/data/repositories.dart';
import 'package:bestcannedfood_ecommerce/kaungmyan_bloc_observer.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/cart/cart_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/categories/categories_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/check_out/check_out_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/favorite/favorite_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/forgot_password/forgot_password_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/home/home_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/home_search/home_search_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/sub_categories/sub_category_item_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/my_order/my_order_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/my_order/order_detail_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/new_screen/new_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/notification/notification_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/otp/otp_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/payment/payment_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/phone_number/change_phone_number.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/product_details/product_details_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/profile_screen/profile_screen.dart';

import 'package:bestcannedfood_ecommerce/presentations/pages/setting/setting_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/shop/shop_detail_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/sign_in/signin_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/sign_up/sign_up_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/splash/splash_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/sub_categories/sub_categories_screen.dart';

import 'package:bestcannedfood_ecommerce/presentations/pages/voucher_screen/voucher_screen.dart';

import 'package:bestcannedfood_ecommerce/presentations/widgets/payment/add_new_card.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/sidebar/no_auth.dart';
import 'package:bestcannedfood_ecommerce/translations/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyHttpOverrides extends HttpOverrides {
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  //print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = KaungMyanBlocObserver();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final EcommerceRepository ecommerceRepository =
      EcommerceRepository(ecommerceApiClient: EcommerceApiClient());

  runApp(EasyLocalization(
    supportedLocales: [
      // ignore: prefer_const_constructors
      Locale('en'),
      // ignore: prefer_const_constructors
      Locale('my')
    ],
    path: 'assets/translations',
    assetLoader:
        const CodegenLoader(), // <-- change the path of the translation files
    fallbackLocale: Locale(
      'en',
    ),
    child: MultiBlocProvider(providers: [
      BlocProvider<UsersBloc>(
        create: (context) =>
            UsersBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<FoodsBloc>(
        create: (context) =>
            FoodsBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<PopularFoodsBloc>(
        create: (context) =>
            PopularFoodsBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<NewsBloc>(
        create: (context) => NewsBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<NewsDetailBloc>(
        create: (context) =>
            NewsDetailBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<FavouritesBloc>(
        create: (context) =>
            FavouritesBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<VoucherBloc>(
        create: (context) =>
            VoucherBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<CategoriesBloc>(
        create: (context) =>
            CategoriesBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<CartsBloc>(
        create: (context) =>
            CartsBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<ProfileBloc>(
        create: (context) =>
            ProfileBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<DeliveryBloc>(
        create: (context) =>
            DeliveryBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<MyOrdersBloc>(
        create: (context) =>
            MyOrdersBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<ReviewsBloc>(
        create: (context) =>
            ReviewsBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<CompaniesBloc>(
        create: (context) =>
            CompaniesBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<NotificationsBloc>(
        create: (context) =>
            NotificationsBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<PaymentTypesBloc>(
        create: (context) =>
            PaymentTypesBloc(ecommerceRepository: ecommerceRepository),
      ),
      BlocProvider<SubCategoriesBloc>(
        create: (context) =>
            SubCategoriesBloc(ecommerceRepository: ecommerceRepository),
      )
    ], child: KaungmyanEcommerceApp()),
  ));
}

class KaungmyanEcommerceApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kMaterialAppTitle,
      debugShowCheckedModeBanner: false,
      theme: theme(),
      builder: EasyLoading.init(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: (settings) {
        if (settings.name == "/product_detail") {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => ProductDetailScreen(),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c));
        }

        // Unknown route
        return MaterialPageRoute(builder: (_) => HomeScreen());
      },
      routes: {
        '/': (context) => SplashScreen(),
        'no_auth': (context) => NoAuth(),
        '/signup': (context) => SignupScreen(),
        '/signin': (context) => SigninScreen(),
        '/home': (context) => HomeScreen(),
        '/search': (context) => HomeSearchScreen(),
        '/subcategory_items': (context) => SubCategoryItemScreen(),
        '/profile': (context) => ProfileScreen(
              isBackButton: true,
            ),
        '/my_order': (context) => MyOrderScreen(),
        '/order_detail': (context) => OrderDetailScreen(),
        '/payment': (context) => PaymentScreen(),
        '/coupon': (context) => VoucherScreen(),
        '/cart': (context) => CartScreen(
              isShowbackButton: true,
            ),
        '/checkout': (context) => CheckoutScreen(),
        '/otp': (context) => OtpScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
        '/home_search': (context) => HomeSearchScreen(),
        '/new': (context) => NewScreen(),
        '/settings': (context) => SettingsScreen(),
        '/add_card': (context) => AddNewCard(),
        '/shop_detail': (context) => ShopDetailScreen(),
        '/favorite': (context) => FavoriteScreen(
              isShowAppbar: false,
            ),
        '/change_phone_number': (context) => ChangePhoneNumberScreen(),
        //'/forgot_change_password': (context) => ForgotChangePasswordScreen(phoneNumber: '',),
        '/notification': (context) => NotificationScreen(),
        '/categories': (context) => CategoriesScreen(),
        '/sub_categories': (context) => SubCategoriesScreen(),
      },
    );
  }
}
