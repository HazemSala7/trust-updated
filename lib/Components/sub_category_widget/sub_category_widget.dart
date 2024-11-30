import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:trust_app_updated/Pages/products_by_category/products_by_category.dart';
import 'package:trust_app_updated/Pages/sub_categories/sub_categories.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';

import '../../Server/domains/domains.dart';
import '../../main.dart';

class SubCategoryWidget extends StatefulWidget {
  final url, name_ar, name_en;
  int id = 0, children;
  bool isTablet;
  SubCategoryWidget(
      {super.key,
      required this.isTablet,
      required this.url,
      required this.children,
      required this.name_ar,
      required this.name_en,
      required this.id});

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: InkWell(
        onTap: () {
          if (widget.children == 0) {
            NavigatorFunction(
                context,
                ProductsByCategory(
                    name: locale.toString() == "ar"
                        ? widget.name_ar
                        : widget.name_en,
                    image: URLIMAGE + widget.url,
                    category_id: widget.id));
          } else {
            NavigatorFunction(
                context,
                SubCategories(
                  name: locale.toString() == "ar"
                      ? widget.name_ar
                      : widget.name_en,
                  image: URLIMAGE + widget.url,
                  id: widget.id,
                ));
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: widget.isTablet ? 200 : 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    FancyShimmerImage(
                      imageUrl: URLIMAGE + widget.url,
                      boxFit: BoxFit.cover,
                      width: double.infinity,
                      height: widget.isTablet ? 200 : 160,
                    ),
                    Container(
                        width: double.infinity,
                        height: widget.isTablet ? 200 : 160,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(183, 0, 0, 0),
                              Color.fromARGB(45, 0, 0, 0)
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Text(
              locale.toString() == "ar" ? widget.name_ar : widget.name_en,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 17),
            )
          ],
        ),
      ),
    );
  }
}
