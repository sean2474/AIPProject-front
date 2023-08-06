import 'package:flutter/material.dart';
import 'package:front/data/data.dart';

getSportsIcon(String sportsName, double size, {Color? iconColor}) {
  sportsName = sportsName.toLowerCase().replaceAll(" ", "_");
  Widget icon;
  switch (sportsName) {
    case "football":
      icon = Icon(Icons.sports_football, color: iconColor, size: size);
      break;
    case "soccer":
      icon = Icon(Icons.sports_soccer, color: iconColor, size: size);
      break;
    case "cross_country":
      icon = Icon(Icons.directions_run, color: iconColor, size: size);
      break;
    case "hockey":
      icon = Icon(Icons.sports_hockey, color: iconColor, size: size);
      break;
    case "basketball":
      icon = Icon(Icons.sports_basketball, color: iconColor, size: size);
      break;
    case "squash":
      icon = ImageIcon(AssetImage('assets/sports_icons/squash.png'), color: iconColor, size: size);
      break;
    case "wrestling":
      icon = ImageIcon(AssetImage('assets/sports_icons/wrestling.png'), color: iconColor, size: size);
      break;
    case "swimming":
      icon = ImageIcon(AssetImage('assets/sports_icons/swimming.png'), color: iconColor, size: size);
      break;
    case "baseball":
      icon = Icon(Icons.sports_baseball, color: iconColor, size: size);
      break;
    case "lacrosse":
      icon = ImageIcon(AssetImage('assets/sports_icons/lacrosse.png'), color: iconColor, size: size);
      break;
    case "golf":
      icon = Icon(Icons.sports_golf, color: iconColor, size: size);
      break;
    case "track_and_field":
      icon = ImageIcon(AssetImage('assets/sports_icons/track_and_field.png'), color: iconColor, size: size);
      break;
    case "tennis":
      icon = Icon(Icons.sports_tennis, color: iconColor, size: size);
      break;
    default:
      icon = Icon(Icons.directions_run_outlined, color: iconColor, size: size);
      break;
  }
  return icon;
}

String getSportsCategoryToString(TeamCategory category) {
  // enum TeamCategory { varsity, jv, vb, thirds, thirdsBlue, thirdsRed, fourth, fifth, na }
  switch (category) {
    case TeamCategory.fifth:
      return 'Fifth';
    case TeamCategory.fourth:
      return 'Fourth';
    case TeamCategory.thirds:
      return 'Thirds';
    case TeamCategory.thirdsBlue:
      return 'Thirds Blue';
    case TeamCategory.thirdsRed:
      return 'Thirds Red';
    case TeamCategory.jv:
      return 'JV';
    case TeamCategory.vb:
      return 'Varsity B';
    case TeamCategory.varsity:
      return 'Varsity';
    case TeamCategory.na:
      return 'N/A';
    default:
      throw Exception('Invalid category');
  }
}

TeamCategory getStringToSportsCategory(String category) {
  // enum TeamCategory { varsity, jv, vb, thirds, thirdsBlue, thirdsRed, fourth, fifth, na }
  switch (category) {
    case 'Fifth':
      return TeamCategory.fifth;
    case 'Fourth':
      return TeamCategory.fourth;
    case 'Thirds':
      return TeamCategory.thirds;
    case 'Thirds Blue':
      return TeamCategory.thirdsBlue;
    case 'Thirds Red':
      return TeamCategory.thirdsRed;
    case 'JV':
      return TeamCategory.jv;
    case 'Varsity B':
      return TeamCategory.vb;
    case 'Varsity':
      return TeamCategory.varsity;
    case 'N/A':
      return TeamCategory.na;
    default:
      throw Exception('Invalid category');
  }
}

List<TeamCategory> sortOrder = [
  TeamCategory.varsity,
  TeamCategory.jv,
  TeamCategory.vb,
  TeamCategory.thirds,
  TeamCategory.thirdsBlue,
  TeamCategory.thirdsRed,
  TeamCategory.fourth,
  TeamCategory.fifth,
  TeamCategory.na,
];
