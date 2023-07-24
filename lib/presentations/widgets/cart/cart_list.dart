import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/blocs/carts/carts_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/hex_color.dart';
import 'package:bestcannedfood_ecommerce/model/cart.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/color_dot.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';

class CartList extends StatefulWidget {
  CartList(
      {Key? key,
      required this.cartList,
      required this.isRemove,
      required this.token,
      this.logo})
      : super(key: key);

  final List<FoodCart> cartList;
  final bool isRemove;
  final String token;
  String? logo;

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  List<FoodCart> cartList = [];

  @override
  void initState() {
    super.initState();
    cartList = widget.cartList;
  }

  @override
  Widget build(BuildContext context) {
    return _cartList();
  }

  Widget _cartList() {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: DottedLine(),
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cartList.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              color: !cartList[index].isChanged!
                  ? kPrimaryLightColor
                  : kBlackColor.withOpacity(0.9),
              child: Padding(
                  padding:
                      const EdgeInsets.only(right: 10, bottom: 15, top: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Opacity(
                                opacity: !cartList[index].isChanged! ? 1 : 0.1,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage: CachedNetworkImageProvider(
                                      cartList[index].foodMasterCart!.imageA !=
                                              null
                                          ? cartList[index]
                                              .foodMasterCart!
                                              .imageA!
                                          : kLogoImageUrl),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            !widget.isRemove
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove,
                                            color: kBlackColor),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                        iconSize: 18.0,
                                        color: kPrimaryColor,
                                        onPressed: () {
                                          if (cartList[index].orderQuantity >
                                              1) {
                                            cartList[index].orderQuantity =
                                                cartList[index].orderQuantity -
                                                    1;

                                            BlocProvider.of<CartsBloc>(context)
                                                .add(CartUpdateRequested(
                                                    token: widget.token,
                                                    cartItemId: int.parse(
                                                        cartList[index]
                                                            .id
                                                            .toString()),
                                                    orderQty: cartList[index]
                                                        .orderQuantity));
                                          }
                                        },
                                      ),
                                      !cartList[index].isChanged!
                                          ? _getText(index)
                                          : Container(),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: kBlackColor,
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                        iconSize: 18.0,
                                        color: kBlackColor,
                                        onPressed: () {
                                          cartList[index].orderQuantity =
                                              cartList[index].orderQuantity + 1;
                                          BlocProvider.of<CartsBloc>(context)
                                              .add(CartUpdateRequested(
                                                  token: widget.token,
                                                  cartItemId: int.parse(
                                                      cartList[index]
                                                          .id
                                                          .toString()),
                                                  orderQty: cartList[index]
                                                      .orderQuantity));
                                        },
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cartList[index].unitConversion == ''
                                            ? 'x'
                                            : '',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      _getText(index)
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, '/product_detail',
                                      arguments:
                                          cartList[index].foodMasterCart),
                                  child: Container(
                                    width: 150,
                                    child: Text(
                                      '${cartList[index].foodMasterCart!.foodName} (${cartList[index].foodMasterCart!.itemCode})',
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                !widget.isRemove && !cartList[index].isChanged!
                                    ? IconButton(
                                        onPressed: () {
                                          BlocProvider.of<CartsBloc>(context)
                                            ..add(CartDeleteRequested(
                                              token: widget.token,
                                              cartItemId: int.parse(
                                                  cartList[index]
                                                      .id
                                                      .toString()),
                                            ));
                                        },
                                        icon: HeroIcon(
                                          HeroIcons.trash,
                                          size: 18,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                text: cartList[index].variants!.size != null
                                    ? 'Service: (${cartList[index].variants!.size}) \t\t'
                                    : '',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  cartList[index].variants!.spicyLevel != null
                                      ? TextSpan(
                                          text:
                                              'Other: (${cartList[index].variants!.spicyLevel})',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : TextSpan(),
                                ],
                              ),
                            ),
                            cartList[index].variants!.itemColor != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 5),
                                    child: Row(
                                      children: [
                                        Text('${LocaleKeys.color.tr()}:'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ColorDot(
                                            color: HexColor(cartList[index]
                                                .variants!
                                                .itemColor!))
                                      ],
                                    ),
                                  )
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.unit_conversion.tr()),
                                Text(
                                  cartList[index].unitConversion != ''
                                      ? cartList[index].unitConversion!
                                      : '${cartList[index].orderQuantity.toString()} qty',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.unit_price.tr()),
                                Text(
                                  getCurrencyFormat(
                                      'K',
                                      cartList[index]
                                          .foodMasterCart!
                                          .unitPrice!),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            (cartList[index].variants!.choiceofA == null)
                                ? Row()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${cartList[index].variants!.choiceofA}'),
                                      Text(getCurrencyFormat(
                                          'K',
                                          cartList[index]
                                              .variants!
                                              .choiceofAPrice!)),
                                    ],
                                  ),
                            cartList[index].variants!.choiceofB != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${cartList[index].variants!.choiceofB}'),
                                        Text(getCurrencyFormat(
                                            'K',
                                            cartList[index]
                                                .variants!
                                                .choiceofBPrice!)),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            cartList[index].variants!.choiceofC != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${cartList[index].variants!.choiceofC}'),
                                        Text(getCurrencyFormat(
                                            'K',
                                            cartList[index]
                                                .variants!
                                                .choiceofCPrice!)),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            cartList[index].variants!.choiceofD != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${cartList[index].variants!.choiceofD}'),
                                        Text(getCurrencyFormat(
                                            'K',
                                            cartList[index]
                                                .variants!
                                                .choiceofDPrice!)),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            cartList[index].variants!.choiceofAddA != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${cartList[index].variants!.choiceofAddA}'),
                                        Text(getCurrencyFormat(
                                            'K',
                                            cartList[index]
                                                .variants!
                                                .choiceofAddAPrice!)),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            cartList[index].variants!.choiceofAddB != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${cartList[index].variants!.choiceofAddB}'),
                                        Text(getCurrencyFormat(
                                            'K',
                                            cartList[index]
                                                .variants!
                                                .choiceofAddBPrice!)),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            cartList[index].variants!.choiceofAddC != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${cartList[index].variants!.choiceofAddC}'),
                                        Text(getCurrencyFormat(
                                            'K',
                                            cartList[index]
                                                .variants!
                                                .choiceofAddCPrice!))
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            /*
                            cartList[index].foodMasterCart!.packageFee != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Package fee'),
                                        Text(getCurrencyFormat(
                                            'K',
                                            cartList[index]
                                                .foodMasterCart!
                                                .packageFee!)),
                                      ],
                                    ),
                                  )
                                : Container(),
                              */
                            cartList[index].discountAmount != 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Text(
                                                LocaleKeys.discount.tr() +
                                                    ' - ' +
                                                    cartList[index]
                                                        .discounts![0]
                                                        .strategy!)),
                                        Text(getCurrencyDoubleFormat(
                                            '- K',
                                            double.parse(cartList[index]
                                                .discountAmount
                                                .toString())))
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.total.tr(),
                                ),
                                Text(
                                  getCurrencyDoubleFormat(
                                      'K',
                                      double.parse(
                                          cartList[index].total.toString())),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.sub_total.tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  getCurrencyDoubleFormat(
                                      'K',
                                      double.parse(
                                          cartList[index].subTotal.toString())),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            cartList[index].isChanged! ||
                    cartList[index].foodMasterCart!.status.toString() !=
                        'Available'
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            cartList[index].foodMasterCart!.status.toString() !=
                                    'Available'
                                ? cartList[index]
                                    .foodMasterCart!
                                    .status
                                    .toString()
                                : LocaleKeys.seller_changed_their_information
                                    .tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 40,
                                  height: 40,
                                  decoration: new BoxDecoration(
                                    color: Colors.transparent,
                                    border: new Border.all(
                                        color: Colors.white, width: 2.0),
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        BlocProvider.of<CartsBloc>(context)
                                          ..add(CartDeleteRequested(
                                            token: widget.token,
                                            cartItemId: int.parse(
                                                cartList[index].id.toString()),
                                          ));
                                      },
                                      icon: HeroIcon(
                                        HeroIcons.trash,
                                        color: kWhiteColor,
                                      ))),
                              SizedBox(
                                width: 10,
                              ),
                              cartList[index]
                                          .foodMasterCart!
                                          .status
                                          .toString() ==
                                      'Available'
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: new BoxDecoration(
                                        color: Colors.transparent,
                                        border: new Border.all(
                                            color: Colors.white, width: 2.0),
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      child: IconButton(
                                          onPressed: () =>
                                              Navigator.pushReplacementNamed(
                                                  context, '/product_detail',
                                                  arguments: cartList[index]
                                                      .foodMasterCart),
                                          icon: HeroIcon(
                                            HeroIcons.eye,
                                            color: kWhiteColor,
                                          )))
                                  : Container()
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Container()
          ],
        );
      },
    );
  }

  _getText(int index) {
    TextEditingController _controller = new TextEditingController();
    _controller.text = cartList[index].orderQuantity.toString();
    return Container(
      width: widget.isRemove ? 50 : 50,
      child: widget.isRemove
          ? Text(
              cartList[index].unitConversion == ''
                  ? '${cartList[index].orderQuantity.toString()} qty'
                  : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            )
          : TextField(
              cursorColor: kPrimaryColor,
              controller: _controller,
              onChanged: (value) {
                if (value == '' || int.parse(value) == 0) {
                  _controller.text = '1';
                  cartList[index].orderQuantity = int.parse(_controller.text);
                } else {
                  cartList[index].orderQuantity = int.parse(value);
                }

                _changeQtyValue(index);
              },
              keyboardType: TextInputType.numberWithOptions(signed: false),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
    );
  }

  void _changeQtyValue(int index) {
    BlocProvider.of<CartsBloc>(context).add(CartUpdateRequested(
        token: widget.token,
        cartItemId: int.parse(cartList[index].id.toString()),
        orderQty: cartList[index].orderQuantity));
  }
}
