import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/model/favourite.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FavouriteListLoading extends StatefulWidget {
  const FavouriteListLoading({Key? key}) : super(key: key);

  @override
  _FavouriteListLoadingState createState() => _FavouriteListLoadingState();
}

class _FavouriteListLoadingState extends State<FavouriteListLoading> {
  List<Favourite> favourites = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleSkeleton,
                // ListView.builder(
                // shrinkWrap: true,
                // itemCount: 10,
                // itemBuilder: (context, index) => listSkeleton(),
                // ),
                Expanded(child: listSkeleton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  get _titleSkeleton {
    return Container(
      width: 200,
      height: 20.0,
      color: Colors.white,
    );
  }

  Widget listSkeleton() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      // itemCount: favourites.length,
      itemCount: 20,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                width: size.width * 0.39,
                color: Colors.grey,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 8.0,
                          color: Colors.grey,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 2,
                                color: kButtonBackgroundColor.withOpacity(0.5)),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 20,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 60.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
