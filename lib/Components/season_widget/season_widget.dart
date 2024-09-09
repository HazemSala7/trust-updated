import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trust_app_updated/Pages/all_seasons/all_seasons.dart';
import 'package:trust_app_updated/Pages/products_by_season/products_by_season.dart';
import 'package:trust_app_updated/Pages/sub_categories/sub_categories.dart';
import 'package:trust_app_updated/Server/domains/domains.dart';
import '../../Server/functions/functions.dart';
import '../../main.dart';

class SeasonWidget extends StatefulWidget {
  final name_ar, name_en, image, seasonImage;
  double height, width;
  int id = 0;
  SeasonWidget(
      {super.key,
      required this.name_ar,
      required this.name_en,
      required this.image,
      required this.width,
      required this.height,
      required this.id,
      required this.seasonImage});

  @override
  State<SeasonWidget> createState() => _SeasonWidgetState();
}

class _SeasonWidgetState extends State<SeasonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: InkWell(
        onTap: () {
          if (widget.id == 5) {
            NavigatorFunction(
                context,
                AllSeasons(
                  id: widget.id,
                  image: URLIMAGE + widget.seasonImage,
                  name_ar: widget.name_ar,
                  name_en: widget.name_en,
                ));
          } else {
            NavigatorFunction(
                context,
                ProductsBySeason(
                    name_ar: widget.name_ar,
                    name_en: widget.name_en,
                    season_image: URLIMAGE + widget.seasonImage,
                    image: URLIMAGE + widget.image,
                    season_id: widget.id));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Center(
                  child: SvgPicture.asset(
                widget.image,
                fit: BoxFit.cover,
                width: 65,
                height: 65,
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                locale.toString() == "ar" ? widget.name_ar : widget.name_en,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
