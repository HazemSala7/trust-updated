import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import 'package:trust_app_updated/main.dart';
import 'package:url_launcher/url_launcher.dart';
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
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        color: MAIN_COLOR,
                        child: Center(
                          child: Image.asset(
                            "assets/images/About-Us-Photo (1).jpg",
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              locale.toString() == "ar"
                                  ? "من نحن"
                                  : "Who We Are",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: MAIN_COLOR,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AboutUsContent(
                            locale.toString() == "ar"
                                ? "في ريد ترست للأجهزة الكهربائية المنزلية، نضع الجودة والابتكار في قلب كل منتج نقدمه. باعتبارنا علامة تجارية متخصصة في الأجهزة المنزلية، نسعى إلى تلبية احتياجات عملائنا من خلال حلول عملية ومتطورة تناسب مختلف أنماط الحياة.\n\nيتم تصميم أجهزتنا وفقاً لأعلى المعايير، مع استخدام مواد متينة وتقنيات حديثة لضمان الأداء الفعّال والكفاءة العالية. ومن خلال شبكة توزيع واسعة، نوفّر منتجاتنا إلى العديد من الأسواق، ملتزمين بتقديم قيمة حقيقية وخدمة موثوقة تبني جسور الثقة مع عملائنا.\n\nمع ريد ترست، تحصل على أكثر من مجرد جهاز كهربائي – تحصل على شريك يعتمد عليه في كل تفاصيل حياتك اليومية."
                                : "At RED TRUST Home Appliances, quality & innovation are at the heart of every product we offer. As a specialized home appliance brand, we strive to meet our customers' needs by providing practical & advanced solutions that suit various lifestyles.\n\nOur appliances are designed according to the highest standards, using durable materials and cutting-edge technologies to ensure efficient performance and high reliability. With an extensive distribution network, we deliver our products to multiple markets, committed to offering real value and reliable service that fosters trust with our customers.\n\nWith RED TRUST, you get more than just a home appliance – you gain a reliable partner in every aspect of your daily life.",
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              locale.toString() == "ar"
                                  ? "ادارة الشركة"
                                  : "Company Management",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: MAIN_COLOR),
                            ),
                          ),
                          AboutUsContent(locale.toString() == "ar"
                              ? "يقود شركة ريد ترست للأجهزة الكهربائية فريق من المحترفين ذوي الخبرة في قطاع الأجهزة المنزلية، حيث يجمع بين الابتكار والخبرة لضمان تقديم منتجات عالية الجودة تلبي احتياجات الأسواق الحديثة. نحن نؤمن بأن النجاح يعتمد على بناء علاقات قوية مع شركائنا وعملائنا، ولهذا نلتزم بتطوير حلول موثوقة تسهم في تحسين جودة الحياة اليومية."
                              : "RED TRUST Home Appliances is led by a team of professionals with extensive experience in the home appliances sector. Combining innovation and expertise, we ensure the delivery of high-quality products that meet the demands of modern markets. We believe that success is built on strong relationships with our partners & customers, which is why we are committed to developing reliable solutions that enhance everyday life."),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              locale.toString() == "ar"
                                  ? "رؤيتـنـــا"
                                  : "Our Vision",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: MAIN_COLOR),
                            ),
                          ),
                          AboutUsContent(locale.toString() == "ar"
                              ? "أن نكون الخيار الأول في مجال الأجهزة الكهربائية المنزلية من خلال تقديم منتجات مبتكرة وموثوقة تجمع بين الأداء الفعّال والتصميم العصري، مع تعزيز تجربة العملاء من خلال الجودة والخدمة المتميزة."
                              : "To be the top choice in the home appliances industry by offering innovative & reliable products that combine high performance with modern design while enhancing customer experience through quality and exceptional service."),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              locale.toString() == "ar"
                                  ? "مهمتـنـــا"
                                  : "Our Mission",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: MAIN_COLOR),
                            ),
                          ),
                          AboutUsContent(locale.toString() == "ar"
                              ? "تقديم أجهزة كهربائية عالية الجودة تلبي تطلعات عملائنــا في الأداء والكـفــاءة. تعزيز الابتكـار المستمر لضمــان حلول عملية ومتطورة تنــاسب مختلــف المنـــازل. بناء شراكــات قويـة مع الموزعين لضمــان توافــر منتجاتـنـــا في مختلف الأســواق. الالتزام بمعـايير الاستدامة والجودة لضمـان تجربة مستخدم متميزة تدوم طويـلاً. توفير خدمة ما بعد البيع التي تضمن رضا العملاء من خلال الدعم الفني والصيانة وقطع الغيار الأصلية، مما يعزز الثقة في منتجاتنا ويضمن استمرارية الأداء المثالي لـهــــا."
                              : "Deliver high-quality home appliances that meet our customers' expectations for performance & efficiency.Foster continuous innovation to ensure practical & advanced solutions for various households.Build strong partnerships with distributors to ensure our products are available in multiple markets.Commit to sustainability & quality standards to provide an outstanding user experience that lasts.Offer exceptional after-sales service, including technical support, maintenance, & original spare parts, ensuring customer satisfaction and long-term product performance."),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              locale.toString() == "ar"
                                  ? "تابعونـــا"
                                  : "Follow Us",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final _url = Uri.parse(
                                        "https://www.facebook.com/share/18X4pBNabR/?mibextid=wwXIfr");
                                    if (!await launchUrl(_url,
                                        mode: LaunchMode.externalApplication)) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "لم يتم التمكن من الدخول الرابط , الرجاء المحاولة فيما بعد");
                                    }
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        "assets/images/path164.png"),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    final _url = Uri.parse(
                                        "https://www.linkedin.com/company/trustps/");
                                    if (!await launchUrl(_url,
                                        mode: LaunchMode.externalApplication)) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "لم يتم التمكن من الدخول الرابط , الرجاء المحاولة فيما بعد");
                                    }
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        "assets/images/path160.png"),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final _url = Uri.parse(
                                        "https://www.instagram.com/trust.homeps?igsh=eXBld3U4cGNzc203");
                                    if (!await launchUrl(_url,
                                        mode: LaunchMode.externalApplication)) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "لم يتم التمكن من الدخول الرابط , الرجاء المحاولة فيما بعد");
                                    }
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      "assets/images/inst-new-icon.png",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
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
        padding: const EdgeInsets.only(right: 25, top: 10, left: 15),
        child: Text(
          _htmlContent,
          style: TextStyle(fontSize: isTablet ? 25 : 12),
        ));
  }
}
