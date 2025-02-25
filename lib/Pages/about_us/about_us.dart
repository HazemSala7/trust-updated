import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:trust_app_updated/main.dart';
import '../../Components/app_bar_widget/app_bar_widget.dart';
import '../../Components/bottom_bar_widget/bottom_bar_widget.dart';
import '../../Components/drawer_widget/drawer_widget.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  int _currentIndex = 0;
  bool isTablet = false;
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Stack(
          alignment: locale.toString() == "ar"
              ? Alignment.topRight
              : Alignment.topLeft,
          children: [
            Scaffold(
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
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      color: MAIN_COLOR,
                      child: Center(
                        child: Image.asset(
                          "assets/images/logo_white.png",
                          width: MediaQuery.of(context).size.width - 100,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        AppLocalizations.of(context)!.about_well,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FutureBuilder(
                          future: getAboutUs(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return AboutUsContent("");
                            } else {
                              if (snapshot.data != null) {
                                return AboutUsContent(locale.toString() == "ar"
                                    ? snapshot.data["translations"][0]["value"]
                                    : snapshot.data["body"]);
                              } else {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: double.infinity,
                                  color: Colors.white,
                                );
                              }
                            }
                          }),
                    )
                  ],
                );
              }),
            ),
            IconButton(
              onPressed: () {
                _scaffoldState.currentState?.openDrawer();
              },
              icon: SvgPicture.asset(
                "assets/images/iCons/Menu.svg",
                fit: BoxFit.cover,
                color: Colors.white,
                width: 25,
                height: 25,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget AboutUsContent(var _htmlContent) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          locale.toString() == "ar"
              ? "مع بداية كل موسم، تقدم شركة ترست  للأجهزة المنزلية مجموعة جديدة من الأجهزة المنزلية المبتكرة. تم تصميم منتجاتنا من قبل خبرائنا في العديد من البلدان، باستخدام مواد عالية الجودة لتناسب مجموعة متنوعة من المنازل، من التقليدية إلى العصرية. تلتزم ترست بتوزيع منتجاتها إلى العديد من المواقع، مع التركيز دائماً على تقديم قيمة استثنائية، وابتكار مستمر، وتجربة عملاء مميزة."
              : "At the start of every season, Red Trust Home Appliances introduces a new collection of innovative home appliances. Crafted by our expert designers from various countries, our products are made with top-quality materials to suit a diverse range of homes, from traditional to contemporary. Red Trust is dedicated to distributing its products to numerous locations, always committed to delivering exceptional value, continuous innovation, and an outstanding customer experience.",
          style: TextStyle(
              fontSize: isTablet ? 25 : 16, fontWeight: FontWeight.bold),
        )
        // Html(
        //   data: _htmlContent,
        //   style: {
        //     // p tag with text_size
        //     "p": Style(
        //       fontSize: isTablet ? FontSize(25) : FontSize(16),
        //     ),
        //     "span": Style(
        //         fontSize: isTablet ? FontSize(25) : FontSize(16),
        //         fontFamily: 'Tajawal'),
        //   },
        // )
        );
  }
}
