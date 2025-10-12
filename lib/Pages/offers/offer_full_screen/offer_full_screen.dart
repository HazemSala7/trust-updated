import 'package:flutter/material.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Server/domains/domains.dart';

import '../../../Components/app_bar_widget/app_bar_widget.dart';
import '../../../Components/drawer_widget/drawer_widget.dart';

class OfferFullScreen extends StatefulWidget {
  final image, name, desc;
  const OfferFullScreen({super.key, this.image, this.name, this.desc});

  @override
  State<OfferFullScreen> createState() => OoffeFfulSscreenState();
}

class OoffeFfulSscreenState extends State<OfferFullScreen> {
  @override
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
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: Image.network(
                      URLIMAGE + widget.image,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBarWidget(logo: true),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
