class Settings {
  int recentGamesToShow;
  int upcomingGamesToShow;
  String starredSports;
  String sortLostAndFoundBy;
  List<String> deletedSchedules = [];
  bool showReturnedItem;
  bool isDailyScheduleTimelineMode;
  bool isThemeModeAuto;
  bool isDarkMode;
  static String baseUrl = '';
  
  Settings({
    required this.recentGamesToShow, 
    required this.upcomingGamesToShow, 
    required this.starredSports, 
    required this.sortLostAndFoundBy, 
    required this.showReturnedItem,
    required this.isDailyScheduleTimelineMode,
    required this.deletedSchedules,
    required this.isThemeModeAuto,
    required this.isDarkMode,
  });
}