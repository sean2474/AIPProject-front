import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'games_to_display.dart';
import 'favorite_sports_setting.dart';
import 'package:front/widgets/assets.dart';

class SettingPage extends StatefulWidget {
  final List<String> sportsList;
  final VoidCallback onDialogClosed;

  const SettingPage({Key? key, required this.sportsList, required this.onDialogClosed }) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  Map<String, bool> selectedCards = {};

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
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
                ListTile(
                  title: const Text('Upcoming Games To Display'),
                  trailing: const Icon(Icons.display_settings_rounded, color: Colors.grey),
                  onTap: () {
                    showModalBottomSheet(
                      context: context, 
                      isScrollControlled: true, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                      ),
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 320,
                          child: GamesToDisplayPage(
                            gamesToDisplay: Data.settings.upcomingGamesToShow,
                            text: 'Upcoming Games To Display',
                            onChange: (value) {
                              setState(() {
                                Data.settings.upcomingGamesToShow = value;
                              });
                              widget.onDialogClosed();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                Assets().getDivider(context),
                ListTile(
                  title: const Text('Recent Games To Display'),
                  trailing: const Icon(Icons.display_settings_rounded, color: Colors.grey),
                  onTap: () {
                    showModalBottomSheet(
                      context: context, 
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                      ),
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 320,
                          child: GamesToDisplayPage(
                            gamesToDisplay: Data.settings.recentGamesToShow,
                            text: 'Recent Games To Display',
                            onChange: (value) {
                              setState(() {
                                Data.settings.recentGamesToShow = value;
                              });
                              widget.onDialogClosed();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                Assets().getDivider(context),
                ListTile(
                  title: const Text('Favorite Sports'),
                  trailing: const Icon(Icons.star_border_rounded, color: Colors.yellow),
                  onTap: () {
                    showModalBottomSheet(
                      context: context, 
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                      ),
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 730,
                          child: StarredSportsSettingPage(
                            sportsList: widget.sportsList,
                            onDialogClosed: widget.onDialogClosed,
                            onChange: (value) {
                              setState(() {
                                Data.settings.starredSports = value;
                              });
                              widget.onDialogClosed();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
