/// school_store.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:front/data/school_store.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'item_page.dart';

String itemTypeToString(ItemType type) {
  switch (type) {
    case ItemType.food:
      return 'Food';
    case ItemType.drink:
      return 'Drink';
    case ItemType.goods:
      return 'Goods';
    case ItemType.others:
      return 'Others';
    default:
      return 'N/A';
  }
}

class SchoolStorePage extends StatefulWidget {
  const SchoolStorePage({Key? key}) : super(key: key);

  @override
  SchoolStorePageState createState() => SchoolStorePageState();
}

class SchoolStorePageState extends State<SchoolStorePage>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    setState(() { 
      _selectedTabIndex = index;
    });
    _animationController.forward(from: 0);
  }

  int itemCounter(ItemType itemType) {
    int counter = 0;
    for (var item in Data.storeItems) {
      if (item.itemType == itemType) {
        counter++;
      }
    }
    return counter;
  }

  List<StoreItem> getItemsOfType(ItemType itemType) {
    List<StoreItem> items = [];
    for (var item in Data.storeItems) {
      if (item.itemType == itemType) {
        items.add(item);
      }
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: SchoolStorePage());
    List<StoreItem> items = getItemsOfType(ItemType.values[_selectedTabIndex]);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: assets.drawAppBarSelector(context: context, titles: ["FOOD", "DRINK", "GOODS", "OTHER"], selectTab: _selectTab, animation: _animation, selectedIndex: _selectedTabIndex)
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: SmartRefresher(
              enablePullUp: false,
              enablePullDown: true,
              header: assets.refreshHeader(indicatorColor: Colors.grey,),
              controller: _refreshController,
              onRefresh: () => Future.delayed(const Duration(milliseconds: 500), () async {
                Data.storeItems = StoreItem.transformData(await Data.apiService.getSchoolStoreItems());
                setState(() {});
                _refreshController.refreshCompleted();
              }),
              child: GridView.builder(
                key: ValueKey<int>(_selectedTabIndex),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2.5, 
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: const EdgeInsets.all(10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return assets.storeItemBox(items[index], context, () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemPage(itemData: items[index],))));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

