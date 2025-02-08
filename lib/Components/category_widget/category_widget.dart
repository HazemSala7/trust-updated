import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:trust_app_updated/Components/sub_category_widget/sub_category_widget.dart';
import 'package:trust_app_updated/Pages/sub_categories/sub_categories.dart';
import 'package:trust_app_updated/Server/domains/domains.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:trust_app_updated/main.dart';

import '../../Language_Manager/language_manager.dart';

class CategoryWidget extends StatefulWidget {
  final url, name_ar, name_en;
  int id = 0;
  double height, width;
  CategoryWidget(
      {super.key,
      required this.url,
      required this.name_ar,
      required this.name_en,
      required this.height,
      required this.width,
      required this.id});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: InkWell(
        onTap: () {
          NavigatorFunction(
              context,
              SubCategories(
                  name: locale.toString() == "ar"
                      ? widget.name_ar
                      : widget.name_en,
                  image: URLIMAGE + widget.url,
                  id: widget.id));
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              children: [
                Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FancyShimmerImage(
                      imageUrl: URLIMAGE + widget.url,
                    ),
                  ),
                ),
                Container(
                    width: widget.width,
                    height: widget.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(148, 213, 28, 40),
                          const Color.fromARGB(0, 255, 255, 255)
                        ],
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                locale.toString() == "ar" ? widget.name_ar : widget.name_en,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13),
              ),
            )
          ],
        ),
      ),
    );
  }
}
