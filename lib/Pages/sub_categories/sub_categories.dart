import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

  // 🔹 Pagination state
  List<dynamic> _subCategories = [];
  bool _isFirstLoading = true; // تحميل أول صفحة
  bool _isLoadingMore = false; // تحميل الصفحات التالية
  bool _hasMore = true;        // هل يوجد صفحات أخرى
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchSubCategories(isInitial: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;

    // Debug عشان نتأكد إننا بنوصل للنهاية
    print(
        "SCROLL -> pixels=${position.pixels}, max=${position.maxScrollExtent}");

    double offset = position.pixels;

    // إظهار/إخفاء العنوان الكبير مع السكور
    if (offset > 100 && _isTitleVisible) {
      setState(() {
        _isTitleVisible = false;
      });
    } else if (offset <= 100 && !_isTitleVisible) {
      setState(() {
        _isTitleVisible = true;
      });
    }

    // 🔹 استدعاء الصفحة التالية عند الاقتراب من نهاية السكور
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        !_isFirstLoading &&
        _hasMore) {
      print("===> TRIGGER LOAD MORE, next page = $_currentPage");
      _fetchSubCategories();
    }
  }

  Future<void> _fetchSubCategories({bool isInitial = false}) async {
    if (isInitial) {
      setState(() {
        _isFirstLoading = true;
        _currentPage = 1;
        _totalPages = 1;
        _hasMore = true;
        _subCategories.clear();
      });
    } else {
      if (_isLoadingMore || !_hasMore) {
        print(
            ">>> _fetchSubCategories(): skip (isLoadingMore=$_isLoadingMore, hasMore=$_hasMore)");
        return;
      }
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      print(">>> _fetchSubCategories(): requesting page = $_currentPage");

      final result = await getSubCategories(widget.id, _currentPage);

      final List<dynamic> newItems = result["data"] ?? [];
      final int totalPages = result["totalPages"] ?? 1;
      final int page = result["page"] ?? _currentPage;

      setState(() {
        _totalPages = totalPages;
        _currentPage = page;

        _subCategories.addAll(newItems);

        print(
            ">>> _fetchSubCategories(): loaded page=$page, items=${newItems.length}, totalPages=$_totalPages, totalLoaded=${_subCategories.length}");

        if (_currentPage >= _totalPages || newItems.isEmpty) {
          _hasMore = false;
          print(">>> _fetchSubCategories(): no more pages.");
        } else {
          _currentPage++; // 👈 الصفحة التالية اللي هنطلبها المرة الجاية
        }
      });
    } catch (e) {
      print("Error loading sub categories: $e");
    } finally {
      setState(() {
        _isFirstLoading = false;
        _isLoadingMore = false;
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
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/BackGround.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // 🔹 صورة الهيدر + العنوان
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
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
                                decoration: const BoxDecoration(
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
                            duration: const Duration(milliseconds: 300),
                            child: _isTitleVisible
                                ? Padding(
                                    key: const ValueKey(true),
                                    padding:
                                        const EdgeInsets.only(bottom: 15),
                                    child: Text(
                                      locale.toString() == "ar"
                                          ? widget.name_ar
                                          : widget.name_en,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                : const SizedBox(key: ValueKey(false)),
                          ),
                        ],
                      ),

                      // 🔹 سطر الفلتر
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, right: 15, left: 15),
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
                                child: const Center(
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

                      // 🔹 محتوى الجريد + اللودر السفلي
                      Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).size.height * 0.25,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            isTablet = constraints.maxWidth > 600;

                            // أول تحميل
                            if (_isFirstLoading) {
                              return LoadingWidget(
                                heightLoading:
                                    MediaQuery.of(context).size.height *
                                        0.4,
                              );
                            }

                            // لا يوجد أي داتا
                            if (_subCategories.isEmpty) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: const Center(
                                  child: Text(
                                    "لا يوجد أقسام فرعية",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return AnimationLimiter(
                              child: Column(
                                children: [
                                  GridView.builder(
                                    cacheExtent: 500,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _subCategories.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 6,
                                      childAspectRatio:
                                          isTablet ? 1.2 : 1.2,
                                    ),
                                    itemBuilder: (context, int index) {
                                      final sub = _subCategories[index];

                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        duration: const Duration(
                                            milliseconds: 500),
                                        child: SlideAnimation(
                                          horizontalOffset: 100.0,
                                          child: FadeInAnimation(
                                            curve: Curves.easeOut,
                                            child: SubCategoryWidget(
                                              isTablet: isTablet,
                                              url: sub["image"],
                                              children: sub["children"] ?? 0,
                                              name_ar: (sub["translations"]
                                                              as List?)
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? sub["translations"][0]
                                                          ["value"] ??
                                                      ""
                                                  : "",
                                              name_en: sub["name"] ?? "",
                                              id: sub["id"],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  // 🔹 لودر تحت الجريد وقت تحميل صفحة جديدة
                                  if (_isLoadingMore)
                                     Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: SpinKitThreeBounce(
                                        size: 24,
                                        color: MAIN_COLOR,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔹 AppBar أعلى
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
