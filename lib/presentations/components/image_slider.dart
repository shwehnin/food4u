import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/new_screen/new_detail.dart';
import 'package:bestcannedfood_ecommerce/presentations/widgets/product_detail/large_image_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CarouselSliderWithIndicator extends StatefulWidget {
  CarouselSliderWithIndicator(
      {required this.imgList,
      this.titleList,
      required this.isAutoPlay,
      required this.isAboveImage,
      required this.isShowText,
      required this.isShowLargeImage,
      required this.isCenterText,
      required this.height,
      this.idList,
      required this.isNetworkType});

  final bool isAutoPlay;
  final bool isShowText;
  final bool isAboveImage;
  final bool isShowLargeImage;
  final bool isCenterText;
  final List<String>? titleList;
  final List<String> imgList;
  final List<String>? idList;
  final double height;
  final bool isNetworkType;

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselSliderWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.imgList
        .map((item) => SizedBox(
              width: MediaQuery.of(context).size.width,
              height: widget.height,
              child: Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (widget.isShowLargeImage) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LargeImageView(
                                image: item, imageList: widget.imgList),
                          ),
                        );
                      }
                    },
                    child: widget.isNetworkType
                        ? Image.network(
                            item,
                            fit: BoxFit.cover,
                            height: widget.height,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Image.asset(
                            item,
                            fit: BoxFit.contain,
                            height: widget.height,
                            width: MediaQuery.of(context).size.width,
                          ),
                  ),
                  _getImageTitle(item)
                ],
              ),
            ))
        .toList();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.height,
      child: Stack(children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              height: widget.height,
              scrollPhysics: widget.isShowLargeImage
                  ? NeverScrollableScrollPhysics()
                  : PageScrollPhysics(),
              autoPlay: widget.isAutoPlay,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        widget.isAboveImage
            ? Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 10.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 5.0,
                          height: 5.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white)
                                  .withOpacity(
                                      _current == entry.key ? 1 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }

  _getImageTitle(item) {
    if (widget.isShowText && !widget.isCenterText) {
      return Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(200, 0, 0, 0),
                Color.fromARGB(0, 0, 0, 0)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: InkWell(
            onTap: () => showMaterialModalBottomSheet(
                enableDrag: false,
                context: context,
                builder: (context) => NewDetailScreen(
                      slug: widget.idList![widget.imgList.indexOf(item)],
                      controller: ModalScrollController.of(context),
                    )),
            child: Text(
              widget.titleList![widget.imgList.indexOf(item)],
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      );
    } else if (widget.isShowText && widget.isCenterText) {
      return Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        top: 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: kBlackColor.withOpacity(0.5),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: InkWell(
            onTap: () => showMaterialModalBottomSheet(
                enableDrag: false,
                context: context,
                builder: (context) => NewDetailScreen(
                      slug: widget.idList![widget.imgList.indexOf(item)],
                      controller: ModalScrollController.of(context),
                    )),
            child: Center(
              child: Text(
                widget.titleList![widget.imgList.indexOf(item)],
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
      );
      /*
      return Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => buildSheet(widget.titleList![widget.imgList.indexOf(item)], item)),
          child: Text(
            widget.titleList![widget.imgList.indexOf(item)],
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      );*/
    } else {
      return Container();
    }
  }
}
