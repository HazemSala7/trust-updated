import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // <-- for ScrollDirection
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Components/sub_category_widget/sub_category_widget.dart';
import 'package:trust_app_updated/main.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/functions/functions.dart';

class AllSeasons extends StatefulWidget {
  final name_ar, name_en, image;
  int id = 0;
  AllSeasons({
    super.key,
    required this.name_ar,
    required this.name_en,
    required this.image,
    required this.id,
  });

  @override
  State<AllSeasons> createState() => _AllSeasonsState();
}

class _AllSeasonsState extends State<AllSeasons> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  // UI state
  bool isTablet = false;
  bool _showAppBar = true;

  // Data
  List<dynamic> sub_categories = []; // <-- init to empty to avoid null length
  int _page = 1;
  final int _limit = 20;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  // Scroll
  ScrollController? _controller;

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    isTablet = constraints.maxWidth > 600;

                    return SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: [
                          // Header image + title
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Image.network(
                                      widget.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
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
                              Text(
                                locale.toString() == "ar"
                                    ? widget.name_ar
                                    : widget.name_en,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),

                          // Toolbar
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 15, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .view_by_category,
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
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.filter_list,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Content
                          _isFirstLoadRunning
                              ? LoadingWidget(
                                  heightLoading:
                                      MediaQuery.of(context).size.height,
                                )
                              : sub_categories.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Text(
                                        "لا يوجد أي قسم",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    )
                                  : GridView.builder(
                                      cacheExtent: 500,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      // IMPORTANT: don't attach the same controller to GridView
                                      itemCount: sub_categories.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 6,
                                        mainAxisSpacing: 6,
                                        childAspectRatio: isTablet ? 2.3 : 1.2,
                                      ),
                                      itemBuilder: (context, int index) {
                                        final item = sub_categories[index];
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
                                                url: item["image"],
                                                children: item["children"] ?? 0,
                                                name_ar: (item["translations"]
                                                        ?[0]?["value"]) ??
                                                    "",
                                                name_en: item["name"] ?? "",
                                                id: item["id"],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                          if (_isLoadMoreRunning)
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 40),
                              child: Center(
                                  child: LoadingWidget(heightLoading: 40)),
                            ),

                          if (_hasNextPage == false)
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 20),
                              color: MAIN_COLOR,
                              child:
                                  const Center(child: Text('لم يتبقى أي قسم')),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Animated AppBar
              AnimatedOpacity(
                opacity: _showAppBar ? 1 : 0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: _showAppBar ? Offset.zero : const Offset(0, -1),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: AppBarWidget(logo: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Data loading ----------

  Future<void> _firstLoad() async {
    setState(() => _isFirstLoadRunning = true);
    try {
      final result = await getSubCategoriesBySeasonID(widget.id, _page);
      setState(() {
        sub_categories = (result ?? []) as List<dynamic>;
        // If page returns fewer than limit, assume no more
        if (sub_categories.length < _limit) _hasNextPage = false;
      });
    } catch (err) {
      if (kDebugMode) print('Something went wrong: $err');
    } finally {
      setState(() => _isFirstLoadRunning = false);
    }
  }

  Future<void> _loadMore() async {
    // Avoid extra work if the list isn't near bottom or not ready
    if (!(_hasNextPage && !_isFirstLoadRunning && !_isLoadMoreRunning)) return;
    if (!(_controller?.hasClients ?? false)) return;
    if (_controller!.position.extentAfter >= 300) return;

    setState(() => _isLoadMoreRunning = true);
    _page += 1;

    try {
      final more = await getSubCategoriesBySeasonID(widget.id, _page);
      if (more != null && more.isNotEmpty) {
        setState(() => sub_categories.addAll(more));
        // If returned less than limit, mark as no more
        if (more.length < _limit) {
          setState(() => _hasNextPage = false);
        }
      } else {
        setState(() => _hasNextPage = false);
        Fluttertoast.showToast(msg: AppLocalizations.of(context)!.no_products);
      }
    } catch (err) {
      if (kDebugMode) {
        print("error");
        print(err);
      }
    } finally {
      if (mounted) setState(() => _isLoadMoreRunning = false);
    }
  }

  // ---------- Scroll handling ----------

  void _onScroll() {
    if (!(_controller?.hasClients ?? false)) return;

    final dir = _controller!.position.userScrollDirection;
    if (dir == ScrollDirection.reverse) {
      if (_showAppBar) setState(() => _showAppBar = false);
    } else if (dir == ScrollDirection.forward) {
      if (!_showAppBar) setState(() => _showAppBar = true);
    }

    // Also check pagination when we scroll
    _loadMore();
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller?.removeListener(_onScroll);
    _controller?.dispose();
    super.dispose();
  }
}
