import 'package:flutter/material.dart';
import 'package:front/data/sports.dart';
import 'package:intl/intl.dart';
import 'method.dart';
import 'package:front/color_schemes.g.dart';

class GameInfoPage extends StatelessWidget {
  final GameInfo gameData;
  const GameInfoPage({Key? key, required this.gameData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = gameData.gameDate != 'N/A' ?  '${gameData.sportsName} - ${getSportsCategoryToString(gameData.teamCategory)}' : 'N/A';
    String gameDate = gameData.gameDate != 'N/A' ? ' ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(gameData.gameDate)).toString()}' : 'N/A';
    String gameLocation = gameData.gameLocation != 'N/A' ? ' ${gameData.gameLocation}' : 'N/A';
    String opponent = gameData.opponent != 'N/A' ? ' ${gameData.opponent}' : 'N/A';
    String matchResult = gameData.matchResult != 'N/A' ? ' ${gameData.matchResult}' : 'N/A';

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                  infoBox(' Game Date:', gameDate, 10),
                  infoBox(' Game Location:', gameLocation, 10),
                  infoBox(' Opponent:', opponent, 10),
                  if (gameData.matchResult != '') infoBox(' Match Result:', matchResult, 10),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget infoBox(String title, String info, int topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: lightColorScheme.secondaryContainer
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                info,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
