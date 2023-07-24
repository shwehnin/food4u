import 'package:bestcannedfood_ecommerce/blocs/news/news_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/custom_app_bar.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/image_slider.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/no_internet_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/shimmers/news_loading_shimmer.dart';
import 'package:bestcannedfood_ecommerce/presentations/components/loadmore_widget.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/network_error/network_error_screen.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/news/new.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  late NewsBloc _newsBloc;
  List<News> newsList = [];
  List<News> priorityList = [];
  List<String> titleList = [];
  List<String> imgList = [];
  List<String> idList = [];
  int page = 1;
  int totalCount = 0;
  int paginate = 20;

  @override
  void initState() {
    super.initState();

    _newsBloc = BlocProvider.of<NewsBloc>(context);
    // Call API request to get News list
    _newsBloc.add(
      NewsListRequested(
          keyword: '',
          order: '',
          page: page,
          paginate: paginate,
          sort: '',
          isFirstTime: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (context, isConnected, status) {
        if (isConnected.toString() != 'false') {
          return _getNewsSection;
        } else {
          return NoInternetWidget();
        }
      },
    );
  }

  get _getNewsSection {
    return BlocConsumer<NewsBloc, NewsState>(builder: (context, state) {
      if (state is NewsListLoadInProgress) {
        // Show only first time loading
        return NewsLoadingPage();
      }
      if (state is NewsListLoadSuccess) {
        // When API response has data
        if (state.newsList['result']['data'] != null ||
            state.newsList['slider'] != null) {
          if (newsList.length != 0) {
            List<News> temp = List<News>.from(state.newsList['result']['data']
                .map((i) => News.fromNewsLists(i))).toList();
            for (int i = 0; i < temp.length; i++) {
              if (!newsList.contains(temp[i])) {
                newsList.add(temp[i]);
              }
            }
          } else {
            newsList = List<News>.from(state.newsList['result']['data']
                .map((i) => News.fromNewsLists(i))).toList();
          }

          // get data for Image slide
          priorityList = List<News>.from(
                  state.newsList['slider'].map((i) => News.fromNewsLists(i)))
              .toList();

          List.generate(priorityList.length, (index) {
            if (!titleList.contains(priorityList[index].title)) {
              // Add titles for image slide
              titleList.add(priorityList[index].title);
              // Add images for image slide
              imgList.add(priorityList[index].newsImage);
              // Add id list to go to News Details bottom sheet
              idList.add(priorityList[index].slug!);
            }
          });

          return priorityList.length != 0 || newsList.length != 0
              ? Scaffold(
                  backgroundColor: kButtonBackgroundColor,
                  body: SafeArea(
                    bottom: false,
                    child: Container(
                      color: kPrimaryLightColor,
                      child: LoadMore(
                        textBuilder: (status) {
                          if (status == LoadMoreStatus.nomore && page != 1) {
                            showErrorMessage(LocaleKeys.no_news_yet.tr());
                            return "";
                          }
                          return DefaultLoadMoreTextBuilder.english(status);
                        },
                        isFinish: newsList.length == 0
                            ? true
                            : (newsList.length % paginate) != 0,
                        onLoadMore: _loadMore,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      // Priority images list
                                      CarouselSliderWithIndicator(
                                        isAboveImage: true,
                                        isShowText: true,
                                        isAutoPlay: true,
                                        isShowLargeImage: false,
                                        isCenterText: true,
                                        height: 300.0,
                                        titleList: titleList,
                                        imgList: imgList,
                                        idList: idList,
                                        isNetworkType: true,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                        // App bar
                                        child: CustomAppBar(
                                            leading: Container(
                                              height: 40,
                                              width: 40,
                                              child: MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                ),
                                                color: kPrimaryLightColor,
                                                padding: EdgeInsets.zero,
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: SvgPicture.asset(
                                                  "assets/icons/Back ICon.svg",
                                                  height: 15,
                                                ),
                                              ),
                                            ),
                                            title: '',
                                            titleColor: kPrimaryLightColor,
                                            action: []),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        '${LocaleKeys.news.tr()} ($totalCount posts)',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: kBlackColor)),
                                  ),
                                ],
                              );
                            } else {
                              // News List
                              return New(
                                slug: newsList[index - 1].slug!,
                                id: newsList[index - 1].id,
                                title: newsList[index - 1].title,
                                image: newsList[index - 1].newsImage,
                                isShowDateTime: true,
                                time: newsList[index - 1].updatedAt,
                              );
                            }
                          },
                          itemCount: newsList.length + 1,
                        ),
                      ),
                    ),
                  ))
              : _noNewsScaffold;
        } else {
          // When no data from API response
          return _noNewsScaffold;
        }
      }

      if (state is NewsListLoadFailure) {
        return NetworkErrorScreen();
      }
      return Container();
    }, listener: (context, state) {
      if (state is NewsListLoadSuccess) {
        setState(() {
          totalCount = state.newsList['result']['total'];
        });
      }
    });
  }

  Future<bool> _loadMore() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      page++;
    });
    _newsBloc.add(
      NewsListRequested(
          keyword: '',
          order: '',
          page: page,
          paginate: paginate,
          sort: '',
          isFirstTime: false),
    );
    return true;
  }

  Widget get _noNewsScaffold {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: CustomAppBar(
                    leading: Container(
                      height: 40,
                      width: 40,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        color: kPrimaryLightColor,
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          "assets/icons/Back ICon.svg",
                          height: 15,
                        ),
                      ),
                    ),
                    title: '',
                    titleColor: kPrimaryLightColor,
                    action: []),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(
                  child: Text(LocaleKeys.no_news_yet.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
