import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../Constants/constants.dart';

class AppBarLogin extends StatelessWidget {
  final title;
  const AppBarLogin({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(alignment: Alignment.centerLeft, children: [
        Container(
          width: double.infinity,
          height: 50,
          color: MAIN_COLOR,
          child: Center(
            child: Text(
              title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ))
      ]),
    );
  }
}
