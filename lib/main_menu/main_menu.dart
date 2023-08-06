import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:front/pages/edit_lost_and_found/lost_and_found_edit.dart';
import 'package:front/pages/edit_school_store/school_store_edit.dart';
import 'package:front/data/data.dart';
import 'package:front/data/sports.dart';
import 'package:front/pages/daily_schedule/daily_schedule.dart';
import 'package:front/pages/food_menu/food_menu.dart';
import 'package:front/pages/games/games.dart';
import 'package:front/pages/games/settings.dart';
import 'package:front/pages/home/home.dart';
import 'package:front/pages/lost_and_found/lost_and_found.dart';
import 'package:front/pages/school_store/school_store.dart';
import 'package:front/pages/sports/sports.dart';
import 'package:front/widgets/assets.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  MainMenuPageState createState() => MainMenuPageState();
}

class MainMenuPageState extends State<MainMenuPage> {
  late ColorScheme colorScheme;
  late HashMap<Type, Widget> settingButton;
  static late StatefulWidget pageToDisplay;

  @override
  void initState() {
    super.initState();
    pageToDisplay = HomePage();
  }

  void changeDailyScheduleMode() {
    setState(() {
      Data.settings.isDailyScheduleTimelineMode = !Data.settings.isDailyScheduleTimelineMode;
      pageToDisplay = DailySchedulePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    HashSet<String> sportsList = HashSet()..addAll(Data.sportsInfo.map((e) => e.sportsName));

    HashMap<Type, String> pageTitles = HashMap()..addAll({
      HomePage: "Home",
      DailySchedulePage: "Daily Schedule",
      FoodMenuPage: "Food Menu",
      GamePage: "Game Info",
      SportsPage: "Sports Info",
      LostAndFoundPage: "Lost and Found",
      SchoolStorePage: "Hawks Nest",
      EditLostAndFoundPage: "Edit Lost and Found",
      EditSchoolStorePage: "Edit School Store",
    });

    Map<String, bool> sportsListMap = {};
    for(SportsInfo sports in Data.sportsInfo) {
      sportsListMap[sports.sportsName] = true;
    }

    Assets assets = Assets(
      currentPage: MainMenuPage(), 
      onPageChange: () => setState(() {})
    );

    settingButton = HashMap()..addAll({
      HomePage: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => HomePageState.showSetting(context),
      ),
      DailySchedulePage: dailyScheduleSetting(),
      GamePage: IconButton(
        onPressed: () {
          gamePageSetting(context, sportsList);
        },
        icon: const Icon(Icons.settings)
      ),
      LostAndFoundPage: IconButton(
        onPressed: () => LostAndFoundPageState.showSetting(
          context,
          onSwitchChange: (value) {
            setState(() {
              Data.settings.showReturnedItem = value;
              pageToDisplay = LostAndFoundPage();
            });
          },
          onSortChange: (sortOrder) {
            setState(() {
              Data.settings.sortLostAndFoundBy = sortOrder;
              Data.sortLostAndFoundBy(sortOrder);
              pageToDisplay = LostAndFoundPage();
            });
            Navigator.pop(context);
          }
        ), 
        icon: Icon(Icons.settings), 
        alignment: Alignment.topRight,
      ),
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            pageTitles[pageToDisplay.runtimeType] ?? "Daily Schedule",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          settingButton[pageToDisplay.runtimeType] ?? Container(),
          assets.menuBarButton(context),
        ],
      ),
      body: pageToDisplay,
      drawer: assets.buildDrawer(context),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.light 
                ? Colors.grey.shade300 
                : const Color.fromARGB(255, 41, 39, 39),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NoSplashCustomBarItem(
              icon: Icons.home_outlined,
              label: "Home",
              activeIcon: Icons.home,
              isActive: pageToDisplay.runtimeType == HomePage,
              onTap: () => setState(() { pageToDisplay = HomePage(); }),
              size: 32,
            ),
            NoSplashCustomBarItem(
              icon: Icons.calendar_today_outlined,
              label: "Schedule",
              activeIcon: Icons.calendar_today,
              isActive: pageToDisplay.runtimeType == DailySchedulePage,
              onTap: () => setState(() { pageToDisplay = DailySchedulePage(); }),
            ),
            NoSplashCustomBarItem(
              icon: Icons.fastfood_outlined,
              label: "Food",
              activeIcon: Icons.fastfood,
              isActive: pageToDisplay.runtimeType == FoodMenuPage,
              onTap: () => setState(() { pageToDisplay = FoodMenuPage(); }),
            ),
            NoSplashCustomBarItem(
              icon: Icons.directions_run_outlined,
              label: "Game",
              activeIcon: Icons.directions_run,
              isActive: pageToDisplay.runtimeType == GamePage,
              onTap: () => setState(() { pageToDisplay = GamePage(); }),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> gamePageSetting(BuildContext context, HashSet<String> sportsList) {
    return showModalBottomSheet(
      context: context, 
      isScrollControlled: true, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.35,
          child: SettingPage(
            sportsList: sportsList.toList(),
            onDialogClosed: () {
              setState(() {
                pageToDisplay = GamePage();                      
                });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            },
          ),
        );
      },
    );
  }

  Container dailyScheduleSetting() {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Data.settings.isDailyScheduleTimelineMode 
          ? colorScheme.primary 
          : Colors.transparent,
      ),
      child: IconButton(
        icon: Data.settings.isDailyScheduleTimelineMode 
          ? Icon(
            Icons.view_timeline_rounded,
            color: colorScheme.primaryContainer,
          ) 
          : Icon(
            Icons.view_timeline_outlined,
            size: 28,
          ),
        padding: EdgeInsets.zero,
        onPressed: changeDailyScheduleMode,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}

class NoSplashCustomBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final String label;
  final VoidCallback onTap;
  final double? size;

  const NoSplashCustomBarItem({
    Key? key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isActive = false,
    required this.onTap,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                isActive ? activeIcon : icon, 
                color: isActive ? colorScheme.primary : colorScheme.secondary,
                size: size ?? 28,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: isActive ? colorScheme.primary : colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
