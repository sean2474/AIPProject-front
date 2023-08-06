import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:front/data/lost_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'lost_item_page.dart';
import 'switch.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({Key? key}) : super(key: key);

  @override
  LostAndFoundPageState createState() => LostAndFoundPageState();
}

class LostAndFoundPageState extends State<LostAndFoundPage>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  String _searchText = "";
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<LostItem> selectedItem(List<LostItem> items, String keyWord) {
    if (!Data.settings.showReturnedItem) {
      items = items.where((element) => element.status != FoundStatus.returned).toList();
    }

    if (keyWord == "") {
      return items;
    }

    List<LostItem> result = [];
    for (LostItem item in items) {
      String itemName = item.name.toLowerCase().replaceAll(" ", "");
      bool contains = false;
      for (String word in keyWord.split(" ")) {
        if (itemName.contains(word.toLowerCase())) {
          contains = true;
        } else {
          contains = false;
          break;
        }
      }
      if (contains) {
        result.add(item);
      }
    }
    return result;
  }
  
  @override 
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  static void showSetting(BuildContext context, {
    required Function(bool) onSwitchChange,
    required Function(String) onSortChange,
  }) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true, // makes the height of the sheet dynamic
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.37, // makes the sheet take up half of the screen height
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets().buttomSheetModalTopline(),
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: colorScheme.background,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SettingModal(
                        key: ValueKey<bool>(Data.settings.showReturnedItem),
                        showReturnedItem: Data.settings.showReturnedItem,
                        onSwitchChange: onSwitchChange
                      ),
                      Assets().getDivider(context),
                      ListTile(
                        title: const Text('Sort Options'),
                        onTap: () {
                          _showSortOptions(context, onSortChange: onSortChange);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  static void _showSortOptions(BuildContext context, {
    required Function(String) onSortChange,
  }) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // makes the height of the sheet dynamic
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.37, // makes the sheet take up half of the screen height
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                SizedBox(
                  height: 5.0,
                  width: 50.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  'Sort Options',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: colorScheme.background,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: const Text('Sort by Status'),
                        onTap: onSortChange("status"),
                      ),
                      Assets().getDivider(context),
                      ListTile(
                        title: const Text('Sort by Date'),
                        onTap: onSortChange("date"),
                      ),
                      Assets().getDivider(context),
                      ListTile(
                        title: const Text('Sort by Name'),
                        onTap: onSortChange('name'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: LostAndFoundPage());
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        showCursor: false,
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).brightness == Brightness.light 
                            ? Colors.white 
                            : colorScheme.onSecondary,
                          hintText: 'Search items',
                          contentPadding: const EdgeInsets.all(8.0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          header: assets.refreshHeader(indicatorColor: Colors.grey,),
          onRefresh: () => Future.delayed(const Duration(milliseconds: 500), () async {
            Data.lostAndFounds = selectedItem(LostItem.transformData(await Data.apiService.getLostAndFound()), _searchText);
            setState(() {});
            _refreshController.refreshCompleted();
          }),
          child: GridView.builder(
            key: ValueKey<String>(_searchText),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 2.5, 
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(10),
            itemCount: selectedItem(Data.lostAndFounds, _searchText).length,
            itemBuilder: (context, index) {
              LostItem item = selectedItem(Data.lostAndFounds, _searchText)[index];
              return assets.lostItemBox(item, context, () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemPage(itemData: item))));
            },
          ),
        ),
      ),

    );
  }
}