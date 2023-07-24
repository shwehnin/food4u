import 'package:bestcannedfood_ecommerce/blocs/payments_types/payment_types_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/payment_types.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

class PaymentTypesWidget extends StatefulWidget {
  PaymentTypesWidget(
      {Key? key, required this.token, required this.onSelectPaymentId})
      : super(key: key);
  final String token;
  Function(String) onSelectPaymentId;

  @override
  _PaymentTypesWidgetState createState() => _PaymentTypesWidgetState();
}

class _PaymentTypesWidgetState extends State<PaymentTypesWidget> {
  late PaymentTypesBloc _paymentTypesBloc;
  List<PaymentTypes> _paymentList = [];
  int radioValue = -1;

  @override
  void initState() {
    super.initState();

    _paymentTypesBloc = BlocProvider.of<PaymentTypesBloc>(context);
    _paymentTypesBloc..add(PaymentTypesListRequested(token: widget.token));
  }

  handleRadioValueChange(final value) {
    setState(() {
      radioValue = value;
      widget.onSelectPaymentId(
          '$radioValue,${_paymentList[radioValue - 1].paymentType}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentTypesBloc, PaymentTypesState>(
        builder: (context, state) {
          if (state is PaymentTypesLoadingSuccessState) {
            _paymentList = state.paymentTypes;
            return _getPaymetSection;
          }
          return Container();
        },
        listener: (context, state) {});
  }

  Widget get _getPaymetSection {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.payment.tr(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        for (int i = 0; i < _paymentList.length; i++)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: RadioListTile(
                            contentPadding: EdgeInsets.only(right: 5),
                            value: _paymentList[i].id,
                            groupValue: radioValue,
                            onChanged: handleRadioValueChange,
                            activeColor: kPrimaryColor,
                            title: Text(
                              _paymentList[i].paymentType == 'Cash on delivery'
                                  ? LocaleKeys.cash_on_delivery.tr()
                                  : '${_paymentList[i].bankName} - ${LocaleKeys.electronic_bank_transfers.tr()}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 35,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: HeroIcon(
                          _paymentList[i].paymentType == 'Cash on delivery'
                              ? HeroIcons.cash
                              : HeroIcons.upload,
                          color: Colors.grey,
                          solid: true,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: radioValue == _paymentList[i].id ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: _paymentList[i].paymentType == 'Cash on delivery'
                          ? _getCashOnDeliverySection()
                          : _getElectricBankTransferSection(_paymentList[i]),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  _getCashOnDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.pay_by_cash.tr(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
            'Consider payment upon ordering for contactless delivery. You can\'t pay by a card to the rider upon delivery.'),
        SizedBox(height: 20),
      ],
    );
  }

  _getElectricBankTransferSection(PaymentTypes paymentList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Account Name:'),
            Text(
              paymentList.accountName!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Account Number:'),
            GestureDetector(
              onTap: () {
                FlutterClipboard.copy(paymentList.accountNumber!).then((value) {
                  showSuccessMessage(
                      'Bank account number ${paymentList.accountNumber!} is copied.');
                });
              },
              child: Text(
                paymentList.accountNumber!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
