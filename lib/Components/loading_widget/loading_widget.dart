import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  double heightLoading;
  LoadingWidget({
    Key? key,
    required this.heightLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: heightLoading,
        child: Center(
          child: SpinKitFadingCircle(
            color: Colors.black,
            size: 40.0,
          ),
        ));
  }
}
