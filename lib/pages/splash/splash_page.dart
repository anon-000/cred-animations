import 'package:cred/pages/splash/widgets/animated_logo.dart';
import 'package:flutter/material.dart';

///
/// Created by Auro (auro@smarttersstudio.com) on 13/08/21 at 9:23 am
///

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff262626),
      body: Center(child: AnimatedLogo()),
    );
  }
}
