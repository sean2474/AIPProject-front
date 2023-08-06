import 'package:flutter/material.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/pages/daily_schedule/set_alerm.dart';
import 'package:front/widgets/assets.dart';

import 'constants.dart';

class DailyScheduleInfoPage extends StatefulWidget {
  final DailySchedule dailySchedule;
  final String date;

  const DailyScheduleInfoPage({
    Key? key, 
    required this.dailySchedule,
    required this.date,
  }) : super(key: key);

  @override
  DailyScheduleInfoPageState createState() => DailyScheduleInfoPageState();
}

class DailyScheduleInfoPageState extends State<DailyScheduleInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
        ),
        title: Text(
          "Event Details",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Theme.of(context).brightness == Brightness.light 
              ? Colors.grey.shade800
              : null,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dailySchedule.title,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light 
                        ? Colors.grey.shade800
                        : null,
                    ),
                  ),
                  widget.dailySchedule.location != "" 
                  ? Text(
                    "(in ${widget.dailySchedule.location})",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.light 
                        ? Colors.grey.shade800
                        : null,
                    ),
                  )
                  : SizedBox(),
                  SizedBox(height: 20),
                  Text(
                    "${widget.date} ${weekday[DateTime.parse(widget.date).weekday]}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).brightness == Brightness.light 
                        ? Colors.grey.shade800
                        : null,
                    ),
                  ),
                  Text(
                    "${widget.dailySchedule.startTime} ~ ${widget.dailySchedule.endTime}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).brightness == Brightness.light 
                        ? Colors.grey.shade800
                        : null,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: 
              widget.dailySchedule.description.trim() != ""
                ? Text(
                  widget.dailySchedule.description,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).brightness == Brightness.light 
                      ? Colors.grey.shade800
                      : null,
                  ),
                ) 
                : Text(
                  "No Description",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).brightness == Brightness.light 
                      ? Colors.grey
                      : null,
                  ),
                ),
            ),
            SizedBox(height: 16),
            Assets().getDivider(context),
            buildAlermButton(context, "Alert", widget.dailySchedule.notificationTime, false),
            Assets().getDivider(context),
            buildAlermButton(context, "Second Alert", widget.dailySchedule.secondNotificationTime, true),
            Assets().getDivider(context),
            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: double.infinity,
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2)),
                ),
                onPressed: widget.dailySchedule.isRequired ? null : () {
                  showDeleteCheckBox();
                },
                child: Text(
                  "Delete Event",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    color: widget.dailySchedule.isRequired 
                      ? Theme.of(context).colorScheme.outline 
                      : Colors.red,
                  ),
                )
              )
            ),
          ],
        ),
      )
    );
  }

  void showDeleteCheckBox() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(15),
            ),
            width: 300,
            height: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Are you sure you want to delete this event?", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), 
                    textAlign: TextAlign.center
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Assets().getDivider(context),
                    ListTile(
                      title: Text("Delete", style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.pop(context);
                      }
                    ),
                    Assets().getDivider(context),
                  ],
                ),
                ListTile(
                  title: Text("Cancel", textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ),
        );
      },
    );
  }

  Widget buildAlermButton(context, String text, int alermState, bool isSecondAlerm) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: colorScheme.secondaryContainer.withOpacity(0.1),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder:(context) {
              return FractionallySizedBox(
                heightFactor: 0.82,
                child: SetAlermPage(
                  text: text,
                  dailySchedule: widget.dailySchedule,
                  isSecondNotification: isSecondAlerm,
                  alermState: alermState,
                ),
              );
            },
          ).then((_) { 
            setState((){
              
            });
          });
        },
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                ),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(
                alermTexts[alermState],
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: colorScheme.outline,
              ),
            ),
          ],
        )
      )
    );
  }
}