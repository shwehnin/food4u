import 'package:bestcannedfood_ecommerce/blocs/my_order/my_order_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/my_order.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/loadmore_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/not_order.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class OrderTabs extends StatefulWidget {
  List<MyOrder> myOrderList;
  String tabName;
  int paginate;
  int page;
  String status;
  String duration;
  String token;
  String? route;

  OrderTabs({
    Key? key,
    required this.myOrderList,
    required this.tabName,
    required this.paginate,
    required this.page,
    required this.status,
    required this.duration,
    required this.token,
    this.route,
  }) : super(key: key);

  @override
  _OrderTabsState createState() => _OrderTabsState();
}

class _OrderTabsState extends State<OrderTabs> {
  List<int> _orderQty = [];
  List<MyOrder> _myOrderList = [];

  @override
  Widget build(BuildContext context) {
    // When Active My Orders are existed
    if (widget.myOrderList.length != 0) {
      switch (widget.tabName) {
        case 'all':
          _orderQty = [];
          for (int i = 0; i < widget.myOrderList.length; i++) {
            _getOrderQty(i);
          }
          break;
        case 'active':
          _orderQty = [];
          for (int i = 0; i < widget.myOrderList.length; i++) {
            // Check Active status
            if (widget.myOrderList[i].status.compareTo('Order Received') == 0 ||
                widget.myOrderList[i].status.compareTo('Order Prepared') == 0 ||
                widget.myOrderList[i].status.compareTo('Order Picked up') ==
                    0) {
              _getOrderQty(i);
            }
          }
          break;
        case 'completed':
          _orderQty = [];
          for (int i = 0; i < widget.myOrderList.length; i++) {
            // Check Completed status
            if (widget.myOrderList[i].status.compareTo('Order Delivered') ==
                0) {
              _getOrderQty(i);
            }
          }
          break;
        case 'canceled':
          _orderQty = [];
          for (int i = 0; i < widget.myOrderList.length; i++) {
            // Check Canceled status
            if (widget.myOrderList[i].status.compareTo('Order Canceled') == 0) {
              _getOrderQty(i);
            }
          }
          break;
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            LoadMore(
              textBuilder: (status) {
                if (status == LoadMoreStatus.nomore && widget.page != 1) {
                  showErrorMessage('No records found.');
                  return "";
                }
                return DefaultLoadMoreTextBuilder.english(status);
              },
              isFinish: (_myOrderList.length % widget.paginate) != 0 ||
                  _myOrderList.length == 0,
              onLoadMore: _loadMore,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  //print('index $_myOrderList $index ${_orderQty[index]}');
                  return _getList(_myOrderList[index], _orderQty[index]);
                },
                itemCount: _myOrderList.length,
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [NotOrderScreen(message: 'No order yet!')],
      ),
    );
  }

  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      widget.page++;
    });
    MyOrdersBloc _myOrdersBloc = BlocProvider.of<MyOrdersBloc>(context);
    _myOrdersBloc.add(
      MyOrdersListRequested(
          token: widget.token,
          status: widget.status,
          duration: widget.duration,
          order: '',
          page: widget.page,
          paginate: widget.paginate,
          sort: '',
          isFirstTime: false),
    );
    return true;
  }

  _getOrderQty(int index) {
    if (!_myOrderList.contains(widget.myOrderList[index])) {
      _myOrderList.add(widget.myOrderList[index]);
    }

    // Get total orderQty in each salesDetail list of myOrderList
    for (int salesDetailIndex = 0;
        salesDetailIndex < widget.myOrderList[index].salesDetail.length;
        salesDetailIndex++) {
      if (salesDetailIndex == 0 &&
          widget.myOrderList[index].salesDetail[salesDetailIndex].orderQty !=
              null) {
        // 1st salesDetail obj orderQty
        _orderQty.add(
            widget.myOrderList[index].salesDetail[salesDetailIndex].orderQty!);
      } else {
        // Add current salesDetail obj's orderQty into last salesDetail obj's orderQty
        _orderQty.insert(
            _orderQty.length - 1,
            _orderQty.last +
                widget.myOrderList[index].salesDetail[salesDetailIndex]
                    .orderQty!);
        _orderQty.removeLast();
      }
    }
  }

  Widget _getList(MyOrder myOrder, int qty) {
    List<String> arg = [
      myOrder.id.toString(),
      qty.toString(),
      widget.token,
      widget.route != null ? widget.route! : 'order'
    ];
    return InkWell(
      onTap: () {
        if (widget.route != null) {
          Navigator.pushNamed(context, '/order_detail', arguments: arg);
        } else {
          Navigator.pushReplacementNamed(context, '/order_detail',
              arguments: arg);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: myOrder.salesOrderAutoinc,
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
                myOrder.status != ''
                    ? Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                          ),
                          color: kPrimaryColor,
                        ),
                        child: Text(
                          myOrder.status,
                          style: TextStyle(
                            fontSize: 14,
                            color: kPrimaryLightColor,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Text(
              myOrder.salesOrderDate,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$qty items, ${LocaleKeys.grand_total.tr()}: ',
              ),
              Text(
                getCurrencyFormat('K', myOrder.grandTotal),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
