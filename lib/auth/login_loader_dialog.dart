import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginLoaderDialog {
  static Future<void> show(BuildContext context, GlobalKey key, ColorScheme colorScheme) async {
    return showDialog<void> (
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SpinKitWaveSpinner(
            color: colorScheme.primary,
            trackColor: colorScheme.primaryContainer,
            waveColor: colorScheme.primary,
            size: 300,
          ),
        );
      },
    );
  }
}