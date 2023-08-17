import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:front/color_schemes.g.dart';

class LoadingPage extends StatelessWidget {
  final bool isDarkMode;
  LoadingPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? darkColorScheme.background : lightColorScheme.background,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: SpinKitWaveSpinner(
                color: Color.fromARGB(255, 140, 33, 49),
                trackColor: Color.fromARGB(255, 140, 33, 49),
                waveColor: Color.fromARGB(255, 140, 33, 49),
                size: 300,
              ),
            ),
            Center(child: Image.asset("assets/school_logo.png", height: 200)),
          ],
        ),
      ),
    );
  }
}
