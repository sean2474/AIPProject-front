import 'shared_preference_storage.dart';
import 'shared_preference_keys.dart';

class Get {
  static Future<bool> isThemeModeAuto() async {
    String? isThemeModeAuto = await readValue(SharedPreferenceKeys.isThemeModeAuto);
    if (isThemeModeAuto == null) {
      return true;
    } else {
      return isThemeModeAuto == 'true';
    }
  }

  static Future<bool> isDarkMode() async {
    String? isDarkMode = await readValue(SharedPreferenceKeys.isDarkMode);
    if (isDarkMode == null) {
      return false;
    } else {
      return isDarkMode == 'true';
    }
  }

  static Future<String?> sortLostAndFoundBy() async {
    return await readValue(SharedPreferenceKeys.sortLostAndFoundBy);
  }

  static Future<int> recentGamesToShow() async {
    int recentGames = int.parse(await readValue(SharedPreferenceKeys.numbersOfRecentGamesResultToShow) ?? '3');
    return recentGames;
  }

  static Future<int> upcomingGamesToShow() async {
    int upcomingGames = int.parse(await readValue(SharedPreferenceKeys.numbersOfUpcomingGamesResultToShow) ?? '3');
    return upcomingGames;
  }

  static Future<bool> showReturnedItemsInLostAndFound() async {
    String? show = await readValue(SharedPreferenceKeys.showReturnedItemsInLostAndFound);
    if (show == null) {
      return false;
    } else {
      return show == 'true';
    }
  }

  static Future<bool> isDailyScheduleTimelineMode() async {
    String? isDailyScheduleTimelineMode = await readValue(SharedPreferenceKeys.isDailyScheduleTimelineMode);
    if (isDailyScheduleTimelineMode == null) {
      return false;
    } else {
      return isDailyScheduleTimelineMode == 'true';
    }
  }

  static Future<List<String>> deletedSchedules() async {
    String? deletedSchedules = await readValue(SharedPreferenceKeys.deletedSchedules);
    if (deletedSchedules == null) {
      return [];
    } else {
      return deletedSchedules.split(' ');
    }
  }

  static Future<String?> username() async {
    return await readValue(SharedPreferenceKeys.username);
  }

  static Future<String?> userPassword() async {
    return await readValue(SharedPreferenceKeys.userPassword);
  }

  static Future<List<String>> starredSports() async {
    String? starredSports = await readValue(SharedPreferenceKeys.starredSports);
    if (starredSports == null) {
      return [];
    } else {
      return starredSports.split(' ');
    }
  }
}
