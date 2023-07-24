import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatefulWidget {
  ProductDetailsShimmer({Key? key}) : super(key: key);

  @override
  _ProductDetailsShimmerState createState() => _ProductDetailsShimmerState();
}

class _ProductDetailsShimmerState extends State<ProductDetailsShimmer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Container(
                        width: double.infinity,
                        height: 300.0,
                        color: Colors.white,
                      ),
                  SizedBox(
                    height: 20,
                  ),

                  Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), child: _titleSkeleton(MediaQuery.of(context).size.width),),
                  
                  SizedBox(
                    height: 10,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), child: _titleSkeleton(MediaQuery.of(context).size.width/3),),
                  SizedBox(
                    height: 20,
                  ),
                  _foodCategorySleleton,
                  SizedBox(
                    height: 20,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), child: _promotionSkeleton,),
                
                  SizedBox(
                    height: 20,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), child: _addOnSkeleton,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _promotionSkeleton {
    return Container(
      width: double.infinity,
      height: 150.0,
      color: Colors.white,
    );
  }

  get _addOnSkeleton {
    return Container(
      width: double.infinity,
      height: 300.0,
      color: Colors.white,
    );
  }

  _titleSkeleton(double width) {
    return Container(
      width: width,
      height: 30.0,
      color: Colors.white,
    );
  }


  get _foodCategorySleleton{
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        _foodCategoryItem,
        SizedBox(width: 10,),
        _foodCategoryItem,
        SizedBox(width: 10,),
        _foodCategoryItem
      ],),
    );
  }

  get _foodCategoryItem{
    return Container(
      width: 80,
      height: 10.0,
      color: Colors.white,
    );
  }

}
