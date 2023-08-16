import 'package:flutter/material.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/data/data.dart';

import 'daily_schedule_info.dart';

class DailyScheduleViewPage extends StatefulWidget {
  final List<DailySchedule> dailySchedules;
  final String date;

  const DailyScheduleViewPage({
    Key? key, 
    required this.date,
    required this.dailySchedules,
  }) : super(key: key);

  @override
  DailyScheduleViewPageState createState() => DailyScheduleViewPageState();
}

class DailyScheduleViewPageState extends State<DailyScheduleViewPage> {
  @override
  Widget build(BuildContext context) {
    Color? textColor = Theme.of(context).brightness == Brightness.light 
      ? Colors.grey.shade800
      : null;
    if (Data.settings.isDailyScheduleTimelineMode) {
      return TimelineScheduleBuilder(widget: widget, callback: () => setState(() {}));
    } else {
      return BlockScheduleBuilder(widget: widget, textColor: textColor, callback: () => setState(() {}));
    }
  }
}

class BlockScheduleBuilder extends StatelessWidget {
  const BlockScheduleBuilder({
    super.key,
    required this.widget,
    required this.textColor,
    required this.callback,
  });

  final DailyScheduleViewPage widget;
  final Color? textColor;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: 24,
        itemBuilder: (context, index) {
          var children = <Widget>[];

          widget.dailySchedules.where((schedule) {
            return int.parse(schedule.startTime.split(':')[0]) == index;
          }).forEach((schedule) {
            children.add(
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: schedule.color.withAlpha(100),
                  border: Border.all(
                    color: schedule.color,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  splashColor: Colors.transparent,                  
                  title: Text(schedule.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
                  subtitle: Text(schedule.location, style: TextStyle(fontSize: 12, color: textColor)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(schedule.startTime, style: TextStyle(fontSize: 14, color: textColor)),
                      Text(schedule.endTime, style: TextStyle(fontSize: 14, color: textColor)),
                    ]
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyScheduleInfoPage(dailySchedule: schedule, date: widget.date, callback: () => callback()),
                      ),
                    );
                  },
                ),
              )
            );
          });
          return Column(children: children);
        },
      ),
    );
  }
}

class TimelineScheduleBuilder extends StatelessWidget {
  const TimelineScheduleBuilder({
    super.key,
    required this.widget,
    required this.callback,
  });
  final DailyScheduleViewPage widget;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    const oneHourHeight = 65.0;
    const timeBlockWidth = 75.0;
    const rightMargin = 5.0;
    const blockHorizontalMargin = 2.5;
    final double blockFullWidth = MediaQuery.of(context).size.width - timeBlockWidth - rightMargin;
    
    Map<int, List<DailySchedule>> scheduleOverlapMap = <int, List<DailySchedule>>{};
    for (var schedule in widget.dailySchedules) {
      List<String> time = schedule.startTime.split(":");
      int key = ((double.parse(time[0]) + double.parse(time[1]) / 60) * 2).toInt();
      if (scheduleOverlapMap[key] == null) {
        scheduleOverlapMap[key] = [schedule];
      } else {
        scheduleOverlapMap[key]!.add(schedule);
      }
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20, right: rightMargin),
        width: MediaQuery.of(context).size.width,
        height: oneHourHeight * 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: List.generate(19, (index) {
                int hr = index+5;
                return Container(
                  width: timeBlockWidth,
                  height: oneHourHeight,
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    "${hr >= 10 ? hr : "0$hr"}: 00",
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).brightness == Brightness.light 
                        ? Colors.grey[800]! 
                        : Color.fromARGB(255, 221, 221, 221),
                    ),
                  ),
                );
              }),
            ),
            Container(
              margin: EdgeInsets.only(top: 7),
              child: Stack(
                children: [
                  Column(
                    children: List.generate(19, (index) {
                      return Container(
                        height: oneHourHeight,
                        width: blockFullWidth,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: Theme.of(context).brightness == Brightness.light 
                                ? Colors.grey[400]! 
                                : Color.fromARGB(255, 118, 114, 114),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Stack(
                    children: scheduleOverlapMap.entries.map<Widget>((item) {
                      List<DailySchedule> schedules = item.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: schedules.asMap().entries.map<Widget>((item) {
                          DailySchedule schedule = item.value;
                          List<String> time = schedule.startTime.split(":");
                          double startTime = (double.parse(time[0]) + double.parse(time[1]) / 60) - 5;
                          time = schedule.endTime.split(":");
                          double endTime = (double.parse(time[0]) + double.parse(time[1]) / 60) - 5;
                          double height = (endTime - startTime) * oneHourHeight;
                          return Container(
                            margin: EdgeInsets.only(top: startTime * oneHourHeight, left: blockHorizontalMargin, right: blockHorizontalMargin),
                            height: height,
                            width: blockFullWidth/schedules.length - blockHorizontalMargin * 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: schedule.color.withAlpha(100),
                              border: Border.all(
                                color: schedule.color,
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: schedule.color.withAlpha(100),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DailyScheduleInfoPage(dailySchedule: schedule, date: widget.date, callback: () => callback()),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 6, top: (height > 50 ? 5 : 0)),
                                child: Text(
                                  schedule.title,
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: height > 50 ? 17 : height/2.5,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}