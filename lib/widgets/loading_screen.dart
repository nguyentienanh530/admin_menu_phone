import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '../utils/utils.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(child: SpinKitCircle(color: kAccentColor, size: 30));
    return const Center(child: CupertinoActivityIndicator());
  }
}
