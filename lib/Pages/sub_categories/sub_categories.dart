import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Components/sub_category_widget/sub_category_widget.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'package:trust_app_updated/main.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/functions/functions.dart';

class SubCategories extends StatefulWidget {
  final String name_ar, name_en, image;
  int id = 0;

  SubCategories({
    super.key,
    required this.name_ar,
    required this.name_en,
    required this.image,
    required this.id,
  });

  @override
  State<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  bool isTablet = false;
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  final ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = true;
  late Future<dynamic> _subCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _subCategoriesFuture = getSubCategories(widget.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double offset = _scrollController.offset;

    if (offset > 100 && _isTitleVisible) {
      setState(() {
        _isTitleVisible = false;
      });
    } else if (offset <= 100 && !_isTitleVisible) {
      setState(() {
        _isTitleVisible = true;
      });
    }
  }

  @override
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
                    image: AssetImage('assets/images/BackGround.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
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
                                      Color.fromARGB(45, 0, 0, 0),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: _isTitleVisible
                                ? Padding(
                                    key: ValueKey(true),
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Text(
                                      locale.toString() == "ar"
                                          ? widget.name_ar
                                          : widget.name_en,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                : SizedBox(key: ValueKey(false)),
                          ),
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
                                fontWeight: FontWeight.bold,
                              ),
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
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.filter_list,
                                    color: Colors.black,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.25),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            isTablet = constraints.maxWidth > 600;
                            return FutureBuilder(
                              future: _subCategoriesFuture,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingWidget(
                                    heightLoading:
                                        MediaQuery.of(context).size.height *
                                            0.4,
                                  );
                                } else if (snapshot.hasData) {
                                  var sub_categories = snapshot.data;

                                  return AnimationLimiter(
                                    child: GridView.builder(
                                      cacheExtent: 500,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: sub_categories.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 6,
                                        childAspectRatio: isTablet ? 1.2 : 1.2,
                                      ),
                                      itemBuilder: (context, int index) {
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: SlideAnimation(
                                            horizontalOffset: 100.0,
                                            child: FadeInAnimation(
                                              curve: Curves.easeOut,
                                              child: SubCategoryWidget(
                                                isTablet: isTablet,
                                                url: sub_categories[index]
                                                    ["image"],
                                                children: sub_categories[index]
                                                        ["children"] ??
                                                    0,
                                                name_ar: sub_categories[index]
                                                            ["translations"][0]
                                                        ["value"] ??
                                                    "",
                                                name_en: sub_categories[index]
                                                        ["name"] ??
                                                    "",
                                                id: sub_categories[index]["id"],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: double.infinity,
                                    color: Colors.red,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isTitleVisible
                    ? AppBarWidget(logo: true)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
