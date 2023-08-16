// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:front/data/sports.dart';
import 'game_info.dart';
import 'package:front/pages/sports/method.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);
  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late ColorScheme colorScheme;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final GameInfo naGame = GameInfo(
    id: -1,
    sportsName : 'N/A',
    teamCategory : TeamCategory.na,
    gameLocation : 'N/A',
    opponent : 'N/A',
    matchResult : 'N/A',
    gameDate : 'N/A',
    coachComment : 'N/A',
    isHomeGame: false,
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget sportsInfoBox({required SportsInfo sports, required Widget child, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              child,
              Flexible(
                child: Text(
                  textAlign: TextAlign.center,
                  sports.sportsName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  List<GameInfo> getRecentGames({
    required List<GameInfo> gameData, 
    required int recentGamesCount, 
    required bool getStarredGames
  }) {
    DateTime currentTime = DateTime.now();
    List<GameInfo> recentGames = [];

    List<String> starredSportsSet = Data.settings.starredSports.split(" ").toList();

    List<GameInfo> filteredGameData = getStarredGames
      ? gameData.where((game) {
          String key = '${game.sportsName.toLowerCase().replaceAll(" ", "_")}_${getSportsCategoryToString(game.teamCategory)}';
          return starredSportsSet.contains(key);
        }).toList()
      : gameData;

    for (GameInfo game in filteredGameData.toList()) {
      DateTime gameTime = DateTime.parse(game.gameDate);
      if (gameTime.isBefore(currentTime)) {
        recentGames.add(game);
      }
    }

    recentGames = recentGames.reversed.toList();
    for (int i = recentGames.length; i < recentGamesCount; i++) {
      recentGames.add(naGame);
    }
    recentGames = recentGames.reversed.toList();

    return recentGames.reversed.take(recentGamesCount).toList();
  }

  List<GameInfo> getUpcomingGames({
    required List<GameInfo> gameData, 
    required int upcomingGamesCount, 
    required bool getStarredGames
  }) {
    DateTime currentTime = DateTime.now();
    List<GameInfo> upcomingGames = [];
    List<String> starredSportsSet = Data.settings.starredSports.split(" ").toList();
    List<GameInfo> filteredGameData = getStarredGames
      ? gameData.where((game) {
          String key = '${game.sportsName.toLowerCase().replaceAll(" ", "_")}_${getSportsCategoryToString(game.teamCategory)}';
          return starredSportsSet.contains(key);
        }).toList()
      : gameData;

    for (GameInfo game in filteredGameData.toList()) {
      DateTime gameTime = DateTime.parse(game.gameDate);
      if (gameTime.isAfter(currentTime)) {
        upcomingGames.add(game);
      }
    }

    for (int i = upcomingGames.length; i < upcomingGamesCount; i++) {
      upcomingGames.add(naGame);
    }

    for (GameInfo game in upcomingGames) {
      game.coachComment = '';
      game.matchResult = '';
    }

    return upcomingGames.reversed.take(upcomingGamesCount).toList();
  }


  Widget buildGamesList(List<GameInfo> gamesList) {
    return Container(
      margin: const EdgeInsets.only(top: 10,),
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemBuilder: (context, index) {
          PageController pageController = PageController(initialPage: index);
          String title = gamesList[index].sportsName == 'N/A' ? 'N/A' : '${gamesList[index].sportsName.trim()} - ${getSportsCategoryToString(gamesList[index].teamCategory)} vs. ${gamesList[index].opponent}';
          Color color = gamesList[index].sportsName == 'N/A' ? colorScheme.background : gamesList[index].matchResult == '' ? colorScheme.primaryContainer : colorScheme.secondaryContainer;
          return Container(
            margin: EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.secondary,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: color,
            ),
            child: ListTile(
              leading: getSportsIcon(gamesList[index].sportsName, 20,),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black.withOpacity(0.9),
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 820,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: gamesList.length,
                          itemBuilder: (context, index) {
                            return GameInfoPage(gameData: gamesList[index]);
                          },
                        ),
                      );
                    },
                  );
              },
            ),
          );
        }, 
        shrinkWrap: true,
        itemCount: gamesList.length,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    Size screen = MediaQuery.of(context).size;
    Assets assets = Assets(currentPage: GamePage());
    int recentGametoDisplay = Data.settings.recentGamesToShow;
    int upcomingGametoDisplay = Data.settings.upcomingGamesToShow;
    List<SportsInfo> sportsInfo = Data.sportsInfo;
    List<GameInfo> gameInfo = Data.gameInfo;
    Map<String, bool> sportsListMap = {};
    
    for(SportsInfo sports in sportsInfo) {
      sportsListMap[sports.sportsName] = true;
    }


    List<GameInfo> recentGames = getRecentGames(
      gameData: gameInfo, 
      recentGamesCount: recentGametoDisplay, 
      getStarredGames: false
    );

    List<GameInfo> upcomingGames = getUpcomingGames(
      gameData: gameInfo, 
      upcomingGamesCount: upcomingGametoDisplay, 
      getStarredGames: false
    );

    List<GameInfo> starredRecentGames = getRecentGames(
      gameData: gameInfo, 
      recentGamesCount: recentGametoDisplay, 
      getStarredGames: true
    );

    List<GameInfo> starredUpcomingGames = getUpcomingGames(
      gameData: gameInfo, 
      upcomingGamesCount: upcomingGametoDisplay, 
      getStarredGames: true
    );

    return SmartRefresher(
      enablePullUp: false,
      enablePullDown: true,
      controller: _refreshController,
      header: assets.refreshHeader(indicatorColor: Colors.grey,),
      onRefresh: () => Future.delayed(const Duration(milliseconds: 0), () async {
        String errorMessage = '';
        try {
          Data.gameInfo = GameInfo.transformData(await Data.apiService.getGames());
        } catch (e) {
          errorMessage = 'Failed to load game data';
        }

        if (errorMessage != '') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
              child: Text(
                errorMessage, 
                textAlign: TextAlign.center, 
                style: const TextStyle(
                  fontSize: 15, 
                ),
              )
            ),
            duration: Duration(seconds: 1),
            backgroundColor: const Color(0xfff24c5d),
            behavior: SnackBarBehavior.floating,
            shape: StadiumBorder(),
            width: screen.width * 0.6,
            
          ));
        }
        setState(() { });
        _refreshController.refreshCompleted();
      }),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20,),
            assets.drawAppBarSelector(context: context, titles: ["FAVORITES", "ALL"], selectTab: _selectTab, animation:_animation, selectedIndex: _selectedTabIndex),
            Container(
              margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: FadeTransition(
                  opacity: _animation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      upcomingGametoDisplay != 0 ? 
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("UPCOMING GAMES", textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)
                        ) : Container(),
                      upcomingGametoDisplay != 0 ? buildGamesList(_selectedTabIndex == 0 ? starredUpcomingGames : upcomingGames) : Container(),
                      SizedBox(height: 20,),
                      recentGametoDisplay != 0 ? 
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("RECENT GAMES", textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)
                        ) : Container(),
                      recentGametoDisplay != 0 ? buildGamesList(_selectedTabIndex == 0 ? starredRecentGames : recentGames) : Container(),
                    ],
                  )
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

