import 'dart:convert';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // for ScrollDirection
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import '../../Components/bottom_bar_widget/bottom_bar_widget.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Components/product_widget/product_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/domains/domains.dart';
import '../../Server/functions/functions.dart';

class NewProducts extends StatefulWidget {
  NewProducts({super.key});

  @override
  State<NewProducts> createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  bool isTablet = false;

  // Data
  List<dynamic> AllProducts = [];
  int _page = 1;
  final int _limit = 20;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  // Scroll + hide/show
  ScrollController? _controller;
  bool _showHeaderUI = true; // controls BOTH the over-image title & AppBarWidget
  double _lastOffset = 0.0;

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/BackGround.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            isTablet = constraints.maxWidth > 600;

            return Column(
              children: [
                _isFirstLoadRunning
                    ? LoadingWidget(
                        heightLoading: MediaQuery.of(context).size.height * 0.9)
                    : Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            children: [
                              // Hero slideshow + gradient + centered product title (hidden on scroll down)
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: isTablet
                                        ? MediaQuery.of(context).size.height * 0.4
                                        : MediaQuery.of(context).size.height * 0.3,
                                    child: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setStateSB) {
                                        // Defensive decode for first product images
                                        final hasProduct = AllProducts.isNotEmpty && AllProducts[0] != null;
                                        List<String> images = [];
                                        if (hasProduct) {
                                          try {
                                            final raw = AllProducts[0]["image"];
                                            if (raw is String && raw.startsWith("[") && raw.endsWith("]")) {
                                              images = (json.decode(raw) as List)
                                                  .map((e) => e.toString())
                                                  .toList();
                                            }
                                          } catch (_) {
                                            images = [];
                                          }
                                        }

                                        return Stack(
                                          children: [
                                            ImageSlideshow(
                                              width: double.infinity,
                                              indicatorColor: Colors.red,
                                              height: isTablet
                                                  ? MediaQuery.of(context).size.height * 0.4
                                                  : MediaQuery.of(context).size.height * 0.3,
                                              children: (images.isNotEmpty
                                                      ? images
                                                      : <String>[])
                                                  .map(
                                                    (e) => Image.network(
                                                      URLIMAGE + e,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) =>
                                                          Image.asset(
                                                        "assets/images/logo_red.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              autoPlayInterval: 3000,
                                              isLoop: true,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: isTablet
                                                  ? MediaQuery.of(context).size.height * 0.4
                                                  : MediaQuery.of(context).size.height * 0.3,
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color.fromARGB(183, 0, 0, 0),
                                                    Color.fromARGB(45, 0, 0, 0)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),

                                  // Centered product name (hide on scroll down)
                                  if (AllProducts.isNotEmpty)
                                    AnimatedSlide(
                                      duration: const Duration(milliseconds: 220),
                                      curve: Curves.easeOut,
                                      offset: _showHeaderUI ? Offset.zero : const Offset(0, -0.2),
                                      child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 200),
                                        opacity: _showHeaderUI ? 1 : 0,
                                        child: Text(
                                          (AllProducts[0]["name"] ?? "").toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              if (!_isFirstLoadRunning)
                                if (AllProducts.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Text(
                                      "لا يوجد أي منتج",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      cacheExtent: 100,
                                      itemCount: AllProducts.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 6,
                                        mainAxisSpacing: 6,
                                        childAspectRatio: isTablet ? 1.4 : 0.8,
                                      ),
                                      itemBuilder: (context, int index) {
                                        // Parse image list
                                        final imageRaw = AllProducts[index]["image"];
                                        String imageString = imageRaw is String ? imageRaw : "";
                                        List<String> resultList = [];
                                        if (imageString.isNotEmpty && imageString.startsWith("[") && imageString.endsWith("]")) {
                                          try {
                                            resultList = (jsonDecode(imageString) as List)
                                                .map((item) => item.toString())
                                                .toList();
                                          } catch (_) {
                                            resultList = [];
                                          }
                                        }

                                        // Sizes
                                        List<String> _initSizes = [];
                                        List<String> _initSizesAR = [];
                                        List<int> _initSizesIDs = [];
                                        try {
                                          final sizes = AllProducts[index]["sizes"] as List<dynamic>? ?? [];
                                          for (int i = 0; i < sizes.length; i++) {
                                            _initSizes.add(sizes[i]["title"].toString());
                                            _initSizesAR.add(
                                              (sizes[i]["translations"]?[0]?["value"] ?? "").toString(),
                                            );
                                            _initSizesIDs.add(sizes[i]["id"] as int);
                                          }
                                        } catch (_) {}

                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 500),
                                          child: SlideAnimation(
                                            horizontalOffset: 100.0,
                                            child: FadeInAnimation(
                                              curve: Curves.easeOut,
                                              child: ProductWidget(
                                                isTablet: isTablet,
                                                SIZESIDs: _initSizesIDs,
                                                colors: AllProducts[index]["colors"] ?? [],
                                                SIZES_EN: _initSizes,
                                                SIZES_AR: _initSizesAR,
                                                category_id: AllProducts[index]["categoryId"] ?? 0,
                                                image: resultList.isNotEmpty ? resultList[0] : "",
                                                name_ar: (AllProducts[index]["translations"]?[0]?["value"] ?? "").toString(),
                                                name_en: (AllProducts[index]["name"] ?? "").toString(),
                                                id: AllProducts[index]["id"] ?? 0,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                              if (_isLoadMoreRunning)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 85),
                                  child: LoadingWidget(heightLoading: 50),
                                ),
                            ],
                          ),
                        ),
                      ),
              ],
            );
          }),
        ),

        // App bar at the very top (hide on scroll down)
        AnimatedSlide(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          offset: _showHeaderUI ? Offset.zero : const Offset(0, -0.2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showHeaderUI ? 1 : 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:  [AppBarWidget(logo: true)],
            ),
          ),
        ),
      ],
    );
  }

  // --- Data fetching ---
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final _products = await getLatestProducts(_page);
      setState(() {
        AllProducts = _products ?? [];
        // simple next page guess: if less than limit, probably last page
        _hasNextPage = (AllProducts.length >= _limit);
      });
    } catch (err) {
      if (kDebugMode) print('Something went wrong on first load: $err');
    } finally {
      setState(() {
        _isFirstLoadRunning = false;
      });
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller != null &&
        _controller!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        final _products = await getLatestProducts(_page);
        if (_products != null && _products.isNotEmpty) {
          setState(() {
            AllProducts.addAll(_products);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
          Fluttertoast.showToast(msg: AppLocalizations.of(context)!.no_products);
        }
      } catch (err) {
        if (kDebugMode) print('Something went wrong on load more: $err');
      } finally {
        setState(() {
          _isLoadMoreRunning = false;
        });
      }
    }
  }

  // --- Scroll behavior: hide/show header UI ---
  void _onScroll() {
    if (_controller == null) return;
    final direction = _controller!.position.userScrollDirection;
    final offset = _controller!.offset;

    // At the very top: always show
    if (offset <= 0) {
      if (!_showHeaderUI) {
        setState(() => _showHeaderUI = true);
      }
      _lastOffset = offset;
      return;
    }

    // If scrolling down (reverse), hide; if up (forward), show
    if (direction == ScrollDirection.reverse) {
      if (_showHeaderUI) setState(() => _showHeaderUI = false);
    } else if (direction == ScrollDirection.forward) {
      if (!_showHeaderUI) setState(() => _showHeaderUI = true);
    }

    _lastOffset = offset;
  }

  // --- Lifecycle ---
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()
      ..addListener(_loadMore)
      ..addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);
    _controller?.removeListener(_onScroll);
    _controller?.dispose();
    super.dispose();
  }
}
