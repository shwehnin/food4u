import 'dart:io';

import 'package:bestcannedfood_ecommerce/blocs/carts/carts_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/profile/profile_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/messages.dart';
import 'package:bestcannedfood_ecommerce/model/cart.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/delivery_location.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/delivery_time.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/personal_profile.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/profile_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/success/success_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/cart/cart_list.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/payment/payment.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/payment/voucher_code.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';

class CheckoutScreen extends StatefulWidget {
  final List<FoodCart>? cartList;
  final String? token;
  final double? hours;
  final String? logo;
  const CheckoutScreen(
      {Key? key, this.cartList, this.token, this.hours, this.logo})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late ProfileBloc _profileBloc;
  late CartsBloc _cartsBloc;

  late User profile;
  List<FoodCart> cartList = [];
  TextEditingController _noteInputController = TextEditingController();
  String _voucherCode = '';
  String _deliveryDate = '';
  String _deliveryTime = '';
  int _paymentTypeId = 0;
  String _paymentType = '';
  XFile? _bankReceiptFile;

  set _imageFile(XFile? value) {
    _bankReceiptFile = value == null ? null : value;
  }

  dynamic _pickImageError;
  bool isVideo = false;
  Map lists = Map();

  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _cartsBloc = BlocProvider.of<CartsBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);

    _requestCartList();

    // Call API request to get Profile
    _profileBloc.add(
      ProfileRequested(token: widget.token!, isFirstTime: true),
    );
    _profileBloc.add(InitialProfileLoginRequested());
  }

  _requestCartList() {
    _cartsBloc.add(
      CartListRequested(token: widget.token!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (context, isConnected, status) {
        if (isConnected.toString() != 'false') {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(bottom: false, child: _getCheckout()),
            ),
          );
        } else {
          return NoInternetWidget();
        }
      },
    );
  }

  Widget _getCheckout() {
    return ListView(
      children: [
        _appBar,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: phwephweConst),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DeliveryTime(
                hours: widget.hours!,
                onDeliverDate: (String param) {
                  _deliveryDate = param;
                },
                onDeliveryTime: (String param) {
                  _deliveryTime = param;
                },
              ),
              SizedBox(
                height: 10,
              ),
              //DeliveryLocation(),
              _getDeliveryAndProfile,
              SizedBox(
                height: 10,
              ),

              ///TODO
              PaymentTypesWidget(
                token: widget.token!,
                onSelectPaymentId: (String value) {
                  var data = value.split(',');
                  setState(() {
                    _paymentTypeId = int.parse(data[0]);
                    _paymentType = data[1];
                    _bankReceiptFile = null;
                  });
                },
              ),

              _paymentType != '' && _paymentType != 'Cash on delivery'
                  ? _getBankReceipt
                  : Container(),

              SizedBox(
                height: 10,
              ),
              _getDeliveryNote,
              SizedBox(
                height: 10,
              ),
              VoucherCode(
                token: widget.token!,
                onEnterValue: (String param) {
                  _voucherCode = param;
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        /*CartList(
          cartList: widget.cartList!,
          isRemove: true,
          token: widget.token!,
        ),*/
        _getCartItems,
        //TotalCalc(),
        _getProceedCheckOut,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: LocaleKeys.i_agree_that_placing.tr()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  get _appBar {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
      child: CustomAppBar(
        leading: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          color: kButtonBackgroundColor.withOpacity(0.1),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            "assets/icons/Back ICon.svg",
            height: 15,
          ),
        ),
        title: '${LocaleKeys.checkout.tr()} (${_getCartItemCounts()} items)',
        action: [],
      ),
    );
  }

  get _getDeliveryAndProfile {
    return BlocConsumer<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // Getting Profile page information
          if (state is ProfileLoadInProgress) {
            return ProfileLoadingPage();
          }
          if (state is ProfileLoadSuccess) {
            //print('Profile loading success.....');

            // Get profile information
            profile = User(
              customerName: state.profile.customerName,
              email: state.profile.email,
              deliveryLocation: state.profile.deliveryLocation,
              phoneVerified: state.profile.phoneVerified,
              fcmToken: state.profile.fcmToken,
              deliAreasId: state.profile.deliAreasId,
              phone: state.profile.phone,
            );
            EasyLoading.dismiss();

            _requestCartList();

            return _profileInfo(profile);
          }

          // Updating Profile information
          if (state is UpdateProfileInformationLoadInProgress) {
            EasyLoading.show(status: LocaleKeys.loading.tr());
          }
          if (state is UpdateProfileInformationLoadSuccess) {
            if (state.updatedProfile['success']) {
              //EasyLoading.showSuccess(state.updatedProfile['message']);
              EasyLoading.showSuccess(LocaleKeys.updated_profile.tr());
            }
            // Get Profile information after updating
            BlocProvider.of<ProfileBloc>(context).add(
              ProfileRequested(token: widget.token!, isFirstTime: true),
            );
          }
          if (state is UpdateProfileInformationLoadFailure) {
            // Get Profile information after updating
            BlocProvider.of<ProfileBloc>(context).add(
              ProfileRequested(token: widget.token!, isFirstTime: true),
            );
          }

          // Updating Profile password
          if (state is UpdateProfilePasswordLoadInProgress) {
            EasyLoading.show(status: LocaleKeys.loading.tr());
          }
          if (state is UpdateProfilePasswordLoadSuccess) {
            if (state.updatedMessage['success']) {
              //EasyLoading.showSuccess(state.updatedMessage['message']);
              EasyLoading.showSuccess(LocaleKeys.updated_profile.tr());
            }
            // Get Profile information after updating
            BlocProvider.of<ProfileBloc>(context).add(
              ProfileRequested(token: widget.token!, isFirstTime: true),
            );
          }
          if (state is UpdateProfilePasswordLoadFailure) {
            // Get Profile information after updating
            BlocProvider.of<ProfileBloc>(context).add(
              ProfileRequested(token: widget.token!, isFirstTime: true),
            );
          }

          // Updating Profile phone

          return Container();
        },
        listener: (context, state) {});
  }

  _profileInfo(User profileData) {
    return Container(
      child: Column(
        children: [
          DeliveryLocation(
              token: widget.token!,
              customerName: profileData.customerName,
              // ignore: unnecessary_null_comparison
              deliveryLocation: profileData.deliveryLocation != null
                  ? profileData.deliveryLocation
                  : '',
              deliAreasId: profileData.deliAreasId,
              email: profileData.email),
          SizedBox(
            height: 20,
          ),
          PersonalProfile(
            token: widget.token!,
            customerName: profileData.customerName,
            deliveryLocation: profileData.deliveryLocation,
            deliAreasId: profileData.deliAreasId,
            email: profileData.email,
            isVerified: profileData.phoneVerified,
            phone: profileData.phone.toString(),
            loginType: 'facebook',
          ),
        ],
      ),
    );
  }

  get _getCartItems {
    return BlocConsumer<CartsBloc, CartsState>(builder: (context, state) {
      if (state is CartsInitialState) {
        //return CartListLoading();
        return Container();
      }
      if (state is VoucherVerifyLoadSuccess) {
        EasyLoading.showSuccess(state.data['message']);
        cartList = List<FoodCart>.from(state.data['cart']['cart_item']
            .map((i) => FoodCart.fromCartList(i))).toList();

        lists = state.data['cart'];

        return _getCartsItems(cartList, lists);
      }

      if (state is CartLoadingSuccessState) {
        if (state.carts['cart_item'] != null) {
          cartList = List<FoodCart>.from(
                  state.carts['cart_item'].map((i) => FoodCart.fromCartList(i)))
              .toList();

          lists = state.carts;

          return _getCartsItems(cartList, lists);
        }
      }
      return Container();
    }, listener: (context, state) {
      if (state is CreateCheckoutLoadSuccess) {
        print('checkout success ${state.data}');
        _gotoOrderSuccessPage(LocaleKeys.order_was_successfully_placed.tr(),
            state.data['sale_order_id']);
      }
      if (state is CreateCheckoutLoadFailure) {
        String message = state.message.toString().replaceAll('Exception: ', '');
        print('fail checkout $message');
        _requestCartList();
        //cmt open
        if (message.contains('You need to verify your phone number')) {
          showAlertDialog(context, message);
        } else if (message ==
            'The grand total price has been changed due to other customer ordered some discount items.') {
          showErrorMessage(LocaleKeys.change_grand_total.tr());
        }
      }
    });
  }

  _getCartsItems(List<FoodCart> cartList, Map lists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: CartList(
            cartList: cartList,
            isRemove: true,
            token: widget.token!,
            logo: widget.logo,
          ),
        ),
        DottedLine(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0.0),
          child: Column(
            children: [
              lists['discount_amount'] != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.discount_amount.tr(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          getCurrencyFormat('K', lists['discount_amount']),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.sub_total.tr(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 10),
                  //changed int to decimal from model
                  Text(
                    getCurrencyDoubleFormat('K', lists['sub_total']),
                    // '${NumberFormat.decimalPattern().format(calculateSubtotalAmount(cartList))}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.tax_amount.tr(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    getCurrencyFormat('K', lists['tax_amount']),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              lists['delivery_fee'] != 0 && lists['delivery_fee'] != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.delivery_fee.tr(),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            getCurrencyFormat('K', lists['delivery_fee']),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      HeroIcon(
                        HeroIcons.truck,
                        color: Colors.black,
                        solid: true,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      _deliveryFormat(),
                    ],
                  ),
                  Text(
                    LocaleKeys.grand_total.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      getCurrencyDoubleFormat('K', lists['grand_total']),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  get _getProceedCheckOut {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        height: 45,
        width: size.width,
        child: MaterialButton(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () => _createCheckOut(),
          child: Text(
            LocaleKeys.proceed_to_checkout.tr(),
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  get _getDeliveryNote {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0, bottom: 10.0),
          child: Text(
            LocaleKeys.special_instructions.tr(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        ///TODO
        TextFormField(
          cursorColor: kPrimaryColor,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Delivery Note',
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          controller: _noteInputController,
        ),
      ],
    );
  }

  get _getBankReceipt {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0, bottom: 10.0, top: 10.0),
          child: Text(
            LocaleKeys.bank_receipt.tr(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () => _onImageButtonPressed(ImageSource.gallery),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: _handlePreview(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _createCheckOut() {
    if (_deliveryDate == '') {
      EasyLoading.showError(LocaleKeys.please_select_the_order_date.tr(),
          duration: Duration(seconds: 3));
    } else if (_deliveryTime == '') {
      EasyLoading.showError(LocaleKeys.please_select_the_order_date.tr(),
          duration: Duration(seconds: 3));
    } else if (_paymentTypeId == 0) {
      EasyLoading.showError(LocaleKeys.please_select_payment_method.tr(),
          duration: Duration(seconds: 3));
    } else if (_bankReceiptFile == null && _paymentType != 'Cash on delivery') {
      EasyLoading.showError(LocaleKeys.need_bank_transfer_receipt.tr(),
          duration: Duration(seconds: 3));
    } else {
      _cartsBloc
        ..add(CreateCheckoutRequsted(
            token: widget.token!,
            voucher: _voucherCode,
            preferredDate: _deliveryDate,
            preferredTime: _deliveryTime,
            deliveryNote: _noteInputController.text,
            paymentType: _paymentTypeId,
            receiptEvidenceFile:
                _bankReceiptFile != null ? _bankReceiptFile!.path : '',
            grandTotal: double.parse(lists['grand_total'].toString())));
    }
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: kPrimaryColor),
      ),
      onPressed: () => _closePopup(),
    );
    Widget continueButton = TextButton(
      child: Text(
        LocaleKeys.verify.tr(),
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _verifyPhoneNumber(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sorry!"),
      content: Text(LocaleKeys.need_verify_phone.tr()),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _closePopup() {
    Navigator.pop(context);
  }

  _verifyPhoneNumber() {
    _closePopup();
    Navigator.pushNamed(context, '/change_phone_number',
        arguments: {'token': widget.token, 'type': 'verify'});
  }

  void _gotoOrderSuccessPage(String message, int orderId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SuccessScreen(
                deliveryDate: _deliveryDate,
                deliveryTime: _deliveryTime,
                message: message,
                saleOrderId: orderId,
                token: widget.token!,
              )),
    );
  }

  _getCartItemCounts() {
    int _dataCount = 0;
    for (int i = 0; i < widget.cartList!.length; i++) {
      _dataCount += widget.cartList![i].orderQuantity;
    }
    return _dataCount;
  }

  Widget _handlePreview() {
    if (_bankReceiptFile != null) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: Image.file(
          File(_bankReceiptFile!.path),
          fit: BoxFit.cover,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            border: Border.all(
              width: 2.0,
              color: Colors.red,
              style: BorderStyle.none,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Center(
            child: SizedBox(
                width: 50,
                height: 50,
                child: HeroIcon(
                  HeroIcons.upload,
                  size: 14,
                )),
          ));
    }
  }

  _deliveryFormat() {
    if (lists['est_deli_time'] > 24) {
      return Text(
        '${lists['est_deli_time'] / 24}' + ' $deliveryDayText',
        style: TextStyle(
          fontSize: 12,
        ),
      );
    } else if (lists['est_deli_time'] > 365) {
      return Text(
        '${lists['est_deli_time'] / 365}' + ' $deliveryYearText',
        style: TextStyle(
          fontSize: 12,
        ),
      );
    } else {
      return Text('${lists['est_deli_time'].toString()}' + '$deliveryTimeText');
    }
  }
}
