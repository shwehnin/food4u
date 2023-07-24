import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/blocs/my_order/my_order_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/hex_color.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bestcannedfood_ecommerce/model/my_order.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/order_detail_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/tracking/tracking_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/color_dot.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/large_image_view.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  final String? token;
  const OrderDetailScreen({Key? key, this.token}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  //String _url = baseUrl + 'refund-receipt.pdf';
  String _url = '';
  late int _orderID = 0;
  late MyOrdersBloc _myOrdersBloc;

  late MyOrder _myOrder;
  late int qty = 0;
  String _addOnName = '';
  int _addOnValue = 0;
  String _token = '';
  String _route = '';

  @override
  void didChangeDependencies() {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      List<String> data =
          ModalRoute.of(context)!.settings.arguments as List<String>;
      setState(() {
        _orderID = int.parse(data[0].toString());
        qty = int.parse(data[1].toString());
        _token = data[2].toString();
        _route = data[3].toString();
      });
    }
    _myOrdersBloc = BlocProvider.of<MyOrdersBloc>(context);
    _myOrdersBloc.add(
      OrderDetailRequested(token: _token, id: _orderID, isFirstTime: true),
    );
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backPressed(),
      child: BlocConsumer<MyOrdersBloc, MyOrdersState>(
          builder: (context, state) {
            if (state is OrderDetailLoadInProgress) {
              return OrderDetailLoadingPage();
            }
            if (state is OrderDetailLoadSuccess) {
              _myOrder = MyOrder(
                  id: state.myOrder.id,
                  status: state.myOrder.status,
                  salesOrderDate: state.myOrder.salesOrderDate,
                  preferredDate: state.myOrder.preferredDate,
                  preferredTime: state.myOrder.preferredTime,
                  deliveryNote: state.myOrder.deliveryNote,
                  customerName: state.myOrder.customerName,
                  deliveryLocation: state.myOrder.deliveryLocation,
                  taxAmount: state.myOrder.taxAmount,
                  discountAmount: state.myOrder.discountAmount,
                  salesCustId: state.myOrder.salesCustId,
                  salesOrderAutoinc: state.myOrder.salesOrderAutoinc,
                  grandTotal: state.myOrder.grandTotal,
                  deliveryFee: state.myOrder.deliveryFee,
                  subTotal: state.myOrder.subTotal,
                  canceledMsg: state.myOrder.canceledMsg,
                  township: state.myOrder.township,
                  myanmarRegion: state.myOrder.myanmarRegion,
                  cancelEvidenceFile: state.myOrder.cancelEvidenceFile,
                  customer: state.myOrder.customer,
                  payment: state.myOrder.payment,
                  salesDetail: state.myOrder.salesDetail,
                  statusTimeLine: state.myOrder.statusTimeLine,
                  receiptEvidenceFile: state.myOrder.receiptEvidenceFile);

              return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _getAppBar,
                          _sizedBox10,
                          _myordersHeader,
                          SizedBox(height: 20),
                          _salesDetailList,
                          _sizedBox5,
                          _calculatedAmounts,
                          _sizedBox30,
                          _preferredTime,
                          _sizedBox30,
                          _specialInstruction,
                          _sizedBox30,
                          _deliveryLocation,
                          _sizedBox30,
                          _getReceiptEvidenceFile,
                          _sizedBox30,
                          _canceledMsg,
                          // ignore: unnecessary_null_comparison
                          state.myOrder.cancelEvidenceFile != null
                              ? _downloadPdf
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
          listener: (context, state) {}),
    );
  }

  get _sizedBox5 {
    return SizedBox(
      height: 5,
    );
  }

  get _sizedBox10 {
    return SizedBox(
      height: 10,
    );
  }

  get _sizedBox30 {
    return SizedBox(
      height: 30,
    );
  }

  get _getAppBar {
    return CustomAppBar(
      leading: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        color: kButtonBackgroundColor.withOpacity(0.1),
        padding: EdgeInsets.zero,
        onPressed: () => _backPressed(),
        child: SvgPicture.asset(
          "assets/icons/Back ICon.svg",
          height: 15,
        ),
      ),
      title: '${LocaleKeys.my_orders.tr()} - ${_myOrder.salesOrderAutoinc}',
      action: [
        MaterialButton(
          minWidth: 40,
          height: 40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          color: kButtonBackgroundColor.withOpacity(0.1),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackingScreen(
                  trackingId: _myOrder.salesOrderAutoinc,
                  deliveryDate: _myOrder.preferredDate,
                  deliveryTime: _myOrder.preferredTime,
                  trackingData: _myOrder.statusTimeLine,
                  isFromSuccess: false,
                ),
              ),
            );
          },
          child: HeroIcon(HeroIcons.truck, size: 18),
        ),
      ],
    );
  }

  get _myordersHeader {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(qty == 1 ? '$qty order' : '$qty orders'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${_myOrder.salesOrderAutoinc}',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            _myOrder.status != ''
                ? Container(
                    padding: EdgeInsets.all(
                      6.0,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        '${_myOrder.status}',
                        style: TextStyle(
                            fontSize: 14,
                            color: kPrimaryLightColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        Text(
          '${_myOrder.salesOrderDate}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _getAddOnNameAndValue() {
    // Get total AddOnName in each salesDetail list of myOrder
    for (int salesDetailIndex = 0;
        salesDetailIndex < _myOrder.salesDetail.length;
        salesDetailIndex++) {
      if (_myOrder.salesDetail[salesDetailIndex].addOnA != null &&
          _myOrder.salesDetail[salesDetailIndex].addOnAPrice != null) {
        // 1st salesDetail obj _addOnA
        _addOnName += _myOrder.salesDetail[salesDetailIndex].addOnA!;
        _addOnValue += _myOrder.salesDetail[salesDetailIndex].addOnAPrice!;
      }
      if (_myOrder.salesDetail[salesDetailIndex].addOnB != null &&
          _myOrder.salesDetail[salesDetailIndex].addOnBPrice != null) {
        // 1st salesDetail obj _addOnB
        _addOnName += ',' + _myOrder.salesDetail[salesDetailIndex].addOnB!;
        _addOnValue += _myOrder.salesDetail[salesDetailIndex].addOnBPrice!;
      }
      if (_myOrder.salesDetail[salesDetailIndex].addOnC != null &&
          _myOrder.salesDetail[salesDetailIndex].addOnCPrice != null) {
        // 1st salesDetail obj _addOnB
        _addOnName += ',' + _myOrder.salesDetail[salesDetailIndex].addOnC!;
        _addOnValue += _myOrder.salesDetail[salesDetailIndex].addOnCPrice!;
      }
    }
  }

  get _salesDetailList {
    _getAddOnNameAndValue();
    return Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: CachedNetworkImageProvider(
                            _myOrder.salesDetail[index].imageA.toString()),
                      ),
                      _sizedBox10,
                      Text(
                        'x ${_myOrder.salesDetail[index].orderQty} qty',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _myOrder.salesDetail[index].foodName != null
                            ? _getItemName(_myOrder.salesDetail[index].foodName,
                                _myOrder.salesDetail[index])
                            : Container(),
                        (_myOrder.salesDetail[index].sizes != null) ||
                                (_myOrder.salesDetail[index].spicyLevels !=
                                    null)
                            ? RichText(
                                text: TextSpan(
                                  text: _myOrder.salesDetail[index].sizes !=
                                          null
                                      ? 'Service: ${_myOrder.salesDetail[index].sizes} \t\t'
                                      : '',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: _myOrder.salesDetail[index]
                                                  .spicyLevels !=
                                              null
                                          ? 'Spicy: ${_myOrder.salesDetail[index].spicyLevels}'
                                          : '',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                        (_myOrder.salesDetail[index].sizes != null) ||
                                (_myOrder.salesDetail[index].spicyLevels !=
                                    null)
                            ? SizedBox(
                                height: 5,
                              )
                            : SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _myOrder.salesDetail[index].choiceOfA != null
                                ? Text(
                                    '${_myOrder.salesDetail[index].choiceOfA}')
                                : _myOrder.salesDetail[index].choiceOfB != null
                                    ? Text(
                                        '${_myOrder.salesDetail[index].choiceOfB}')
                                    : _myOrder.salesDetail[index].choiceOfC !=
                                            null
                                        ? Text(
                                            '${_myOrder.salesDetail[index].choiceOfC}')
                                        : SizedBox.shrink(),
                            _myOrder.salesDetail[index].choiceOfAPrice != 0
                                ? Text(
                                    'K ${_myOrder.salesDetail[index].choiceOfAPrice}')
                                : _myOrder.salesDetail[index].choiceOfBPrice !=
                                        0
                                    ? Text(
                                        'K ${_myOrder.salesDetail[index].choiceOfBPrice}')
                                    : _myOrder.salesDetail[index]
                                                .choiceOfCPrice !=
                                            0
                                        ? Text(
                                            'K ${_myOrder.salesDetail[index].choiceOfCPrice}')
                                        : SizedBox.shrink(),
                          ],
                        ),
                        (_myOrder.salesDetail[index].choiceOfAPrice != null) ||
                                (_myOrder.salesDetail[index].choiceOfBPrice !=
                                    null) ||
                                (_myOrder.salesDetail[index].choiceOfCPrice !=
                                    null)
                            ? SizedBox(
                                height: 7,
                              )
                            : SizedBox.shrink(),
                        _myOrder.salesDetail[index].addOnA != null ||
                                _myOrder.salesDetail[index].addOnB != null ||
                                _myOrder.salesDetail[index].addOnC != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      _addOnName,
                                      maxLines: 3,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text('K $_addOnValue'),
                                ],
                              )
                            : SizedBox.shrink(),
                        (_myOrder.salesDetail[index].choiceOfAPrice != null) ||
                                (_myOrder.salesDetail[index].choiceOfBPrice !=
                                    null) ||
                                (_myOrder.salesDetail[index].choiceOfCPrice !=
                                    null)
                            ? SizedBox(
                                height: 7,
                              )
                            : SizedBox.shrink(),
                        _myOrder.salesDetail[index].discountAmount != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(LocaleKeys.discount.tr()),
                                  Text(
                                      '-K ${_myOrder.salesDetail[index].discountAmount}'),
                                ],
                              )
                            : Container(),
                        _myOrder.salesDetail[index].discountAmount != 0
                            ? SizedBox(
                                height: 7,
                              )
                            : Container(),
                        _myOrder.salesDetail[index].packageFee != 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Package'),
                                  Text(
                                      'K ${_myOrder.salesDetail[index].packageFee}')
                                ],
                              )
                            : Container(),
                        _myOrder.salesDetail[index].packageFee != 0
                            ? SizedBox(
                                height: 7,
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(LocaleKeys.unit_price.tr()),
                            Text(getCurrencyFormat(
                                'K', _myOrder.salesDetail[index].unitPrice!)),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.total.tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              getCurrencyDoubleFormat(
                                  'K', _myOrder.salesDetail[index].subTotal!),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _sizedBox5,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DottedLine(),
              ),
            ],
          );
        },
        itemCount: _myOrder.salesDetail.length,
      ),
    );
  }

  get _calculatedAmounts {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                LocaleKeys.payment_type.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Text(
              _myOrder.payment.paymentType != 'Cash on delivery'
                  ? '${_myOrder.payment.bankName} - Bank Transfer'
                  : _myOrder.payment.paymentType!,
            ),
          ],
        ),
        _sizedBox10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                LocaleKeys.discount_amount.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Text(
              getCurrencyFormat('K', _myOrder.discountAmount),
            ),
          ],
        ),
        _sizedBox10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                LocaleKeys.sub_total.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Text(
              getCurrencyFormat('K', _myOrder.subTotal),
            ),
          ],
        ),
        _sizedBox10,
        _myOrder.deliveryFee != 0
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6.0),
                      child: Text(
                        LocaleKeys.delivery_fee.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Text(
                      getCurrencyFormat('K', _myOrder.deliveryFee),
                    ),
                  ],
                ),
              )
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                LocaleKeys.tax_amount.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Text(getCurrencyFormat('K', _myOrder.taxAmount)),
          ],
        ),
        _sizedBox10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                LocaleKeys.grand_total.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Text(
              getCurrencyFormat('K', _myOrder.grandTotal),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }

  get _preferredTime {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${LocaleKeys.preferred_time.tr()}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        _sizedBox10,
        Text(
          _getDeliveryDateTime(),
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
      ],
    );
  }

  get _specialInstruction {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.special_instructions.tr(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        _sizedBox10,
        Text(
          // ignore: unnecessary_null_comparison
          '${_myOrder.deliveryNote != null ? _myOrder.deliveryNote : '-'}',
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
      ],
    );
  }

  get _deliveryLocation {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.delivery_location.tr(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        _sizedBox10,
        Text(
          '${_myOrder.deliveryLocation}',
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
      ],
    );
  }

  get _canceledMsg {
    // ignore: unnecessary_null_comparison
    return _myOrder.canceledMsg != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.reason_for_cancel.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              _sizedBox10,
              Text(
                '${_myOrder.canceledMsg}',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ],
          )
        : SizedBox.shrink();
  }

  get _downloadPdf {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              color: Colors.grey,
              padding: EdgeInsets.only(right: 20),
              onPressed: () {},
              icon: HeroIcon(HeroIcons.receiptRefund),
            ),
            Text('refund-receipt.pdf')
          ],
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: kPrimaryColor,
          ),
          onPressed: _launchURL,
          child: Text(LocaleKeys.download.tr()),
        )
      ],
    );
  }

  void _launchURL() async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  String _getDeliveryDateTime() {
    DateTime dateData = DateTime.parse(_myOrder.preferredDate.toString());
    String _day = DateFormat('E').format(dateData);
    String _dayType = dateData.day.toString();
    String data = '';

    for (int i = 0; i < timeDataList.length; i++) {
      if (_myOrder.preferredTime.toString() == timeDataList[i]) {
        data = '$_day, $_dayType ${timeNameList[i]}';
      }
    }
    return data;
  }

  _getItemName(String? foodName, FoodMaster salesDetail) {
    if (foodName.toString().contains('#')) {
      var item = foodName!.split('.');
      String itemColor = item[1].replaceAll(' ', '');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.pushReplacementNamed(
                context, '/product_detail',
                arguments: salesDetail),
            child: Text(
              item[0],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          for (int i = 1; i < item.length; i++)
            item[i].contains('#')
                ? Row(
                    children: [
                      Text('${LocaleKeys.color.tr()}:'),
                      SizedBox(
                        width: 5,
                      ),
                      ColorDot(color: HexColor(itemColor))
                    ],
                  )
                : Text(
                    item[2].replaceFirst(' ', ''),
                  ),
        ],
      );
    } else {
      return InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, '/product_detail',
            arguments: salesDetail),
        child: Text(
          foodName!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  _backPressed() {
    if (_route == 'profile') {
      Navigator.pop(context);

      _myOrdersBloc.add(MyOrdersListRequested(
          token: _token,
          status: '',
          duration: 'last15days',
          order: '',
          page: 1,
          paginate: 20,
          sort: '',
          isFirstTime: true));
    } else if (_route == 'notification') {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/my_order', arguments: _token);
    }
  }

  Widget get _getReceiptEvidenceFile {
    return _myOrder.receiptEvidenceFile != ''
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.bank_receipt.tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              _sizedBox10,
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LargeImageView(
                          image: _myOrder.receiptEvidenceFile,
                          imageList: [_myOrder.receiptEvidenceFile]),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 300,
                  child: Image.network(_myOrder.receiptEvidenceFile),
                ),
              )
            ],
          )
        : Container();
  }
}
