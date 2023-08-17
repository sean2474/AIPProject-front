import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:front/pages/daily_schedule/daily_schedule_info.dart';
import 'package:front/pages/games/game_info.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:front/api_service/api_service.dart';
import 'package:front/api_service/exceptions.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/data/data.dart';
import 'package:front/data/food_menu.dart';
import 'package:front/data/lost_item.dart';
import 'package:front/data/school_store.dart';
import 'package:front/data/settings.dart';
import 'package:front/data/shared_preference/get_preference.dart';
import 'package:front/data/shared_preference/save_preference.dart';
import 'package:front/data/sports.dart';
import 'package:front/data/user_.dart';
import 'package:front/firebase_options.dart';
import 'package:front/loading/loading.dart';
import 'package:front/main_menu/main_menu.dart';
import 'package:front/model_theme.dart';
import 'package:front/notification_control/notification_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isThemeModeAuto = await Get.isThemeModeAuto();
  bool isDarkMode = await Get.isDarkMode();
  runApp(MaterialApp(
    home: LoadingPage(
      isDarkMode: isThemeModeAuto 
        ? ThemeMode.system == ThemeMode.dark
        : isDarkMode,
    ),
    debugShowCheckedModeBanner: false,
  ));

  LocalNotification.init();
  LocalNotification.requestNotificationPermission();
  tz.initializeTimeZones();

  String baseUrl = 'http://35.169.229.180:8082';
  debugPrint("connecting to $baseUrl...");

  Data.settings = Settings(
    recentGamesToShow: await Get.recentGamesToShow(),
    upcomingGamesToShow: await Get.upcomingGamesToShow(), 
    starredSports: (await Get.starredSports()).join(' '), 
    sortLostAndFoundBy: await Get.sortLostAndFoundBy() ?? 'date',
    showReturnedItem: await Get.showReturnedItemsInLostAndFound(),
    isDailyScheduleTimelineMode: await Get.isDailyScheduleTimelineMode(),
    deletedSchedules: await Get.deletedSchedules(),
    isThemeModeAuto: isThemeModeAuto,
    isDarkMode: isDarkMode,
  );

  Data.apiService = ApiService(baseUrl: baseUrl);
  Settings.baseUrl = baseUrl;

  while (true) {
    try {
      Data.user = await Data.apiService.login(await Get.username() ?? '', await Get.userPassword() ?? '');
      break;
    } on Exception { /* */ }
    await Future.delayed(Duration(microseconds: 10));
  }

  // TODO: remove this after testing
  Data.user = await Data.apiService.login("johnsmith@example.com", "password1");
  Data.apiService.token = Data.user?.token;

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (Data.user != null && user == null) {
      debugPrint("signed in with local");
      Data.loggedIn = true;
    } else if (user != null) {
      debugPrint("signed in with google");
      print(user.uid);
      Data.user = User_(id: 0, token: user.uid, userType: UserType.student, name: '', password: '', email: user.email ?? '');
      Data.loggedIn = true;
    } else {
      debugPrint("user signed out");
      Data.loggedIn = false;
    }
  });
  
  /// endpoint connections to backend
  try {
    Data.gameInfo = GameInfo.transformData(await Data.apiService.getGames());
  } on NoSuchMethodError {
    debugPrint("failed to load games data");
  } on BadRequestException {
    debugPrint("bad request on games");
  } on NotFoundException {
    debugPrint("page not found on games");
  }
  try {
    Data.sportsInfo = SportsInfo.transformData(await Data.apiService.getSports());
  } on NoSuchMethodError {
    debugPrint("failed to load sports data");
  } on BadRequestException {
    debugPrint("bad request on sports");
  } on NotFoundException {
    debugPrint("page not found on sports");
  }
  try {
    Data.foodMenus = FoodMenu.transformData(await Data.apiService.getFoodMenu());
  } on NoSuchMethodError {
    debugPrint("failed to load food menu data");
  } on BadRequestException {
    debugPrint("bad request on food menu");
  } on NotFoundException {
    debugPrint("page not found on food menu");
  }

  try {
    Data.lostAndFounds = LostItem.transformData(await Data.apiService.getLostAndFound());
  } on NoSuchMethodError {
    debugPrint("failed to load lost and found data");
  } on BadRequestException {
    debugPrint("bad request on lost and found");
  } on NotFoundException {
    debugPrint("page not found on lost and found");
  }
  try {
    Data.storeItems = StoreItem.transformData(await Data.apiService.getSchoolStoreItems());
  } on NoSuchMethodError {
    debugPrint("failed to load store items data");
  } on BadRequestException {
    debugPrint("bad request on store items"); 
  } on NotFoundException {
    debugPrint("page not found on store items");
  }
  try {
    Data.dailySchedules = DailySchedule.transformData(await Data.apiService.getDailySchedule());
  } on NoSuchMethodError {
    debugPrint("failed to load daily schedule data");
  } on BadRequestException {
    debugPrint("bad request on daily schedule"); 
  } on NotFoundException {
    debugPrint("page not found on daily schedule");
  }

  Data.gameInfo.sort((a, b) => a.gameDate.compareTo(b.gameDate));

  Data.settings.recentGamesToShow = await Get.recentGamesToShow();
  Data.settings.upcomingGamesToShow = await Get.upcomingGamesToShow();
  Data.settings.starredSports = (await Get.starredSports()).join(' ');

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  debugPrint("lanching app");
  runApp(
    StudentManagementApp()
  );
}

class StudentManagementApp extends StatefulWidget {
  const StudentManagementApp({Key? key}) : super(key: key);

  @override
  StudentManagementAppState createState() => StudentManagementAppState();
}

class StudentManagementAppState extends State<StudentManagementApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    debugPrint('app disposed');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      Save.all();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            initialRoute: "/",
            onGenerateRoute: (settings) {
              if (settings.name == "/daily-schedule/info") {
                final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => DailyScheduleInfoPage(
                    dailySchedule: args['dailySchedule'] as DailySchedule,
                    date: args['date'] as String,
                    callback: () => setState(() {}),
                  ),
                );
              } else if (settings.name == "/game/info") {
                final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => GameInfoPage(
                    gameData: args['gameData'] as GameInfo,
                  ),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => MainMenuPage(),
                );
              }
            },
            theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
            darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
            themeMode: themeNotifier.isAuto 
              ? ThemeMode.system
              : themeNotifier.isDark 
                ? ThemeMode.dark 
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: MainMenuPage(),
          );
        }
      ),
    );
  }
}
