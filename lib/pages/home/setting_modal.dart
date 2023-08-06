import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/model_theme.dart';
import 'package:front/widgets/assets.dart';
import 'package:provider/provider.dart';

import 'switch.dart';

class SettingModal extends StatefulWidget {
  const SettingModal({super.key});

  @override
  SettingModalState createState() => SettingModalState();
}

class SettingModalState extends State<SettingModal> {
  bool isThemeModeAuto = Data.settings.isThemeModeAuto;
  bool isDarkMode = Data.settings.isDarkMode;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return FractionallySizedBox(
          heightFactor: 0.37,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets().buttomSheetModalTopline(),
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: colorScheme.background,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SwitchWidget(
                        value: !isThemeModeAuto,
                        onSwitchChange: (bool value) {
                          setState(() {
                            isThemeModeAuto = !value;
                            Data.settings.isThemeModeAuto = isThemeModeAuto;
                            themeNotifier.isAuto = isThemeModeAuto;
                          });
                        },
                        text: "Manual Theme Mode",
                      ),
                      Assets().getDivider(context),
                      SwitchWidget(
                        value: isDarkMode,
                        onSwitchChange: (bool value) {
                          setState(() {
                            isDarkMode = value;
                            Data.settings.isDarkMode = isDarkMode;
                            themeNotifier.isDark = isDarkMode;
                          });
                        },
                        text: "Dark Mode",
                        disabled: isThemeModeAuto,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
