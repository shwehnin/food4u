import 'package:bestcannedfood_ecommerce/blocs/companies/companies_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/shop_detail/store_popup.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';

class ShopDetailScreen extends StatefulWidget {
  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  late CompaniesBloc _companiesBloc;

  List<Company> companies = [];

  List<Marker> allMarkers = [];

  double _centerLat = 0.0;
  double _centerLong = 0.0;

  @override
  void initState() {
    super.initState();
    _companiesBloc = BlocProvider.of<CompaniesBloc>(context);
    _companiesBloc.add(CompanyListRequested(keyword: '', order: '', sort: ''));
  }

  setMarkers() {
    companies.forEach((e) {
      int count = 0;

      double? lat;
      double? long;

      e.gpsPoint!.forEach((i) {
        if (count == 0) {
          lat = i.latitude!;
          _centerLat = i.latitude!;
        } else {
          long = i.longitude!;
          _centerLong = i.longitude!;
        }
        count++;
      });

      allMarkers.add(
        Marker(
          width: 30.0,
          height: 30.0,
          point: LatLng(lat!.toDouble(), long!.toDouble()),
          builder: (ctx) => Container(
            child: SvgPicture.asset(
              "assets/icons/pin.svg",
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompaniesBloc, CompaniesState>(
      listener: (context, state) {
        if (state is CompaniesLoadingState) {
          EasyLoading.show(status: LocaleKeys.loading.tr());
        }
        if (state is CompaniesLoadingSuccessState) {
          EasyLoading.dismiss();
          setState(() {
            companies = state.companies;
          });
        }
      },
      builder: (context, state) {
        if (state is CompaniesLoadingSuccessState) {
          if (companies.length > 0) {
            companies = state.companies;

            setMarkers();

            return Scaffold(
              backgroundColor: kPrimaryLightColor,
              body: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                  child: Column(
                    children: [
                      CustomAppBar(
                        title:
                            '${LocaleKeys.stores.tr()} (${companies.length})',
                        action: [],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: FlutterMap(
                        options: MapOptions(
                          center: _centerLat != 0.0 && _centerLong != 0.0
                              ? LatLng(_centerLat, _centerLong)
                              : LatLng(16.789748, 96.133073),
                          zoom: 13.0,
                          minZoom: 5,
                          onTap: (_) => _popupLayerController
                              .hidePopup(), // Hide popup when the map is tapped.
                        ),
                        children: [
                          TileLayerWidget(
                            options: TileLayerOptions(
                              urlTemplate:
                                  "https://api.mapbox.com/styles/v1/phwephwe/ckwhqw39a1jf414p3uxz2o8zo/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicGh3ZXBod2UiLCJhIjoiY2t3aHFqNnZnMTExdjJvcXFtMWV0ejVidSJ9.5WBkB_nh62aeaffuH0iojw",
                              additionalOptions: {
                                'accessToken':
                                    'pk.eyJ1IjoicGh3ZXBod2UiLCJhIjoiY2t3aHFqNnZnMTExdjJvcXFtMWV0ejVidSJ9.5WBkB_nh62aeaffuH0iojw',
                                'id': 'mapbox.mapbox-streets-v8',
                              },
                            ),
                          ),
                          PopupMarkerLayerWidget(
                            options: PopupMarkerLayerOptions(
                              popupController: _popupLayerController,
                              markers: allMarkers,
                              markerRotateAlignment:
                                  PopupMarkerLayerOptions.rotationAlignmentFor(
                                      AnchorAlign.top),
                              popupBuilder:
                                  (BuildContext context, Marker marker) =>
                                      StoresPopup(
                                company: companies,
                                marker: marker,
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}
