import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';

class LargeImageView extends StatefulWidget {
  const LargeImageView({Key? key, required this.image, required this.imageList})
      : super(key: key);

  final String image;
  final List<String> imageList;

  @override
  _LargeImageViewState createState() => _LargeImageViewState();
}

class _LargeImageViewState extends State<LargeImageView> {
  var _currentIndex = 0;

  @override
  void initState() {
    _currentIndex =
        widget.imageList.indexWhere((item) => item.contains(widget.image));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kBlackColor,
        appBar: _getAppBarSection,
        body: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              _swipeLeft();
            } else if (details.primaryVelocity! < 0) {
              _swipeRight();
            }
          },
          child: _bodyContainer,
        ));
  }

  get _bodyContainer {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(widget.imageList[_currentIndex]),
      ),
    );
  }

  get _getAppBarSection {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          color: kButtonBackgroundColor.withOpacity(0.5),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: SvgPicture.asset(
            "assets/icons/Back ICon.svg",
            height: 15,
            color: kBlackColor,
          ),
        ),
      ),
      actions: [],
    );
  }

  void _swipeLeft() {
    setState(() {
      if (_currentIndex == 0) {
        _currentIndex = widget.imageList.length - 1;
      } else {
        _currentIndex--;
      }
    });
  }

  void _swipeRight() {
    setState(() {
      if (_currentIndex == widget.imageList.length - 1) {
        _currentIndex = 0;
      } else {
        _currentIndex++;
      }
    });
  }
}
