import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trust_app_updated/Services/notification_service/image_saver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Pages/authentication/login_screen/login_screen.dart';
import 'package:trust_app_updated/Pages/product_screen/product_video/product_video.dart';
import 'package:trust_app_updated/main.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';
import '../../Components/app_bar_widget/app_bar_widget.dart';
import '../../Components/bottom_bar_widget/bottom_bar_widget.dart';
import '../../Components/drawer_widget/drawer_widget.dart';
import '../../Components/slider_widget/slider_widget.dart';
import '../../Constants/constants.dart';
import '../../Language_Manager/language_manager.dart';
import '../../LocalDB/Models/CartItem.dart';
import '../../LocalDB/Models/FavoriteItem.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../LocalDB/Provider/FavouriteProvider.dart';
import '../../Models/slider/slider_model.dart';
import '../../Server/domains/domains.dart';
import '../../Server/functions/functions.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen(
      {super.key,
      required this.name,
      required this.category_id,
      required this.image,
      required this.product_id});

  final name, image;
  int product_id = 0, category_id;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String ROLEID = "";
  String ShareUrl = "";
  Map<String, int> colorCountControllers = {};
  bool isTablet = false;
  bool login = false;

  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSharedPref();
  }

  setSharedPref() async {
    var ShareYrlResponse = await getShareUrl(widget.category_id) ?? "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? RoleID = await prefs.getString('role_id');
    bool? _login = await prefs.getBool('login');
    setState(() {
      ROLEID = RoleID.toString();
      login = (_login != null) ? _login : false;
      ShareUrl = ShareYrlResponse;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          // bottomNavigationBar: BottomBarWidget(currentIndex: _currentIndex),
          key: _scaffoldState,
          drawer: DrawerWell(
            Refresh: () {
              setState(() {});
            },
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              isTablet = true;
            } else {
              isTablet = false;
            }

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/BackGround.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: FutureBuilder(
                      future: getProductByID(widget.product_id),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ProductScreenParameters(
                              name_ar: widget.name,
                              name_en: widget.name,
                              descriptionAR: "",
                              descriptionEN: "",
                              image: widget.image,
                              Images: [widget.image],
                              colors: [],
                              sizes: []);
                        } else if (snapshot.hasError) {
                          // Handle errors gracefully
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 60, color: Colors.red),
                                SizedBox(height: 16),
                                Text(
                                  'Error loading product',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Please try again later',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        } else {
                          if (snapshot.data != null) {
                            try {
                              var Product = snapshot.data;
                              
                              // Safely extract image string with type checking
                              String imageString = "";
                              var imageData = Product["image"];
                              if (imageData != null) {
                                if (imageData is String) {
                                  imageString = imageData;
                                } else if (imageData is Map) {
                                  // Handle case where image is a Map
                                  imageString = imageData["url"]?.toString() ?? 
                                               imageData["path"]?.toString() ?? "";
                                } else if (imageData is List && imageData.isNotEmpty) {
                                  // Handle case where image is a List
                                  imageString = imageData[0].toString();
                                }
                              }
                              
                              List<String> resultList = [];
                              if (imageString.isNotEmpty) {
                                // Check if the imageString is in the expected format
                                if (imageString.startsWith("[") &&
                                    imageString.endsWith("]")) {
                                  try {
                                    resultList = (jsonDecode(imageString) as List)
                                        .map((item) => item.toString())
                                        .toList();
                                  } catch (e) {
                                    debugPrint('Error decoding image JSON: $e');
                                    resultList = [imageString];
                                  }
                                } else {
                                  resultList = [imageString];
                                }
                              }
                              
                              List<String> _initSizes = [];
                              List<String> _initSizesAR = [];
                              List<int> _initSizesIDs = [];
                              String? videoPath;

                              if (Product["sizes"] != null && Product["sizes"] is List) {
                                for (int i = 0;
                                    i < Product["sizes"].length;
                                    i++) {
                                  var size = Product["sizes"][i];
                                  if (size is Map) {
                                    _initSizes.add(size["title"]?.toString() ?? "");
                                    
                                    if (size["translations"] != null && 
                                        size["translations"] is List &&
                                        size["translations"].isNotEmpty) {
                                      _initSizesAR.add(size["translations"][0]["value"]
                                          ?.toString() ?? "");
                                    } else {
                                      _initSizesAR.add("");
                                    }
                                    
                                    _initSizesIDs.add(size["id"] is int ? size["id"] : 
                                                     int.tryParse(size["id"]?.toString() ?? "0") ?? 0);
                                  }
                                }
                              }

                              // Extract the video path
                              if (Product["video"] != null &&
                                  Product["video"].toString().isNotEmpty) {
                                try {
                                  List<dynamic> videoList = Product["video"] is String
                                      ? jsonDecode(Product["video"])
                                      : (Product["video"] is List ? Product["video"] : []);

                                  if (videoList.isNotEmpty &&
                                      videoList[0] is Map &&
                                      videoList[0]["download_link"] != null) {
                                    videoPath = videoList[0]["download_link"].toString();
                                  }
                                } catch (e) {
                                  debugPrint('Error extracting video path: $e');
                                  videoPath = null;
                                }
                              }

                              return ProductScreenParameters(
                                name_ar: Product["translations"] != null &&
                                        Product["translations"] is List &&
                                        Product["translations"].isNotEmpty
                                    ? (Product["translations"][0]["value"]?.toString() ?? "")
                                    : "",
                                name_en: Product["name"]?.toString() ?? "",
                                descriptionEN: Product["name"]?.toString() ?? "",
                                descriptionAR: Product["translations"] != null &&
                                        Product["translations"] is List &&
                                        Product["translations"].length > 1
                                    ? (Product["translations"][1]["value"]?.toString() ?? "")
                                    : "",
                                Images: resultList.isNotEmpty ? resultList : [imageString],
                                sizes: Product["sizes"] ?? [],
                                video: videoPath ?? "",
                                colors: Product["colors"] ?? [],
                                slug: Product["slug"]?.toString() ?? "",
                                SIZES_EN: _initSizes,
                                SIZES_AR: _initSizesAR,
                                SIZESIDs: _initSizesIDs,
                                imagewithout: imageString,
                                image: imageString.isNotEmpty ? URLIMAGE + imageString : "",
                                number: Product["number"]?.toString() ?? "",
                              );
                            } catch (e) {
                              // Catch any unexpected errors during parsing
                              debugPrint('Error parsing product data: $e');
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.warning_amber_rounded, size: 60, color: Colors.orange),
                                    SizedBox(height: 16),
                                    Text(
                                      'Error displaying product',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Invalid product data',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: double.infinity,
                              color: Colors.white,
                            );
                          }
                        }
                      }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [AppBarWidget(logo: true)],
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget ProductScreenParameters(
      {String image = "",
      String imagewithout = "",
      String name_ar = "",
      String descriptionAR = "",
      String name_en = "",
      String slug = "",
      String descriptionEN = "",
      String number = "",
      String video = "",
      String selectedSize = "",
      List<String>? SIZES_EN,
      List<String>? SIZES_AR,
      List<int>? SIZESIDs,
      List<String>? Images,
      List? sizes,
      List? colors}) {
    String getLanguage() {
      if (locale.toString() == "ar") {
        return name_ar;
      } else {
        return name_en;
      }
    }

    final cartProvider = Provider.of<CartProvider>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: locale.toString() == "ar"
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            children: [
              Stack(
                alignment: locale.toString() == "ar"
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: (Images!.isNotEmpty)
                                ? Image.network(
                                    URLIMAGE + Images[0],
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.network(
                                        URLIMAGE + Images[0],
                                        fit: isTablet
                                            ? BoxFit.fitHeight
                                            : BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        width: double.infinity,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    "assets/images/icon.png",
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width: double.infinity,
                                  ),
                          ),
                          Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(183, 92, 92, 92),
                                    Color.fromARGB(44, 78, 78, 78)
                                  ],
                                ),
                              )),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: Center(
                                  child: IconButton(
                                onPressed: () async {
                                  if (Images.length != 0) {
                                    int imageSelected = 0;
                                    if (Images.length > 1) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.all(0),
                                            child: Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: Colors.transparent,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                            return ImageSlideshow(
                                                              width: double
                                                                  .infinity,
                                                              initialPage:
                                                                  imageSelected,
                                                              onPageChanged:
                                                                  (_) {
                                                                imageSelected =
                                                                    _;

                                                                setState(() {});
                                                              },
                                                              indicatorColor:
                                                                  MAIN_COLOR,
                                                              children: Images
                                                                  .map((e) =>
                                                                      InkWell(
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            ZoomOverlay(
                                                                          modalBarrierColor:
                                                                              Colors.black12,
                                                                          minScale:
                                                                              0.5,
                                                                          maxScale:
                                                                              3.0,
                                                                          animationCurve:
                                                                              Curves.fastOutSlowIn,
                                                                          animationDuration:
                                                                              Duration(milliseconds: 300),
                                                                          twoTouchOnly:
                                                                              true,
                                                                          onScaleStart:
                                                                              () {},
                                                                          onScaleStop:
                                                                              () {},
                                                                          child:
                                                                              FancyShimmerImage(
                                                                            imageUrl:
                                                                                URLIMAGE + Images[imageSelected],
                                                                            boxFit:
                                                                                BoxFit.cover,
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.4,
                                                                            errorWidget: Container(
                                                                              width: double.infinity,
                                                                              height: MediaQuery.of(context).size.height * 0.4,
                                                                              color: Colors.grey[300],
                                                                              child: Icon(
                                                                                Icons.broken_image_outlined,
                                                                                size: 80,
                                                                                color: Colors.grey[400],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )).toList(),
                                                              autoPlayInterval:
                                                                  60000000,
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.transparent,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .close,
                                                            color: Colors.white,
                                                            size: isTablet
                                                                ? 50
                                                                : 25,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            try {
                                                              try {
                                                                final ok =
                                                                    await saveImageToGallery(
                                                                  URLIMAGE +
                                                                      Images[
                                                                          imageSelected],
                                                                  name:
                                                                      "trust_${DateTime.now().millisecondsSinceEpoch}.jpg",
                                                                );
                                                                if (ok) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg: AppLocalizations.of(
                                                                            context)!
                                                                        .downloaded_successfully,
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG,
                                                                  );
                                                                } else {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg: AppLocalizations.of(
                                                                            context)!
                                                                        .downloaded_failed,
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG,
                                                                  );
                                                                }
                                                              } catch (_) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg: AppLocalizations.of(
                                                                          context)!
                                                                      .downloaded_failed,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                );
                                                              }
                                                            } catch (e) {
                                                              Fluttertoast.showToast(
                                                                  msg: AppLocalizations
                                                                          .of(
                                                                              context)!
                                                                      .downloaded_failed,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            }
                                                          },
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .fileDownload,
                                                            color: Colors.white,
                                                            size: isTablet
                                                                ? 50
                                                                : 25,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      List<String> resultList = [];
                                      List<Silder> album = colors!
                                          .map((s) => Silder.fromJson(s))
                                          .toList();
                                      if (imagewithout.isNotEmpty) {
                                        // Check if the imageString is in the expected format
                                        if (imagewithout.startsWith("[") &&
                                            imagewithout.endsWith("]")) {
                                          resultList =
                                              (jsonDecode(imagewithout) as List)
                                                  .map((item) => item as String)
                                                  .toList();
                                        } else {
                                          imagewithout = "";
                                        }
                                      }

                                      Silder newItem = Silder(
                                          image: resultList[0],
                                          product_id: "0");
                                      album.insert(0, newItem);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.all(0),
                                            child: Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: Colors.transparent,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                          child: StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      setState) {
                                                            return ImageSlideshow(
                                                              width: double
                                                                  .infinity,
                                                              initialPage:
                                                                  imageSelected,
                                                              onPageChanged:
                                                                  (_) {
                                                                imageSelected =
                                                                    _;

                                                                setState(() {});
                                                              },
                                                              indicatorColor:
                                                                  MAIN_COLOR,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.6,
                                                              children: album
                                                                  .map((e) =>
                                                                      InkWell(
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            ZoomOverlay(
                                                                          modalBarrierColor:
                                                                              Colors.black12,
                                                                          minScale:
                                                                              0.5,
                                                                          maxScale:
                                                                              3.0,
                                                                          animationCurve:
                                                                              Curves.fastOutSlowIn,
                                                                          animationDuration:
                                                                              Duration(milliseconds: 300),
                                                                          twoTouchOnly:
                                                                              true,
                                                                          onScaleStart:
                                                                              () {},
                                                                          onScaleStop:
                                                                              () {},
                                                                          child:
                                                                              FancyShimmerImage(
                                                                            imageUrl:
                                                                                URLIMAGE + e.image,
                                                                            boxFit:
                                                                                BoxFit.cover,
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.6,
                                                                            errorWidget: Container(
                                                                              width: double.infinity,
                                                                              height: MediaQuery.of(context).size.height * 0.6,
                                                                              color: Colors.grey[300],
                                                                              child: Icon(
                                                                                Icons.broken_image_outlined,
                                                                                size: 80,
                                                                                color: Colors.grey[400],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              autoPlayInterval:
                                                                  60000000,
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.transparent,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .close,
                                                            color: Colors.white,
                                                            size: isTablet
                                                                ? 50
                                                                : 25,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            try {
                                                              try {
                                                                final ok =
                                                                    await saveImageToGallery(
                                                                  URLIMAGE +
                                                                      album[imageSelected]
                                                                          .image, // URL or local path
                                                                  name:
                                                                      "trust_${DateTime.now().millisecondsSinceEpoch}.jpg",
                                                                );
                                                                if (ok) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg: AppLocalizations.of(
                                                                            context)!
                                                                        .downloaded_successfully,
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG,
                                                                  );
                                                                } else {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg: AppLocalizations.of(
                                                                            context)!
                                                                        .downloaded_failed,
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG,
                                                                  );
                                                                }
                                                              } catch (_) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg: AppLocalizations.of(
                                                                          context)!
                                                                      .downloaded_failed,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                );
                                                              }
                                                            } catch (e) {
                                                              print("e");
                                                              print(e);
                                                              Fluttertoast.showToast(
                                                                  msg: AppLocalizations
                                                                          .of(
                                                                              context)!
                                                                      .downloaded_failed,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .BOTTOM,
                                                                  timeInSecForIosWeb:
                                                                      1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            }
                                                          },
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .fileDownload,
                                                            color: Colors.white,
                                                            size: isTablet
                                                                ? 50
                                                                : 25,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    List<String> resultList = [];
                                    List<Silder> album = colors!
                                        .map((s) => Silder.fromJson(s))
                                        .toList();
                                    if (imagewithout.isNotEmpty) {
                                      // Check if the imageString is in the expected format
                                      if (imagewithout.startsWith("[") &&
                                          imagewithout.endsWith("]")) {
                                        resultList =
                                            (jsonDecode(imagewithout) as List)
                                                .map((item) => item as String)
                                                .toList();
                                      } else {
                                        imagewithout = "";
                                      }
                                    }

                                    Silder newItem = Silder(
                                        image: resultList[0], product_id: "0");
                                    album.insert(0, newItem);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: EdgeInsets.all(0),
                                          child: Stack(
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Center(
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                          width:
                                                              double.infinity,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                          child: ZoomOverlay(
                                                            modalBarrierColor:
                                                                Colors.black12,
                                                            minScale: 0.5,
                                                            maxScale: 3.0,
                                                            animationCurve: Curves
                                                                .fastOutSlowIn,
                                                            animationDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        300),
                                                            twoTouchOnly: true,
                                                            onScaleStart: () {},
                                                            onScaleStop: () {},
                                                            child:
                                                                Image.network(
                                                              image,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .close,
                                                          color: Colors.white,
                                                          size: isTablet
                                                              ? 50
                                                              : 25,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          try {
                                                            try {
                                                              final ok =
                                                                  await saveImageToGallery(
                                                                image, // URL or local path
                                                                name:
                                                                    "trust_${DateTime.now().millisecondsSinceEpoch}.jpg",
                                                              );
                                                              if (ok) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg: AppLocalizations.of(
                                                                          context)!
                                                                      .downloaded_successfully,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                );
                                                              } else {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg: AppLocalizations.of(
                                                                          context)!
                                                                      .downloaded_failed,
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                );
                                                              }
                                                            } catch (_) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg: AppLocalizations.of(
                                                                        context)!
                                                                    .downloaded_failed,
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                              );
                                                            }
                                                          } catch (e) {
                                                            Fluttertoast.showToast(
                                                                msg: AppLocalizations.of(
                                                                        context)!
                                                                    .downloaded_failed,
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          }
                                                        },
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .fileDownload,
                                                          color: Colors.white,
                                                          size: isTablet
                                                              ? 50
                                                              : 25,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              )),
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ], shape: BoxShape.circle, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 15, right: 15),
                        child: Row(
                          children: [
                            Visibility(
                              visible: ROLEID == "3" ? true : false,
                              child: InkWell(
                                onTap: () {
                                  showDialogToAddToCart(
                                    SIZES_EN: SIZES_EN,
                                    SIZES_AR: SIZES_AR,
                                    SIZESIDs: SIZESIDs,
                                    category_id: widget.category_id,
                                    colors: colors,
                                    context: context,
                                    image: URLIMAGE + Images[0],
                                    product_id: widget.product_id,
                                    selectedSize: selectedSize,
                                    cartProvider: cartProvider,
                                    name_ar: name_ar,
                                    name_en: name_en,
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Center(
                                      child: FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: Colors.black,
                                  )),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: ROLEID == "3" ? true : false,
                              child: SizedBox(
                                width: 20,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final favoriteProvider =
                                    Provider.of<FavouriteProvider>(context,
                                        listen: false);
                                bool isFavorite = favoriteProvider
                                    .isProductFavorite(widget.product_id);
                                if (isFavorite) {
                                  await favoriteProvider
                                      .removeFromFavorite(widget.product_id);
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .fav_deleted_successfully,
                                  );
                                } else {
                                  final newItem = FavoriteItem(
                                    productId: widget.product_id,
                                    categoryID: widget.category_id,
                                    name: widget.name,
                                    image: URLIMAGE + Images[0],
                                  );
                                  await favoriteProvider.addToFavorite(newItem);
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .fav_added_successfully,
                                  );
                                }
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                child: Center(
                                  child: Consumer<FavouriteProvider>(
                                    builder: (context, favoriteProvider, _) {
                                      bool isFavorite = favoriteProvider
                                          .isProductFavorite(widget.product_id);
                                      return SvgPicture.asset(
                                        isFavorite
                                            ? "assets/images/in_favorite.svg"
                                            : "assets/images/add_to_favorite.svg",
                                        color: Colors.black,
                                        fit: BoxFit.cover,
                                        width: 30,
                                        height: 30,
                                      );
                                    },
                                  ),
                                ),
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ], shape: BoxShape.circle, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Visibility(
                visible: video.toString() == "" || video.toString() == "[]"
                    ? false
                    : true,
                child: InkWell(
                  onTap: () {
                    NavigatorPushFunction(
                        context,
                        VideoPlayerPage(
                          videoUrl: URLIMAGE + video,
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Container(
                      height: 35,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: locale.toString() == "ar"
                              ? BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  bottomRight: Radius.circular(40))
                              : BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomLeft: Radius.circular(40))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Video",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: MAIN_COLOR),
                          ),
                          Image.asset(
                            "assets/images/play-button.png",
                            height: 15,
                            width: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: getLanguage()));
                Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!.copied_successfully,
                    backgroundColor: Colors.green);
              },
              child: Text(
                getLanguage(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MAIN_COLOR,
                    fontSize: 18),
              ),
            ),
          ),
          ProductDescription(
            description:
                locale.toString() == "ar" ? descriptionAR : descriptionEN,
            locale: locale.toString(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: number));
                Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!.copied_successfully,
                    backgroundColor: Colors.green);
              },
              child: Text(
                number,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MAIN_COLOR,
                    fontSize: 18),
              ),
            ),
          ),
          Visibility(
            visible: sizes!.length == 0 ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
              child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: sizes.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    // Safely extract size data with type checking
                    String sizeText = "";
                    try {
                      if (locale.toString() == "ar") {
                        var translations = sizes[index]["translations"];
                        if (translations != null && translations is List && translations.isNotEmpty) {
                          var value = translations[0]["value"];
                          sizeText = value?.toString() ?? "";
                        }
                      } else {
                        var title = sizes[index]["title"];
                        sizeText = title?.toString() ?? "";
                      }
                    } catch (e) {
                      debugPrint('Error extracting size text: $e');
                      sizeText = "-";
                    }
                    
                    return Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.first_size} $sizeText",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      ],
                    );
                  }),
            ),
          ),
          Visibility(
            visible: colors!.length == 0 ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
              child: Text(
                AppLocalizations.of(context)!.colors,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MAIN_COLOR,
                    fontSize: 18),
              ),
            ),
          ),
          Visibility(
            visible: colors.length == 0 ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
              child: Container(
                width: double.infinity,
                height: 160,
                child: ListView.builder(
                  cacheExtent: 50,
                  itemCount: colors.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {
                    return InkWell(
                      onTap: () {
                        int imageSelected = index + 1;
                        List<String> resultList = [];
                        List<Silder> album =
                            colors.map((s) => Silder.fromJson(s)).toList();
                        if (imagewithout.isNotEmpty) {
                          // Check if the imageString is in the expected format
                          if (imagewithout.startsWith("[") &&
                              imagewithout.endsWith("]")) {
                            resultList = (jsonDecode(imagewithout) as List)
                                .map((item) => item as String)
                                .toList();
                          } else {
                            imagewithout = "";
                          }
                        }

                        Silder newItem =
                            Silder(image: resultList[0], product_id: "0");
                        album.insert(0, newItem);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.all(0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            child: ImageSlideshow(
                                              width: double.infinity,
                                              initialPage: imageSelected,
                                              onPageChanged: (_) {
                                                imageSelected = _;
                                              },
                                              indicatorColor: MAIN_COLOR,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              children: album
                                                  .map((e) => InkWell(
                                                        onTap: () {},
                                                        child: ZoomOverlay(
                                                          modalBarrierColor:
                                                              Colors.black12,
                                                          minScale: 0.5,
                                                          maxScale: 3.0,
                                                          animationCurve: Curves
                                                              .fastOutSlowIn,
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      300),
                                                          twoTouchOnly: true,
                                                          onScaleStart: () {},
                                                          onScaleStop: () {},
                                                          child:
                                                              FancyShimmerImage(
                                                            imageUrl: URLIMAGE +
                                                                e.image,
                                                            boxFit:
                                                                BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.4,
                                                            errorWidget: Container(
                                                              width: double.infinity,
                                                              height: MediaQuery.of(context).size.height * 0.4,
                                                              color: Colors.grey[300],
                                                              child: Icon(
                                                                Icons.broken_image_outlined,
                                                                size: 80,
                                                                color: Colors.grey[400],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              autoPlayInterval: 600000,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.close,
                                              color: Colors.white,
                                              size: isTablet ? 50 : 25,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              try {
                                                try {
                                                  final ok =
                                                      await saveImageToGallery(
                                                    image, // URL or local path
                                                    name:
                                                        "trust_${DateTime.now().millisecondsSinceEpoch}.jpg",
                                                  );
                                                  if (ok) {
                                                    Fluttertoast.showToast(
                                                      msg: AppLocalizations.of(
                                                              context)!
                                                          .downloaded_successfully,
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg: AppLocalizations.of(
                                                              context)!
                                                          .downloaded_failed,
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                    );
                                                  }
                                                } catch (_) {
                                                  Fluttertoast.showToast(
                                                    msg: AppLocalizations.of(
                                                            context)!
                                                        .downloaded_failed,
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                  );
                                                }
                                              } catch (e) {
                                                Fluttertoast.showToast(
                                                    msg: AppLocalizations.of(
                                                            context)!
                                                        .downloaded_failed,
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 3,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.fileDownload,
                                              color: Colors.white,
                                              size: isTablet ? 50 : 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: 140,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        // Safely extract color image with type checking
                                        String colorImage = "";
                                        try {
                                          var imageData = colors[index]["image"];
                                          if (imageData != null) {
                                            if (imageData is String) {
                                              colorImage = imageData;
                                            } else if (imageData is Map) {
                                              colorImage = imageData["url"]?.toString() ?? 
                                                         imageData["path"]?.toString() ?? "";
                                            }
                                          }
                                        } catch (e) {
                                          debugPrint('Error extracting color image: $e');
                                        }
                                        
                                        return Image.network(
                                          URLIMAGE + colorImage,
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: 130,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 150,
                                              width: 130,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.image_not_supported, color: Colors.grey),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Container(
                                      height: 150,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color.fromARGB(183, 24, 24, 24),
                                            Color.fromARGB(45, 0, 0, 0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                // Safely extract color title with type checking
                                String colorTitle = "";
                                try {
                                  if (locale.toString() == "ar") {
                                    var translations = colors[index]["translations"];
                                    if (translations != null && translations is List && translations.isNotEmpty) {
                                      var value = translations[0]["value"];
                                      colorTitle = value?.toString() ?? "";
                                    }
                                  } else {
                                    var title = colors[index]["title"];
                                    colorTitle = title?.toString() ?? "";
                                  }
                                } catch (e) {
                                  debugPrint('Error extracting color title: $e');
                                  colorTitle = "-";
                                }
                                
                                return Text(
                                  colorTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: sizes.length == 0 ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
              child: Text(
                AppLocalizations.of(context)!.available_sizes,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MAIN_COLOR,
                    fontSize: 18),
              ),
            ),
          ),
          Visibility(
            visible: sizes.length == 0 ? false : true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sizes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3.2,
                  ),
                  itemBuilder: (context, int index) {
                    // Safely extract size data with type checking
                    String sizeTitle = "";
                    String sizeNumber = "-";
                    
                    try {
                      if (locale.toString() == "ar") {
                        var translations = sizes[index]["translations"];
                        if (translations != null && translations is List && translations.isNotEmpty) {
                          var value = translations[0]["value"];
                          sizeTitle = value?.toString() ?? "";
                        }
                      } else {
                        var title = sizes[index]["title"];
                        sizeTitle = title?.toString() ?? "";
                      }
                      
                      var number = sizes[index]["number"];
                      sizeNumber = number?.toString() ?? "-";
                    } catch (e) {
                      debugPrint('Error extracting size data: $e');
                      sizeTitle = "-";
                      sizeNumber = "-";
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              sizeTitle,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              sizeNumber,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  TextEditingController SuggestionController =
                      TextEditingController();
                  TextEditingController EmailController =
                      TextEditingController();
                  TextEditingController NameController =
                      TextEditingController();
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          // NEW: lift dialog above keyboard
                          AnimatedPadding(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Material(
                                      color: Color.fromARGB(198, 0, 0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        // NEW: make body scrollable to avoid overflow
                                        child: SingleChildScrollView(
                                          keyboardDismissBehavior:
                                              ScrollViewKeyboardDismissBehavior
                                                  .onDrag,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .explanation,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 20),
                                              Visibility(
                                                visible: login ? false : true,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 220,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .contact_email,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Container(
                                                        height: 50,
                                                        width: 220,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255, 9, 9, 9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          controller:
                                                              NameController,
                                                          obscureText: false,
                                                          maxLines: 50,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: login ? false : true,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 220,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .name_contact,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Container(
                                                        height: 50,
                                                        width: 220,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255, 9, 9, 9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          controller:
                                                              EmailController,
                                                          obscureText: false,
                                                          maxLines: 50,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    width: 220,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .explanation,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Container(
                                                      height: 100,
                                                      width: 220,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 9, 9, 9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        controller:
                                                            SuggestionController,
                                                        obscureText: false,
                                                        maxLines: 50,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ButtonWidget(
                                                  name: AppLocalizations.of(
                                                          context)!
                                                      .send,
                                                  height: 30,
                                                  width: 90,
                                                  BorderColor: MAIN_COLOR,
                                                  FontSize: 12,
                                                  OnClickFunction: () async {
                                                    if (SuggestionController
                                                            .text !=
                                                        "") {
                                                      final SharedPreferences
                                                          prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      String? name = await prefs
                                                          .getString('name');
                                                      String? email =
                                                          await prefs.getString(
                                                              'email');
                                                      sendMassageRequest(
                                                          SuggestionController
                                                              .text,
                                                          widget.name,
                                                          login
                                                              ? email
                                                              : EmailController
                                                                  .text,
                                                          login
                                                              ? name
                                                              : NameController
                                                                  .text,
                                                          context);
                                                    } else {}
                                                  },
                                                  BorderRaduis: 20,
                                                  ButtonColor: MAIN_COLOR,
                                                  NameColor: Colors.white)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Colors.white,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: FaIcon(
                    FontAwesomeIcons.message,
                    size: 25,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: 180,
                  decoration: BoxDecoration(
                      color: MAIN_COLOR,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          String modifiedUrl = modifyURL(
                              "https://redtrust.ps/$ShareUrl/${slug}");

                          Share.share(modifiedUrl);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.share,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          String shareUrl =
                              "https://redtrust.ps/$ShareUrl/${slug}";
                          String facebookUrl =
                              "https://www.facebook.com/sharer/sharer.php?u=$shareUrl";
                          if (await canLaunch(facebookUrl)) {
                            await launch(facebookUrl);
                          } else {
                            // If the Facebook app is not installed, open in a browser
                            await launch(facebookUrl);
                          }
                        },
                        child: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          String modifiedUrl = modifyURL(
                              "https://redtrust.ps/$ShareUrl/${slug}");

                          String encodedMessage = Uri.encodeFull(modifiedUrl);
                          String whatsappUrl =
                              "https://wa.me/?text=$encodedMessage";

                          if (await canLaunch(whatsappUrl)) {
                            await launch(whatsappUrl);
                          } else {
                            await launch(whatsappUrl);
                          }
                        },
                        child: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          FutureBuilder(
            future: getRelatedProducts(widget.product_id, widget.category_id),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: const Color.fromARGB(0, 104, 104, 104),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.related_products,
                              style: TextStyle(color: MAIN_COLOR, fontSize: 17),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 5, left: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 150,
                                  width: 130,
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 196, 196, 196),
                                    highlightColor: const Color.fromARGB(
                                        255, 129, 129, 129),
                                    child: Container(
                                      height: 150,
                                      width: 130,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              } else {
                if (snapshot.data != null) {
                  var products = snapshot.data;

                  return Container(
                    color: const Color.fromARGB(0, 104, 104, 104),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.related_products,
                                style:
                                    TextStyle(color: MAIN_COLOR, fontSize: 17),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: isTablet ? 300 : 150,
                          child: ListView.builder(
                              cacheExtent: 15,
                              itemCount: products.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, int index) {
                                // Safely extract image data with type checking
                                String imageUrl = 'assets/images/icon.png';
                                try {
                                  var imageData = products[index]["image"];
                                  
                                  if (imageData != null) {
                                    if (imageData is String && imageData.isNotEmpty) {
                                      // Check if it's a JSON array string
                                      if (imageData.startsWith("[") && imageData.endsWith("]")) {
                                        try {
                                          var resultList = (jsonDecode(imageData) as List)
                                              .map((item) => item.toString())
                                              .toList();
                                          if (resultList.isNotEmpty) {
                                            imageUrl = resultList[0];
                                          }
                                        } catch (e) {
                                          debugPrint('Error decoding image JSON: $e');
                                          imageUrl = imageData;
                                        }
                                      } else {
                                        imageUrl = imageData;
                                      }
                                    } else if (imageData is Map) {
                                      // Handle case where image is a Map
                                      imageUrl = imageData["url"]?.toString() ?? 
                                               imageData["path"]?.toString() ?? 
                                               'assets/images/icon.png';
                                    } else if (imageData is List && imageData.isNotEmpty) {
                                      // Handle case where image is already a List
                                      imageUrl = imageData[0].toString();
                                    }
                                  }
                                } catch (e) {
                                  debugPrint('Error extracting related product image: $e');
                                  imageUrl = 'assets/images/icon.png';
                                }
                                
                                // Safely extract product name with type checking
                                String productName = "";
                                try {
                                  if (locale.toString() == "ar") {
                                    var translations = products[index]["translations"];
                                    if (translations != null && translations is List && translations.isNotEmpty) {
                                      var value = translations[0]["value"];
                                      productName = value?.toString() ?? "";
                                    }
                                  }
                                  
                                  if (productName.isEmpty) {
                                    var name = products[index]["name"];
                                    productName = name?.toString() ?? "";
                                  }
                                } catch (e) {
                                  debugPrint('Error extracting related product name: $e');
                                  productName = "Product";
                                }

                                return InkWell(
                                  onTap: () {
                                    try {
                                      int categoryId = 0;
                                      var catId = products[index]["categoryId"] ?? products[index]["category_id"];
                                      if (catId is int) {
                                        categoryId = catId;
                                      } else if (catId != null) {
                                        categoryId = int.tryParse(catId.toString()) ?? 0;
                                      }
                                      
                                      int productId = 0;
                                      var prodId = products[index]["id"];
                                      if (prodId is int) {
                                        productId = prodId;
                                      } else if (prodId != null) {
                                        productId = int.tryParse(prodId.toString()) ?? 0;
                                      }
                                      
                                      NavigatorPushFunction(
                                          context,
                                          ProductScreen(
                                              name: productName,
                                              category_id: categoryId,
                                              image: imageUrl,
                                              product_id: productId));
                                    } catch (e) {
                                      debugPrint('Error navigating to related product: $e');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: isTablet ? 230 : 150,
                                          width: isTablet ? 230 : 130,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Stack(
                                              children: [
                                                FancyShimmerImage(
                                                  imageUrl: URLIMAGE + imageUrl,
                                                  errorWidget: Image.asset(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                    height:
                                                        isTablet ? 230 : 150,
                                                    width: isTablet ? 230 : 130,
                                                  ),
                                                ),
                                                Container(
                                                  height: isTablet ? 230 : 150,
                                                  width: isTablet ? 230 : 130,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color.fromARGB(
                                                            183, 0, 0, 0),
                                                        Color.fromARGB(
                                                            45, 0, 0, 0)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          child: Center(
                                            child: Builder(
                                              builder: (context) {
                                                // Safely extract and format product name for display
                                                String displayName = "";
                                                try {
                                                  if (locale.toString() == "ar") {
                                                    var translations = products[index]["translations"];
                                                    if (translations != null && translations is List && translations.isNotEmpty) {
                                                      var value = translations[0]["value"];
                                                      String translatedName = value?.toString() ?? "";
                                                      
                                                      // Check if it starts with HTML tag
                                                      if (translatedName.startsWith("<")) {
                                                        var name = products[index]["name"];
                                                        displayName = name?.toString() ?? "";
                                                      } else {
                                                        displayName = translatedName;
                                                      }
                                                    } else {
                                                      var name = products[index]["name"];
                                                      displayName = name?.toString() ?? "";
                                                    }
                                                  } else {
                                                    var name = products[index]["name"];
                                                    displayName = name?.toString() ?? "";
                                                  }
                                                  
                                                  // Truncate for non-tablet if needed
                                                  if (!isTablet && displayName.length > 10) {
                                                    displayName = displayName.substring(0, 10);
                                                  }
                                                } catch (e) {
                                                  debugPrint('Error formatting related product name: $e');
                                                  displayName = "Product";
                                                }
                                                
                                                return Text(
                                                  displayName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    color: Colors.white,
                  );
                }
              }
            },
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }

  Widget ProductDescription(
      {required String description, required String locale}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale == "ar" ? "الوصف" : "Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MAIN_COLOR,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Html(
              data: locale == "ar"
                  ? "<div dir='rtl'>$description</div>"
                  : description,
              style: {
                "ul": Style(
                  padding: HtmlPaddings.all(10),
                  color: Colors.black,
                ),
                "ol": Style(
                  fontSize: FontSize.large,
                  direction:
                      locale == "ar" ? TextDirection.rtl : TextDirection.ltr,
                  padding: HtmlPaddings.all(10),
                ),
                "li": Style(
                  fontSize: FontSize.large,
                ),
                "p": Style(
                  fontSize: FontSize.medium,
                  margin: Margins.only(bottom: 10),
                  color: Colors.grey[800],
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  String modifyURL(String url) {
    List<String> urlParts = url.split('/');
    String lastPart = urlParts.last;
    List<String> nameParts = lastPart.split(' ');
    if (nameParts.length > 1) {
      String modifiedName = nameParts.join('-');
      modifiedName = modifiedName.replaceAll(' ', '');
      urlParts[urlParts.length - 1] = modifiedName;
      urlParts.insert(urlParts.length - 1, 'en');
    }

    return urlParts.join('/');
  }
}
