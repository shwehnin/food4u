import 'package:bestcannedfood_ecommerce/blocs/my_order/my_order_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/tracking/tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen(
      {Key? key,
      required this.deliveryDate,
      required this.deliveryTime,
      required this.message,
      required this.saleOrderId,
      required this.token})
      : super(key: key);

  final String deliveryDate;
  final String deliveryTime;
  final String message;
  final int saleOrderId;
  final String token;

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late MyOrdersBloc _myOrdersBloc;
  late MyOrder _myOrder;
  @override
  void initState() {
    super.initState();
    _myOrdersBloc = BlocProvider.of<MyOrdersBloc>(context);
    _myOrdersBloc.add(
      OrderDetailRequested(
          token: widget.token, id: widget.saleOrderId, isFirstTime: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDeliveryDateTime(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Estimate Time Delivery',
                    style: TextStyle(fontSize: 20),
                  ),
                  Center(
                    child: Lottie.asset('assets/icons/received.json',
                        repeat: false),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.message,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Thank you for the order. Your order will be prepared and shipped by courier within delivery time.',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            BlocConsumer<MyOrdersBloc, MyOrdersState>(
                builder: (context, state) {
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

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MaterialButton(
                        minWidth: size.width,
                        height: 45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackingScreen(
                                  trackingId: _myOrder.salesOrderAutoinc,
                                  deliveryDate: _myOrder.preferredDate,
                                  deliveryTime: _myOrder.preferredTime,
                                  trackingData: _myOrder.statusTimeLine,
                                  isFromSuccess: true),
                            ),
                          );
                        },
                        color: kBlackColor,
                        child: Text(
                          'Track your order',
                          style: TextStyle(
                              color: kPrimaryLightColor, fontSize: 16),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
                listener: (context, state) {}),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getDeliveryDateTime() {
    DateTime dateData = DateTime.parse(widget.deliveryDate.toString());
    String _day = DateFormat('E').format(dateData);
    String _dayType = dateData.day.toString();
    String data = '';

    List<String> timeNameList = [
      'Morning (9:00 AM - 1:00 PM)',
      'Evening (2:00 PM - 5:00 PM)'
    ];
    List<String> timeDataList = ['09:00:00', '14:00:00'];
    for (int i = 0; i < timeDataList.length; i++) {
      if (widget.deliveryTime.toString() == timeDataList[i]) {
        data = '$_day, $_dayType ${timeNameList[i]}';
      }
    }
    return data;
  }
}
