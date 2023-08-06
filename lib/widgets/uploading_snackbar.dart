import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';

/// should add scaffoldMessengerKey when you use this class
class UploadingSnackbar {
  final BuildContext context;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;
  final String message;
  final IconData icon;

  UploadingSnackbar(this.context, this._scaffoldMessengerKey, this.message, {this.icon = Icons.upload_rounded});
  void dismiss() {
    _scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
  }

  void showUploading() {
    final snackBar = SnackBar(
      duration: Duration(days: 365),
      backgroundColor: Colors.grey,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              message, 
              textAlign: TextAlign.center, 
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: lightColorScheme.onError,
              ),
            ),
            Icon(icon, color: Colors.white)
          ],
        )
      ),
      behavior: SnackBarBehavior.floating,
      shape: StadiumBorder(),
      width: MediaQuery.of(context).size.width * 0.35, 
    );
    _scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }

  void showUploadingResult(bool isSuccessful) {
    if (isSuccessful) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          content: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Success", 
                  textAlign: TextAlign.center, 
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.onError,
                  ),
                ),
                Icon(Icons.check_circle_outline, color: Colors.white),
              ],
            )
          ),
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
          width: MediaQuery.of(context).size.width * 0.35, 
        )
      );
    } else { 
      _scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: lightColorScheme.error,
          content: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Failed",  // changed to "failed"
                  textAlign: TextAlign.center, 
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.onError,
                  ),
                ),
                Icon(Icons.error_outline, color: lightColorScheme.onError), // change to an error icon
              ],
            )
          ),
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
          width: MediaQuery.of(context).size.width * 0.35,  
        )
      );
    }
  }
}