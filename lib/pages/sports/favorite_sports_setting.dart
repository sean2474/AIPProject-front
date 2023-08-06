import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';
import 'package:front/data/sports.dart';
import 'package:front/widgets/assets.dart';

import 'method.dart';

class StarredSportsSettingPage extends StatefulWidget {
  final Function(String) onChange;
  final List<String> sportsList;
  final VoidCallback? onDialogClosed;
  StarredSportsSettingPage({super.key, required, required this.onChange, required this.sportsList, required this.onDialogClosed});

  @override
  _StarredSportsSettingPageState createState() => _StarredSportsSettingPageState();
}

class _StarredSportsSettingPageState extends State<StarredSportsSettingPage> {
  Map<String, bool> selectedCards = {};
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets().buttomSheetModalTopline(),
          Text(
            'Favorite Sports',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0), 
          Text(
            'Select the sports that you want to mark.\nReceive the game information only what you want!',
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0), 
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < widget.sportsList.length; i += 2)
                    Builder(
                      builder: (context) {
                        final String sports1 = widget.sportsList[i];
                        final String sports1Name = sports1.toLowerCase().replaceAll(' ', '_');
                        bool allSelected1 = true;
                        List<SportsInfo> sportsCategoryList1 = Data.sportsInfo.where((element) => element.sportsName == sports1).toList();
                        for (SportsInfo element in sportsCategoryList1) {
                          String categoryString = getSportsCategoryToString(element.teamCategory);
                          if (selectedCards['${sports1Name}_$categoryString'] == null || selectedCards['${sports1Name}_$categoryString'] == false) {
                            allSelected1 = false;
                            break;
                          }
                        }
          
                        if (i+1 >= widget.sportsList.length) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _itemBox(allSelected1, sportsCategoryList1, sports1Name, sports1),
                                Spacer()
                              ],
                            ),
                          );
                        }
          
                        final String sports2 = widget.sportsList[i + 1];
                        final String sports2Name = sports2.toLowerCase().replaceAll(' ', '_');
                        bool allSelected2 = true;
                        List<SportsInfo> sportsCategoryList2 = Data.sportsInfo.where((element) => element.sportsName == sports2).toList();
          
                        for (SportsInfo element in sportsCategoryList2) {
                          String categoryString = getSportsCategoryToString(element.teamCategory);
                          if (selectedCards['${sports2Name}_$categoryString'] == null || selectedCards['${sports2Name}_$categoryString'] == false) {
                            allSelected2 = false;
                            break;
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _itemBox(allSelected1, sportsCategoryList1, sports1Name, sports1),
                              _itemBox(allSelected2, sportsCategoryList2, sports2Name, sports2),
                            ],
                          ),
                        );
                      }
                    )
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    selectedCards = Data.settings.starredSports.split(" ").asMap().map((key, value) => MapEntry(value, true));
  }

  @override
  void dispose() {
    super.dispose();
    String starredSports = '';
    for (String sportsName in selectedCards.keys) {
      if (selectedCards[sportsName]!) {
        starredSports += '${sportsName.replaceAll(" ", "_")} ';
      }
    }
    Data.settings.starredSports = starredSports;

    if (widget.onDialogClosed != null) {
      widget.onDialogClosed!();
    }
  }

  Widget _itemBox(bool allSelected, List<SportsInfo> sportsCategoryList, String sportsName, String sports) {
    sportsCategoryList.sort((a, b) => 
      a.teamCategory.index.compareTo(b.teamCategory.index)
    );
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (allSelected) {
                  for (SportsInfo element in sportsCategoryList) {
                    String categoryString = getSportsCategoryToString(element.teamCategory);
                    selectedCards['${sportsName}_$categoryString'] = false;
                  }
                } else {
                  for (SportsInfo element in sportsCategoryList) {
                    String categoryString = getSportsCategoryToString(element.teamCategory);
                    selectedCards['${sportsName}_$categoryString'] = true;
                  }
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getSportsIcon(sportsName, iconColor: lightColorScheme.secondary, 30),
                Text(
                  " $sports",
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: Checkbox(
                    value: allSelected,
                    onChanged: (value) {
                      setState(() {
                        if (allSelected) {
                          for (SportsInfo element in sportsCategoryList) {
                            String categoryString = getSportsCategoryToString(element.teamCategory);
                            selectedCards['${sportsName}_$categoryString'] = false;
                          }
                        } else {
                          for (SportsInfo element in sportsCategoryList) {
                            String categoryString = getSportsCategoryToString(element.teamCategory);
                            selectedCards['${sportsName}_$categoryString'] = true;
                          }
                        }
                      });
                    }
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              for (SportsInfo element in sportsCategoryList) 
                ActionChip(
                  avatar: Icon(selectedCards['${sportsName}_${getSportsCategoryToString(element.teamCategory)}'] ?? false ? Icons.star : Icons.star_border, ),
                  label: SizedBox(width: 80,child: Text(getSportsCategoryToString(element.teamCategory))),
                  onPressed: () {
                    setState(() {
                      selectedCards['${sportsName}_${getSportsCategoryToString(element.teamCategory)}'] = !(selectedCards['${sportsName}_${getSportsCategoryToString(element.teamCategory).toLowerCase()}'] ?? false);
                    });
                  },
                ),
            ],
          )
        ],
      ),
    );
  }  
}
