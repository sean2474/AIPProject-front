import 'package:front/data/data.dart';
import 'shared_preference_storage.dart';
import 'shared_preference_keys.dart';

class Save {
  static Future<void> themeModeAuto() async {
    saveValue(SharedPreferenceKeys.isThemeModeAuto, Data.settings.isThemeModeAuto.toString());
  }
  static Future<void> darkMode() async {
    saveValue(SharedPreferenceKeys.isDarkMode, Data.settings.isDarkMode.toString());
  }

  static Future<void> recentGamesToShow() async {
    saveValue(SharedPreferenceKeys.numbersOfRecentGamesResultToShow, Data.settings.recentGamesToShow.toString());
  }

  static Future<void> upcomingGamesToShow() async {
    saveValue(SharedPreferenceKeys.numbersOfUpcomingGamesResultToShow, Data.settings.upcomingGamesToShow.toString());
  }

  static Future<void> sortLostAndFoundBy() async {
    saveValue(SharedPreferenceKeys.sortLostAndFoundBy, Data.settings.sortLostAndFoundBy);
  }

  static Future<void> showReturnedItemsInLostAndFound() async {
    saveValue(SharedPreferenceKeys.showReturnedItemsInLostAndFound, Data.settings.showReturnedItem.toString());
  }

  static Future<void> starredSports() async {
    saveValue(SharedPreferenceKeys.starredSports, Data.settings.starredSports);
  }

  static Future<void> dailyScheduleTimelineMode() async {
    saveValue(SharedPreferenceKeys.isDailyScheduleTimelineMode, Data.settings.isDailyScheduleTimelineMode.toString());
  }

  static Future<void> deletedSchedules() async {
    saveValue(SharedPreferenceKeys.deletedSchedules, Data.settings.deletedSchedules.join('|'));
  }

  static Future<void> user() async {
    saveValue(SharedPreferenceKeys.username, Data.user == null ? '' : Data.user!.email);
    saveValue(SharedPreferenceKeys.userPassword, Data.user == null ? '' : Data.user!.password);
  }

  static Future<void> all() async {
    recentGamesToShow();
    upcomingGamesToShow();
    starredSports();
    sortLostAndFoundBy();
    dailyScheduleTimelineMode();
    deletedSchedules();
    showReturnedItemsInLostAndFound();
    themeModeAuto();
    darkMode();
  }

  static Future<void> reset() async {
    await resetAllValues();
  }
}