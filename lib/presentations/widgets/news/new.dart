import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestcannedfood_ecommerce/presentations/pages/new_screen/new_detail.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class New extends StatelessWidget {
  final int id;
  final String slug;
  final String title;
  final String image;
  final bool isShowDateTime;
  final String? time;

  const New({
    Key? key,
    required this.id,
    required this.slug,
    required this.title,
    required this.image,
    this.time,
    required this.isShowDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => showMaterialModalBottomSheet(
          enableDrag: false,
          context: context,
          builder: (context) => NewDetailScreen(
                slug: slug,
                controller: ModalScrollController.of(context),
              )),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.6,
                  height: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title Text
                      Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      isShowDateTime
                          ? SizedBox(
                              height: 10,
                            )
                          : Container(),
                      // updated date Text
                      isShowDateTime
                          ? Text(
                              time!,
                              style: TextStyle(color: Colors.grey),
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      // Description Text
                    ],
                  ),
                ),

                // image
                Container(
                  height: 120,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
