import 'package:bestcannedfood_ecommerce/blocs/delivery_ares/delivery_areas_bloc.dart';
import 'package:bestcannedfood_ecommerce/blocs/profile/profile_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/sign_up/region.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

// ignore: must_be_immutable
class DeliveryLocation extends StatefulWidget {
  final String token;
  String customerName;
  String deliveryLocation;
  int deliAreasId;
  String email;
  DeliveryLocation({
    Key? key,
    required this.token,
    required this.customerName,
    required this.deliveryLocation,
    required this.deliAreasId,
    required this.email,
  }) : super(key: key);

  @override
  _DeliveryLocationState createState() => _DeliveryLocationState();
}

class _DeliveryLocationState extends State<DeliveryLocation> {
  TextEditingController _addressController = TextEditingController();
  bool editAddress = true;
  late DeliveryBloc _deliveryBloc;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.deliveryLocation);
    _deliveryBloc = BlocProvider.of<DeliveryBloc>(context);
    _deliveryBloc
      ..add(
          DeliveryAreaIdRequested(keyword: '', sort: 'township', order: 'ASC'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            LocaleKeys.delivery_location.tr(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        BlocConsumer<DeliveryBloc, DeliveryState>(
            builder: (context, state) {
              if (state is DeliveryAreaIdLoadSuccess) {
                var data = state.areasList;
                String _areaDetails = '';

                for (int i = 0; i < data.length; i++) {
                  String _area =
                      '${data[i]['township']}, ${data[i]['myanmar_region']}';
                  // Set area dropdown value before updating location.
                  if (widget.deliAreasId == data[i]['id']) {
                    _areaDetails = ', $_area';
                  }
                }

                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => _getDialog(context),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 250,
                            child: Text(
                              widget.deliveryLocation != '' &&
                                      _areaDetails != ''
                                  ? '${widget.deliveryLocation}$_areaDetails'
                                  : LocaleKeys.no_address_yet.tr(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          HeroIcon(HeroIcons.pencilAlt)
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
            listener: (context, state) {}),
      ],
    );
  }

  Widget _getDialog(context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Container(
        width: size.width - 40,
        height: 370,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Get Regions list from API
                Region(
                  deliAreasId:
                      widget.deliveryLocation != '' ? widget.deliAreasId : 0,
                  onSelectArea: (String param) {
                    setState(() {
                      widget.deliAreasId = int.parse(param);
                    });
                  },
                ),
                SizedBox(height: 20),
                _buildAddress(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 45,
                      child: OutlinedButton(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5),
                        //   side: BorderSide(
                        //     color: Colors.grey.shade300,
                        //   ),
                        // ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          LocaleKeys.cancel.tr(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 45,
                      onPressed: () {
                        var location = _addressController.text;
                        Navigator.of(context).pop();
                        widget.deliveryLocation = '$location';
                        _updateLocation();
                        //setState(() {});
                      },
                      color: kPrimaryColor,
                      child: Text(
                        LocaleKeys.submit.tr(),
                        style:
                            TextStyle(color: kPrimaryLightColor, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updateLocation() {
    // Update Profile information

    if (widget.deliveryLocation != 'No address yet!' &&
        widget.deliAreasId != 0) {
      BlocProvider.of<ProfileBloc>(context)
        ..add(ProfileLocationUpdateRequested(
            token: widget.token,
            customerName: widget.customerName,
            deliveryLocation: widget.deliveryLocation,
            deliAreasId: widget.deliAreasId,
            email: widget.email,
            context: context));
      BlocProvider.of<ProfileBloc>(context)
        ..add(ProfileRequested(token: widget.token, isFirstTime: false));
    } else {
      showErrorMessage(LocaleKeys.required_delivery_address.tr());
    }
  }

  Widget _buildAddress() {
    return TextFormField(
      minLines: 5,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      controller: _addressController,
      onFieldSubmitted: (value) {
        setState(
          () {
            widget.deliveryLocation = value;
            editAddress = false;
          },
        );
      },
      cursorColor: kPrimaryColor,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        hintText: LocaleKeys.no_address_yet.tr(),
        labelStyle: TextStyle(color: Colors.grey.shade300),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
