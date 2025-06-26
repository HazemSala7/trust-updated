import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trust_app_updated/main.dart';
import '../../../../Constants/constants.dart';

class AppBarLogin extends StatelessWidget {
  final title;
  const AppBarLogin({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
          alignment: locale.toString() == "ar"
              ? Alignment.centerRight
              : Alignment.centerLeft,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: MAIN_COLOR,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/images/iCons/Menu.svg",
                  fit: BoxFit.cover,
                  color: Colors.white,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ]),
    );
  }
}
