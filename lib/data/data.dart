import 'package:front/api_service/api_service.dart';
import 'daily_schedule.dart';
import 'food_menu.dart';
import 'lost_item.dart';
import 'sports.dart';
import 'school_store.dart';
import 'user_.dart';
import 'settings.dart';

enum ItemType { food, drink, goods, others, na }
enum FoundStatus { returned, lost, na }
enum TeamCategory { varsity, jv, vb, thirds, thirdsBlue, thirdsRed, fourth, fifth, na }
enum Season { fall, winter, spring, na }
enum UserType { student, teacher, parent, admin }

class Data {
  static User_? user;
  static bool loggedIn = false;
  static late Map<String, List<DailySchedule>> dailySchedules;
  static late Map<String, FoodMenu> foodMenus;
  static late List<LostItem> lostAndFounds;
  static late List<StoreItem> storeItems;
  static late List<SportsInfo> sportsInfo;
  static late List<GameInfo> gameInfo;

  static late ApiService apiService;

  static late Settings settings;

  static List<List<dynamic>> pageList = [];

  static void sortStoreItem() {
    storeItems.sort((a, b) => a.itemType.toString().compareTo(b.itemType.toString()));
    storeItems.sort((a, b) => a.name.compareTo(b.name));
  }

  static void sortLostAndFoundBy(String sortType) {
    switch (sortType) {
      case "date":
        lostAndFounds.sort((a, b) => a.status.toString().compareTo(b.status.toString()));
        lostAndFounds.sort((a, b) => a.name.compareTo(b.name));
        lostAndFounds.sort((a, b) => a.dateFound.compareTo(b.dateFound));
        break;
      case "status":
        lostAndFounds.sort((a, b) => a.dateFound.compareTo(b.dateFound));
        lostAndFounds.sort((a, b) => a.name.compareTo(b.name));
        lostAndFounds.sort((a, b) => a.status.toString().compareTo(b.status.toString()));
        break;
      case "name":
        lostAndFounds.sort((a, b) => a.dateFound.compareTo(b.dateFound));
        lostAndFounds.sort((a, b) => a.status.toString().compareTo(b.status.toString()));
        lostAndFounds.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        print("sortLostAndFoundBy: no sort type found");
        lostAndFounds.sort((a, b) => a.dateFound.compareTo(b.dateFound));
    }
  }
}