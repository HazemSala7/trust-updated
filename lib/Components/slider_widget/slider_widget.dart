import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/product_screen/product_screen.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../../Models/slider/slider_model.dart';
import '../../Server/domains/domains.dart';

class SlideImage extends StatefulWidget {
  List<Silder> slideimage;
  bool showShadow = false;
  bool click = false;
  SlideImage({
    Key? key,
    required this.slideimage,
    required this.showShadow,
    required this.click,
  }) : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ImageSlideshow(
        width: double.infinity,
        indicatorColor: MAIN_COLOR,
        height: MediaQuery.of(context).size.height * 0.35,
        children: widget.slideimage
            .map((e) => InkWell(
                  onTap: () {
                    if (widget.click) {
                      if (e.product_id.length < 5) {
                        NavigatorFunction(
                            context,
                            ProductScreen(
                                name: " - ",
                                category_id: 0,
                                image: "-",
                                product_id:
                                    int.parse(e.product_id.toString())));
                      }
                    }
                  },
                  child: ZoomOverlay(
                    modalBarrierColor: Colors.black12,
                    minScale: 0.5,
                    maxScale: 3.0,
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 300),
                    twoTouchOnly: true,
                    onScaleStart: () {},
                    onScaleStop: () {},
                    child: Stack(
                      children: [
                        FancyShimmerImage(
                          imageUrl: URLIMAGE + e.image,
                          boxFit: BoxFit.cover,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        Visibility(
                          visible: widget.showShadow,
                          child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 213, 28, 40),
                                    const Color.fromARGB(0, 255, 255, 255)
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
        autoPlayInterval: 6000,
        // isLoop: true,
      );
    });
  }
}
