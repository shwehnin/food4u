import 'package:bestcannedfood_ecommerce/blocs/carts/carts_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/config/shared_configs.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VoucherCode extends StatefulWidget {
  Function(String) onEnterValue;

  VoucherCode({Key? key, required this.token, required this.onEnterValue})
      : super(key: key);

  final String token;

  @override
  _VoucherCodeState createState() => _VoucherCodeState();
}

class _VoucherCodeState extends State<VoucherCode> {
  TextEditingController _controller = new TextEditingController();
  bool _enabled = false;
  late CartsBloc _voucherBloc;
  String _voucher = '';

  @override
  void initState() {
    super.initState();
    _voucherBloc = BlocProvider.of<CartsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LocaleKeys.voucher_code.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/coupon',
                  arguments: widget.token),
              child: Text(
                '(${LocaleKeys.get_voucher.tr()})',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width - 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade300)),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ThemeData().colorScheme.copyWith(
                        primary: kPrimaryColor,
                      ),
                ),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: LocaleKeys.your_voucher_code_is.tr(),
                  ),
                ),
              ),
            ),
            MaterialButton(
              minWidth: 100,
              height: 45,
              color: kPrimaryColor,
              onPressed: () => _applyVoucherCode(),
              child: Text(
                LocaleKeys.redeem.tr(),
                style: TextStyle(
                  color: kPrimaryLightColor,
                  fontSize: 20,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
        BlocConsumer<CartsBloc, CartsState>(
          builder: (context, state) {
            if (state is VoucherVerifyLoadSuccess) {
              _voucher = _controller.text.toString();
              _controller.text = '';
              widget.onEnterValue(_voucher);
              return Text('Voucher code - $_voucher is applied.');
            }
            return Container();
          },
          listener: (context, state) {},
        ),
        SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: LocaleKeys.by_making_this_purchase.tr()),
              TextSpan(
                text: LocaleKeys.terms_and_conditions.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () => launchURL(termUrl),
              ),
              TextSpan(
                text: '.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }

  _applyVoucherCode() {
    print(_controller.text);
    if (_controller.text.isNotEmpty) {
      _voucherBloc
        ..add(VoucherVerifyRequested(
            token: widget.token, voucher: _controller.text.toString()));
    } else {
      EasyLoading.showError(LocaleKeys.your_voucher_code_is.tr(),
          duration: Duration(seconds: 3));
    }
  }
}
