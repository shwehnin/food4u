import 'package:bestcannedfood_ecommerce/blocs/voucher/voucher_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/model/promotion_discount.dart';
import 'package:bestcannedfood_ecommerce/model/voucher.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/voucher_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/coupon/voucher_card.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/loadmore_widget.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class VoucherScreen extends StatefulWidget {
  VoucherScreen({Key? key}) : super(key: key);

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  String _token = '';

  late VoucherBloc _voucherBloc;
  List<Voucher> voucherList = [];
  int page = 1;
  int totalCount = 0;
  int paginate = 10;
  int countForDummyUse = 1;

  @override
  void dispose() {
    voucherList.clear();
    super.dispose();
  }

  Map<dynamic, dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (context, isConnected, status) {
        if (isConnected.toString() != 'false') {
          return _getVoucherSection;
        } else {
          return NoInternetWidget();
        }
      },
    );
  }

  get _getVoucherSection {
    return BlocConsumer<VoucherBloc, VoucherState>(
        builder: (context, state) {
          if (state is VoucherListLoadInProgress) {
            return VoucherLoadingPage();
          }
          if (state is VoucherListLoadSuccess) {
            data = state.voucherList;

            if (data['data'].length != 0) {
              if (voucherList.length != 0 && page > 1) {
                if (page == countForDummyUse ||
                    countForDummyUse == (page + (page - 1))) {
                  List<Voucher> temp = [
                    Voucher(
                        id: 1,
                        startDate: '2021-10-11',
                        endDate: '2021-11-10',
                        voucher: '#aaaa',
                        oneTimeFlg: 1,
                        discountAmount: 1000,
                        promotionDiscount: PromotionDiscount(
                            strategy: '10% Off',
                            foodMaster: FoodMaster(foodName: 'Test')))
                  ];

                  for (int i = 0; i < temp.length; i++) {
                    if (!voucherList.contains(temp[i])) {
                      voucherList.add(temp[i]);
                    }
                  }
                }
              } else if (page == 1 && page == countForDummyUse) {
                voucherList = List<Voucher>.from(
                        data['data'].map((i) => Voucher.fromVoucherList(i)))
                    .toList();
              }

              countForDummyUse += 1;

              return Scaffold(
                backgroundColor: kPrimaryLightColor,
                body: SafeArea(
                  bottom: false,
                  child: Container(
                    child: LoadMore(
                      textBuilder: (status) {
                        if (status == LoadMoreStatus.nomore && page != 1) {
                          showErrorMessage('No records found.');
                          return "";
                        }
                        return DefaultLoadMoreTextBuilder.english(status);
                      },
                      isFinish: (voucherList.length % paginate) != 0,
                      onLoadMore: _loadMore,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  child: CustomAppBar(
                                    leading: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      color: kButtonBackgroundColor
                                          .withOpacity(0.1),
                                      padding: EdgeInsets.zero,
                                      onPressed: () => Navigator.pop(context),
                                      child: SvgPicture.asset(
                                        "assets/icons/Back ICon.svg",
                                        height: 15,
                                      ),
                                    ),
                                    title: LocaleKeys.vouchers.tr(),
                                    action: [],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 5, right: 5),
                              child: VoucherCard(
                                id: voucherList[index - 1].id,
                                startDate: voucherList[index - 1].startDate,
                                endDate: voucherList[index - 1].endDate,
                                voucher: voucherList[index - 1].voucher,
                                oneTimeFlg: voucherList[index - 1].oneTimeFlg,
                                discountAmount:
                                    voucherList[index - 1].discountAmount,
                                promotionDiscount:
                                    voucherList[index - 1].promotionDiscount,
                              ),
                            );
                          }
                        },
                        itemCount: voucherList.length + 1,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              // When no data from API response
              return Scaffold(
                backgroundColor: kPrimaryLightColor,
                body: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 35.0),
                        child: CustomAppBar(
                          leading: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            color: kButtonBackgroundColor.withOpacity(0.1),
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.pop(context),
                            child: SvgPicture.asset(
                              "assets/icons/Back ICon.svg",
                              height: 15,
                            ),
                          ),
                          title: LocaleKeys.vouchers.tr(),
                          action: [],
                        ),
                      ),
                      Lottie.asset(
                        'assets/icons/novoucher.json',
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Text(
                        LocaleKeys.no_vouchers_yet.tr(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return Container();
        },
        listener: (context, state) {});
  }

  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      page++;
    });
    _voucherBloc.add(
      VoucherListRequested(
        token: _token,
        keyword: '',
        order: '',
        page: page,
        paginate: paginate,
        sort: '',
        isFirstTime: false,
      ),
    );
    return true;
  }

  @override
  void didChangeDependencies() {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      String data = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        _token = data;
      });
      _voucherBloc = BlocProvider.of<VoucherBloc>(context);
      // Call API request to get Voucher list
      _voucherBloc.add(
        VoucherListRequested(
            token: _token,
            keyword: '',
            order: '',
            page: page,
            paginate: paginate,
            sort: '',
            isFirstTime: true),
      );
    }
    super.didChangeDependencies();
  }
}
