import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trust_app_updated/Components/app_bar_widget/app_bar_widget.dart';
import 'package:trust_app_updated/Pages/offers/offer_full_screen/offer_full_screen.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import '../../Components/loading_widget/loading_widget.dart';
import '../../Constants/constants.dart';
import '../../Server/domains/domains.dart';
import '../../Server/functions/functions.dart';

class Offers extends StatefulWidget {
  Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  List<dynamic> AllProducts = [];
  ScrollController _controller = ScrollController();
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  final int _limit = 20;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller.addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _firstLoad() async {
    setState(() => _isFirstLoadRunning = true);
    try {
      var _products = await getOffers(_page);
      setState(() => AllProducts = _products);
      print(URLIMAGE + AllProducts[0]["image"]);
    } catch (err) {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
    setState(() => _isFirstLoadRunning = false);
  }

  void _loadMore() async {
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        _controller.position.extentAfter < 300) {
      setState(() => _isLoadMoreRunning = true);
      _page++;
      try {
        var _products = await getOffers(_page);
        if (_products["items"].isNotEmpty) {
          setState(() => AllProducts.addAll(_products["items"]));
        } else {
          _hasNextPage = false;
        }
      } catch (err) {
        Fluttertoast.showToast(msg: "Something went wrong!");
      }
      setState(() => _isLoadMoreRunning = false);
    }
  }

  String _normalizedImage(dynamic raw) {
    if (raw == null) return '';
    var s = raw.toString().trim();
    if (s.startsWith('[') && s.endsWith(']')) {
      // Remove [ ] and quotes, and if multiple, take the first
      s = s.substring(1, s.length - 1).replaceAll('"', '');
      if (s.contains(',')) s = s.split(',').first.trim();
    }
    return s;
  }

  Widget offerWidget(
      {required String name, required String image, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OfferFullScreen(name: name, image: image, desc: desc)));
        },
        child: Container(
          width: double.infinity,
          height: 180,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: (image.isNotEmpty ?? false)
                            ? Image.network(
                                URLIMAGE + image,
                                fit: BoxFit.cover,
                                height: 155,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/logo_red.png",
                                    fit: BoxFit.contain,
                                    height: 155,
                                    width: double.infinity,
                                  );
                                },
                              )
                            : Image.asset(
                                "assets/images/logo_red.png",
                                fit: BoxFit.contain,
                                height: 155,
                                width: double.infinity,
                              ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name ?? 'No Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              desc ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfferFullScreen(
                                name: name, image: image, desc: desc)));
                  },
                  icon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            flexibleSpace: AppBarWidget(logo: true),
          ),

          // **Banner Section**
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              child: AllProducts.isEmpty
                  ? Container(height: 220, color: Colors.grey[300])
                  : Builder(
                      builder: (_) {
                        final first = AllProducts.first;
                        final bannerImage = _normalizedImage(first["image"]);
                        return bannerImage.isNotEmpty
                            ? Image.network(
                                URLIMAGE + bannerImage,
                                height: 220,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/new_logo.png",
                                    height: 220,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                "assets/images/new_logo.png",
                                height: 220,
                                fit: BoxFit.cover,
                              );
                      },
                    ),
            ),
          ),

          // **Title Section**
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.available_offers,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MAIN_COLOR),
                ),
              ),
            ),
          ),

          // **Product List**
          AllProducts.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.there_is_no_offers,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var imageString = AllProducts[index]["image"] ?? "";

                      if (imageString.startsWith("[") &&
                          imageString.endsWith("]")) {
                        imageString = imageString
                            .substring(1, imageString.length - 1)
                            .replaceAll('"', '');
                      }
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                            curve: Curves.easeOut,
                            child: offerWidget(
                              image: imageString,
                              desc: AllProducts[index]["description"] ?? "",
                              name: AllProducts[index]["name"] ?? "",
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: AllProducts.length,
                  ),
                ),

          // **Loading Indicator**
          if (_isLoadMoreRunning)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child:
                    Center(child: CircularProgressIndicator(color: MAIN_COLOR)),
              ),
            ),
        ],
      ),
    );
  }
}
