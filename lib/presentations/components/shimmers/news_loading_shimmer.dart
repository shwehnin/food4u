import 'package:bestcannedfood_ecommerce/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsLoadingPage extends StatefulWidget {
  @override
  _NewsLoadingPageState createState() => _NewsLoadingPageState();
}

class _NewsLoadingPageState extends State<NewsLoadingPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          bottom: false,
          child: ListView(
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      // image list with no padding
                      padding: EdgeInsets.zero,
                      child: _imageListSkeleton(size),
                    ),
                    Padding(
                      // 'News (xx posts)' title
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _newsTitleSkeleton,
                    ),
                    Padding(
                      // News list
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _newsSkeleton(context, size),
                    ),
                  ],
                ),
              ),
            ],
          )), //;//,
    );
  }

  _imageListSkeleton(size) {
    return Container(
      width: size.width,
      height: 300,
      color: Colors.white,
    );
  }

  get _newsTitleSkeleton {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 200,
      height: 20,
      color: Colors.white,
    );
  }

  _newsSkeleton(context, size) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: 1000,
      child: ListView.builder(
        itemBuilder: (_, __) => SizedBox(
          width: getProportionateScreenWidth(140, context),
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // left side Textboxes
                    Container(
                      width: size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleSkeleton,
                          SizedBox(height: 10),
                          _updatedAt,
                          SizedBox(height: 10),
                          _descriptionSkeleton,
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    // image
                    _imageSkeleton(size),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ),
        itemCount: 10,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  get _titleSkeleton {
    return Container(
      width: 250,
      height: 50,
      color: Colors.white,
    );
  }

  get _descriptionSkeleton {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 3.0,
      ),
      width: 250,
      height: 75,
      color: Colors.white,
    );
  }

  get _updatedAt {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 3.0,
      ),
      width: 100,
      height: 10,
      color: Colors.white,
    );
  }

  _imageSkeleton(size) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 3.0,
      ),
      height: 160,
      width: size.width * 0.25,
      color: Colors.white,
    );
  }
}
