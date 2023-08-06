/// sports.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:front/data/sports.dart';
import 'method.dart';
import 'sports_info.dart';

class SportsPage extends StatefulWidget {
  const SportsPage({Key? key}) : super(key: key);
  @override
  SportsPageState createState() => SportsPageState();
}

class SportsPageState extends State<SportsPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late ColorScheme colorScheme;

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

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    Size screen = MediaQuery.of(context).size;
    Assets assets = Assets(currentPage: SportsPage());
    List<SportsInfo> sportsInfo = Data.sportsInfo;
    List<GameInfo> gameInfo = Data.gameInfo;
    Map<String, bool> sportsListMap = {};
    
    for(SportsInfo sports in sportsInfo) {
      sportsListMap[sports.sportsName] = true;
    }

    List<String> sportsList = sportsListMap.keys.toList();

    return SmartRefresher(
      enablePullUp: false,
      enablePullDown: true,
      controller: _refreshController,
      header: assets.refreshHeader(indicatorColor: Colors.grey,),
      onRefresh: () => Future.delayed(const Duration(milliseconds: 0), () async {
        String errorMessage = '';
        try {
          Data.sportsInfo = SportsInfo.transformData(await Data.apiService.getSports());
        } catch (e) {
          if (errorMessage != '') {
            errorMessage = '$errorMessage\n';
          }
          errorMessage = '${errorMessage}Failed to load sports data';
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
        child: Container(
          margin: const EdgeInsets.only(top: 40,),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ), 
                  itemCount: sportsList.length,
                  itemBuilder: (context, index) {
                    final String sportsName = sportsList[index].toLowerCase().replaceAll(' ', '_');
                    Color iconColor = colorScheme.secondary;
                    const double size = 80;
                    List<SportsInfo> sportsCategoryList = [];
                    sportsCategoryList = sportsInfo.where((element) => element.sportsName == sportsList[index]).toList();
                    sportsCategoryList.sort((a, b) {
                        int aIndex = sortOrder.indexOf(a.teamCategory);
                        int bIndex = sortOrder.indexOf(b.teamCategory);
                        return aIndex.compareTo(bIndex);
                    });
                    return sportsInfoBox(
                      sports: sportsCategoryList[0],
                      child: getSportsIcon(sportsName, iconColor: iconColor, size),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                            SportsInfoPage(
                              sportsData: sportsCategoryList,
                              gameData: gameInfo,
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

