import 'package:bestcannedfood_ecommerce/blocs/delivery_ares/delivery_areas_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Region extends StatefulWidget {
  Function(String) onSelectArea;
  int? deliAreasId;
  Region({Key? key, required this.onSelectArea, this.deliAreasId})
      : super(key: key);

  @override
  _RegionState createState() => _RegionState();
}

class _RegionState extends State<Region> {
  var _selectedArea = null;
  List<String> _areaList = [];
  List<int> _areaIdList = [];
  late DeliveryBloc _deliveryBloc;

  @override
  void initState() {
    super.initState();
    _deliveryBloc = BlocProvider.of<DeliveryBloc>(context);
    _deliveryBloc
      ..add(
          DeliveryAreaIdRequested(keyword: '', sort: 'township', order: 'ASC'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryBloc, DeliveryState>(builder: (context, state) {
      if (state is DeliveryAreaIdLoadSuccess) {
        return _getDeliveryAreas;
      }
      return Container();
    }, listener: (context, state) {
      if (state is DeliveryAreaIdLoadSuccess) {
        var data = state.areasList;

        for (int i = 0; i < data.length; i++) {
          String _area = '${data[i]['township']}, ${data[i]['myanmar_region']}';
          // Set area dropdown value before updating location.
          if (widget.deliAreasId == data[i]['id']) {
            _selectedArea = _area;
          }
          if (!_areaList.contains(_area)) {
            setState(() {
              _areaList.add(_area);
              _areaIdList.add(data[i]['id']);
            });
          }
        }
      }
    });
  }

  get _getDeliveryAreas {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: kPrimaryLightColor,
      ),
      child: DropdownSearch<String>(
        mode: Mode.BOTTOM_SHEET,
        items: _areaList.map((String e) {
          return e;
        }).toList(),
        dropdownSearchDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 13),
          hintText: LocaleKeys.select_area.tr(),
          labelStyle: TextStyle(color: Colors.grey),
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
        onChanged: (Object? object) {
          String line = object.toString();
          setState(() {
            _selectedArea = line;
          });
          int index = _areaList.indexWhere((item) => item == _selectedArea);
          widget.onSelectArea(_areaIdList[index].toString());
        },
        selectedItem: _selectedArea,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 13),
            hintText: 'Search area',
            labelStyle: TextStyle(color: Colors.grey),
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
        ),
        popupTitle: Container(
          height: 50,
          child: Center(
            child: Text(
              LocaleKeys.select_area.tr(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
        popupShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }
}
