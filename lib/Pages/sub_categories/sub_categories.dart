import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Components/sub_category_widget/sub_category_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trust_app_updated/Pages/products_by_season/products_by_season.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/domains/domains.dart';
import '../../Server/functions/functions.dart';

class SubCategories extends StatefulWidget {
  final name, image;
  int id = 0;
  SubCategories(
      {super.key, required this.name, required this.image, required this.id});

  @override
  State<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  @override
  bool isTablet = false;
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldState,
          drawer: DrawerWell(
            Refresh: () {
              setState(() {});
            },
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-full.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Image.network(
                                  widget.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
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
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 15, left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.view_by_category,
                              style: TextStyle(
                                  color: MAIN_COLOR,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                showFilterDialog(context);
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                    child: Icon(
                                  Icons.filter_list,
                                  color: Colors.black,
                                  size: 17,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth > 600) {
                          isTablet = true;
                        } else {
                          isTablet = false;
                        }
                        return FutureBuilder(
                            future: getSubCategories(widget.id),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LoadingWidget(
                                  heightLoading:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              } else {
                                if (snapshot.data != null) {
                                  var sub_categories = snapshot.data;

                                  return AnimationLimiter(
                                    child: GridView.builder(
                                        cacheExtent: 5000,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: sub_categories.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 6,
                                          childAspectRatio:
                                              isTablet ? 2.0 : 1.2,
                                        ),
                                        itemBuilder: (context, int index) {
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: SlideAnimation(
                                              horizontalOffset: 100.0,
                                              // verticalOffset: 100.0,
                                              child: FadeInAnimation(
                                                  curve: Curves.easeOut,
                                                  child: SubCategoryWidget(
                                                      isTablet: isTablet,
                                                      url: sub_categories[index]
                                                          ["image"],
                                                      children: sub_categories[
                                                                  index]
                                                              ["children"] ??
                                                          0,
                                                      name_ar: sub_categories[index]
                                                                  ["translations"]
                                                              [0]["value"] ??
                                                          "",
                                                      name_en:
                                                          sub_categories[index]
                                                                  ["name"] ??
                                                              "",
                                                      id: sub_categories[index]
                                                          ["id"])),
                                            ),
                                          );
                                        }),
                                  );
                                } else {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: double.infinity,
                                    color: Colors.white,
                                  );
                                }
                              }
                            });
                      })
                    ],
                  ),
                ),
              ),
              AppBarWidget(logo: true)
            ],
          ),
        ),
      ),
    );
  }
}
