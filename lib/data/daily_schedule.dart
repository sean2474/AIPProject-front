import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';

// notification time:
// 0. "None",
// 1. "At the time of event",
// 2. "5 minutes before",
// 3. "15 minutes before",
// 4. "30 minutes before",
// 5. "1 hour before",
// 6. "2 hours before",
// 7. "1 day before",
// 8. "2 days before",
// 9. "1 week before",

class DailySchedule {
  String id;
  String startTime;
  String endTime;
  DateTime startDateTime;
  String title;
  bool isRequired;
  String location;
  String description;
  Color color;
  int notificationId;
  int notificationTime = 0;
  int secondNotificationId;
  int secondNotificationTime = 0;

  DailySchedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.startDateTime,
    required this.title,
    required this.isRequired,
    required this.location,
    required this.description,
    required this.color,
    required this.notificationId,
    required this.secondNotificationId,
  });

  static Map<String, List<DailySchedule>> transformData(List<dynamic> data) {
    Map<String, List<DailySchedule>> dailySchedules = {};
    // sort data by start and end
    data.sort((a, b) {
      if (a["start"].toString() == b["start"].toString()) {
        return a["end"].toString().compareTo(b["end"].toString());
      }
      return a["start"].toString().compareTo(b["start"].toString());
    });

    for (dynamic schedule in data) {
      String date = schedule["start"].toString().split("T")[0];
      DailySchedule dailySchedule = DailySchedule.fromJson(schedule);
      if (Data.settings.deletedSchedules.contains(dailySchedule.id)) continue;
      if (dailySchedules[date] == null) {
        dailySchedules[date] = [dailySchedule];
      } else {
        dailySchedules[date]!.add(dailySchedule);
      }
    }
    return dailySchedules;
  }
  
  factory DailySchedule.fromJson(Map<String, dynamic> json) {
    String id = json["title"]+json["start"].toString()+json["end"].toString();
    Color color = Colors.black;
    String? colorString = json["color"];
    if (colorString != null) {
      if (colorString.startsWith("rgba(")) {
        color = parseColor(colorString);
      } else if (colorString.startsWith("#")) {
        color = Color(int.parse("0xFF${colorString.substring(1, 7)}"));
      }
    }
    return DailySchedule(
      id: json["title"]+json["start"].toString()+json["end"].toString(),
      title: json["title"],
      description: json["description"],
      startTime: json["start"].toString().split("T")[1].substring(0, 5),
      endTime: json["end"].toString().split("T")[1].substring(0, 5),
      // TODO: should be changed maybe?
      isRequired: json["status"] != "busy",
      color: color,
      location: json["location"],
      notificationId: ("${id}1").hashCode,
      secondNotificationId: ("${id}2").hashCode,
      startDateTime: DateTime.parse(json["start"]),
    );
  }

  @override
  String toString() {
    return "$title $startTime";
  }

  static Color parseColor(String rgbaString) {
    if (rgbaString.isEmpty || !rgbaString.startsWith('rgba(')) {
      print(rgbaString);
      throw FormatException('The provided string is not a valid rgba format');
    }

    final strippedString = rgbaString.substring(5, rgbaString.length - 1);

    final rgbaValues = strippedString.split(',');

    if (rgbaValues.length != 4) {
      throw FormatException('The provided string is not a valid rgba format');
    }

    final r = int.parse(rgbaValues[0].trim());
    final g = int.parse(rgbaValues[1].trim());
    final b = int.parse(rgbaValues[2].trim());
    final a = (double.parse(rgbaValues[3].trim()) * 255).toInt();

    return Color.fromARGB(a, r, g, b);
  }
}