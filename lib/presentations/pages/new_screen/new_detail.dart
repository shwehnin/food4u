import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/blocs/news_detail/news_detail_bloc.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/news.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/news/related_new.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:heroicons/heroicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class NewDetailScreen extends StatefulWidget {
  final String slug;
  final ScrollController? controller;

  NewDetailScreen({Key? key, this.controller, required this.slug})
      : super(key: key);

  @override
  _NewDetailScreenState createState() => _NewDetailScreenState();
}

class _NewDetailScreenState extends State<NewDetailScreen> {
  late NewsDetailBloc _newsDetailBloc;
  late News _newsDetail;
  List<News> _relatedNewsList = [];

  @override
  void initState() {
    super.initState();

    _newsDetailBloc = BlocProvider.of<NewsDetailBloc>(context);
    // Call API request to get News list
    _newsDetailBloc.add(
      NewsDetailRequested(
        slug: widget.slug,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsDetailBloc, NewsDetailState>(
        builder: (context, state) {
          if (state is NewsDetailLoadInProgress) {
            // Nothing to do
          }
          if (state is NewsDetailLoadSuccess) {
            // When API response has data
            if (state.newsDetail != null) {
              _newsDetail = News(
                id: state.newsDetail.id,
                status: state.newsDetail.status,
                title: state.newsDetail.title,
                description: state.newsDetail.description,
                newsImage: state.newsDetail.newsImage,
                referUrl: state.newsDetail.referUrl,
                updatedAt: state.newsDetail.updatedAt,
                relatedNews: state.newsDetail.relatedNews,
              );

              if (null != _newsDetail.relatedNews) {
                _relatedNewsList = _newsDetail.relatedNews ?? [];
              }
            }
            if (_relatedNewsList.length != 0) {
              return Container(
                color: kPrimaryLightColor,
                child: ListView(
                  controller: widget.controller,
                  children: [
                    _newsDetailsInfo,
                    _relatedNewsListInfo,
                  ],
                ),
              );
            } else {
              // Blank Related News
              return Container(
                color: kPrimaryLightColor,
                child: ListView(
                  controller: widget.controller,
                  children: [
                    _newsDetailsInfo,
                    _noRelatedNews,
                  ],
                ),
              );
            }
          }
          return Container();
        },
        listener: (context, state) {});
  }

  get _newsDetailsInfo {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                // image
                image: DecorationImage(
                  image: CachedNetworkImageProvider(_newsDetail.newsImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: HeroIcon(
                    HeroIcons.xCircle,
                    color: kPrimaryLightColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          // title Text
          child: Text(
            _newsDetail.title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: kBlackColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            children: [
              HeroIcon(
                HeroIcons.clock,
                size: 16,
              ),
              SizedBox(width: 10),
              // Updataed Date Text
              Text(
                _newsDetail.updatedAt != null ? _newsDetail.updatedAt! : '',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Html(
            data: _newsDetail.description,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () => launch(_newsDetail.referUrl.toString()),
            child: Text(
              'Reference Link',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              LocaleKeys.related_news.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              //textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }

  get _relatedNewsListInfo {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        // Related News List
        return RelatedNew(
          slug: _relatedNewsList[index].slug!,
          title: _relatedNewsList[index].title,
          image: _relatedNewsList[index].newsImage,
          isShowDateTime: false,
        );
      },
      itemCount: _relatedNewsList.length,
    );
  }

  get _noRelatedNews {
    return Container(
      width: 200,
      height: 200,
      child: Center(
        child: Text('No records found'),
      ),
    );
  }
}
