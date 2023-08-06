import 'package:flutter/material.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/widgets/assets.dart';

import 'constants.dart';

class SetAlermPage extends StatefulWidget {
  final String text;
  final bool isSecondNotification;
  final DailySchedule dailySchedule;
  final int alermState;

  SetAlermPage({
    Key? key, 
    required this.text,
    required this.isSecondNotification,
    required this.dailySchedule,
    required this.alermState,
  }) : super(key: key);

  @override
  SetAlermPageState createState() => SetAlermPageState();
}

class SetAlermPageState extends State<SetAlermPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.alermState;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        children: [
          Assets().buttomSheetModalTopline(),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 28,),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: alermButton(alermTexts[0], _selectedIndex == 0),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: alermTexts.length - 1,
                itemBuilder: (context, index) {
                  int i = index+1;
                  return alermButton(alermTexts[i], i == _selectedIndex);
                },
                separatorBuilder: (context, index) {
                  return Assets().getDivider(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget alermButton(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            _selectedIndex = alermTexts.indexOf(text);
            if(widget.isSecondNotification) {
              widget.dailySchedule.secondNotificationTime = _selectedIndex;
            } else {
              widget.dailySchedule.notificationTime = _selectedIndex;
            }
          });
        },
        title: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: isSelected ? Theme.of(context).primaryColor : null,
          ),
        ),
        trailing: isSelected 
          ? Icon(
            Icons.check,
          )
          : null,
      ),
    );
  }
}

