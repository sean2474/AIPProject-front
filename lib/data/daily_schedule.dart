import 'dart:collection';
import 'package:flutter/material.dart';

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
  int id;
  String startTime;
  String endTime;
  String title;
  bool isRequired;
  String location;
  String description;
  Color color;
  HashSet<int> resource;
  int notificationId;
  int notificationTime = 0;
  int secondNotificationId;
  int secondNotificationTime = 0;

  DailySchedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.isRequired,
    required this.location,
    required this.description,
    required this.color,
    required this.resource,
    required this.notificationId,
    required this.secondNotificationId,
  });

  static Map<String, List<DailySchedule>> transformData(Map<String, dynamic> data) {
    Map<String, List<DailySchedule>> dailySchedules = {};
    data.forEach((key, values) {
      List<DailySchedule> dailySchedule = [];
      for (dynamic value in values) {
        dailySchedule.add(DailySchedule.fromJson(value));
      }
      dailySchedule.sort((a, b) => a.startTime.compareTo(b.startTime));
      print(key);
      dailySchedules[key] = dailySchedule;
    });
    return dailySchedules;
  }
  
  factory DailySchedule.fromJson(Map<String, dynamic> json) {
    return DailySchedule(
      id: json["id"],
      startTime: json["start"].toString().split("T")[1],
      endTime: json["end"].toString().split("T")[1],
      title: json["title"],
      // check after actual endpoint connect
      description: json["description"],
      isRequired: json["isRequired"],
      color: Color(int.parse("0xFF${json["color"].substring(1, 7)}")), // , 
      resource: HashSet<int>()..addAll(json["resource"]),
      location: json["location"],
      notificationId: json["id"] * 10 + 1,
      secondNotificationId: json["id"] * 10 + 2,
    );
  }
    
  @override
  String toString() {
    return "$title $startTime";
  }
}