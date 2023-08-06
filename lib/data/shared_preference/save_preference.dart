import 'package:front/data/settings.dart';
import 'package:front/data/user_.dart';

import 'shared_preference_storage.dart';
import 'shared_preference_keys.dart';

class Save {
  static Future<void> themeModeAuto(bool isThemeModeAuto) async {
    saveValue(SharedPreferenceKeys.isThemeModeAuto, isThemeModeAuto.toString());
  }
  static Future<void> darkMode(bool isDarkMode) async {
    saveValue(SharedPreferenceKeys.isDarkMode, isDarkMode.toString());
  }

  static Future<void> recentGamesToShow(int recentGames) async {
    saveValue(SharedPreferenceKeys.numbersOfRecentGamesResultToShow, recentGames.toString());
  }

  static Future<void> upcomingGamesToShow(int upcomingGames) async {
    saveValue(SharedPreferenceKeys.numbersOfUpcomingGamesResultToShow, upcomingGames.toString());
  }

  static Future<void> sortLostAndFoundBy(String sort) async {
    saveValue(SharedPreferenceKeys.sortLostAndFoundBy, sort);
  }

  static Future<void> showReturnedItemsInLostAndFound(bool show) async {
    saveValue(SharedPreferenceKeys.showReturnedItemsInLostAndFound, show.toString());
  }

  static Future<void> starredSports(List<String> sports) async {
    saveValue(SharedPreferenceKeys.starredSports, sports.join(' '));
  }

  static Future<void> dailyScheduleTimelineMode(bool isDailyScheduleTimelineMode) async {
    saveValue(SharedPreferenceKeys.isDailyScheduleTimelineMode, isDailyScheduleTimelineMode.toString());
  }

  static Future<void> user(User_ user) async {
    saveValue(SharedPreferenceKeys.username, user.email);
    saveValue(SharedPreferenceKeys.userPassword, user.password);
  }

  static Future<void> settings(Settings settings) async {
    recentGamesToShow(settings.recentGamesToShow);
    upcomingGamesToShow(settings.upcomingGamesToShow);
    starredSports(settings.starredSports.split(" "));
    sortLostAndFoundBy(settings.sortLostAndFoundBy);
    dailyScheduleTimelineMode(settings.isDailyScheduleTimelineMode);
    showReturnedItemsInLostAndFound(settings.showReturnedItem);
    themeModeAuto(settings.isThemeModeAuto);
    darkMode(settings.isDarkMode);
  }
}