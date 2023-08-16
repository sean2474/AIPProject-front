import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/data/lost_item.dart';
import 'package:front/data/school_store.dart';
import 'package:front/main_menu/main_menu.dart';
import 'package:front/pages/games/games.dart';
import 'package:front/pages/home/home.dart';
import 'package:front/pages/lost_and_found/lost_item_page.dart';
import 'package:front/pages/school_store/school_store.dart';
import 'package:front/pages/daily_schedule/daily_schedule.dart';
import 'package:front/pages/food_menu/food_menu.dart';
import 'package:front/pages/lost_and_found/lost_and_found.dart';
import 'package:front/pages/sports/sports.dart';
import 'package:front/pages/edit_lost_and_found/lost_and_found_edit.dart';
import 'package:front/pages/edit_school_store/school_store_edit.dart';
import 'package:front/data/data.dart';
import 'package:front/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Assets {
  final Widget? currentPage;
  final User? user = FirebaseAuth.instance.currentUser;
  final VoidCallback? onUserChanged; 
  final VoidCallback? onPageChange;

  Assets({this.currentPage, this.onUserChanged, this.onPageChange}) {
    if (Data.user?.userType == UserType.admin) {
      Data.pageList = [
        ["HOME", Icons.home],
        ["DAILY SCHEDULE", Icons.calendar_today], 
        ["LOST AND FOUND", Icons.find_in_page], 
        ["FOOD MENU", Icons.fastfood], 
        ["HAWKS NEST", Icons.store], 
        ["SPORTS", Icons.sports],
        ["GAMES", Icons.directions_run_outlined],
        ["EDIT LOST AND FOUND", Icons.edit], 
        ["EDIT SCHOOL STORE", Icons.edit],
      ];
    } else {
      Data.pageList = [
        ["HOME", Icons.home],
        ["DAILY SCHEDULE", Icons.schedule], 
        ["LOST AND FOUND", Icons.find_in_page], 
        ["FOOD MENU", Icons.fastfood], 
        ["HAWKS NEST", Icons.store], 
        ["SPORTS", Icons.sports],
        ["GAMES", Icons.directions_run_outlined],
      ];
    }
  }
  
  Widget buildDrawer(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder<User?> (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        return Drawer(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 70),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    if (!Data.loggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      FirebaseAuth.instance.signOut();
                      if (onUserChanged != null) onUserChanged!();
                      Data.apiService.logout();
                      Data.loggedIn = false;
                    }
                  },
                  leading: CircleAvatar(
                    child: Icon(
                      CupertinoIcons.person
                    ),
                  ),
                  title: Text(
                    !Data.loggedIn ? "SIGN IN" : "SIGN OUT",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  children: Data.pageList.asMap().entries.map<Widget>((item) {
                    return Column(
                      children: [
                        (item.key != 0) ? Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Assets().getDivider(context),
                        ) : Container(),
                        Stack(
                          children: [
                            (currentPage != null && currentPage.runtimeType == _getPageType(item.value[0]).runtimeType) 
                                ? Positioned(
                                  height: 56,
                                  width: 288,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: colorScheme.background.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                  ),
                                ) 
                                : SizedBox(),
                            _buildDrawerItem(context, item.value[1], item.value[0], currentPage: currentPage),
                          ],
                        ),
                      ]
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title,
      {Widget? currentPage}) {
    return ListTile(
      splashColor: Colors.transparent,
      leading: SizedBox(
        width: 34,
        height: 34,
        child: Icon(icon),
      ),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        _pushPage(title, context);
      },
    );
  }

  StatefulWidget? _getPageType(String title) {
    switch (title) {
      case 'HOME':
        return HomePage();
      case 'DAILY SCHEDULE':
        return DailySchedulePage();
      case 'LOST AND FOUND':
        return LostAndFoundPage();
      case 'FOOD MENU':
        return FoodMenuPage();
      case 'HAWKS NEST':
        return SchoolStorePage();
      case 'SPORTS':
        return SportsPage();
      case 'GAMES':
        return GamePage();
      case 'EDIT LOST AND FOUND':
        return EditLostAndFoundPage();
      case 'EDIT SCHOOL STORE':
        return EditSchoolStorePage();
      default:
        return null;
    }
  }

  Widget menuBarButton(
    BuildContext context,
  ) {
    return Builder(
      builder: (BuildContext innerContext) {
        return IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Scaffold.of(innerContext).openDrawer();
          },
          padding: EdgeInsets.zero,
          icon: Icon(Icons.menu),
        );
      },
    );
  }
  
  /// Returns a [Widget] that displays a [text] button that calls [onTap] when pressed. 
  Widget textButton(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            text,
            // bold font
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.bold
              ),
          ),
        ),
      ),
    );
  }

  /// Returns a [Widget] that displays a list of [titles] in a row, with the
  /// 
  /// [selectedIndex] being highlighted. The [selectTab] function is called when a tab is selected.
  /// [titles] is a list of strings that are the titles of each tab.
  /// [selectTab] should include the logic that changes the [selectedIndex] state and the page.
  Widget drawAppBarSelector({required BuildContext context, required List<String> titles, required Function(int) selectTab, required Animation<double> animation, required int selectedIndex}) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: titles.asMap().entries.map((entry) {
        int index = entry.key;
        String category = entry.value;
        return GestureDetector(
          onTap: () => selectTab(index),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Opacity(
                  opacity: selectedIndex == index
                    ? animation.value
                    : 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ]
            )
          ),
        );
      }).toList(),
    );
  }

  CustomHeader refreshHeader({required Color indicatorColor}) {
    return CustomHeader(
      builder: (BuildContext context, RefreshStatus? mode) {
        Widget body;
        if (mode == RefreshStatus.idle) {
          body = Text('');
        } else if (mode == RefreshStatus.refreshing) {
          body = CupertinoActivityIndicator(color: indicatorColor,);
        } else {
          body = CupertinoActivityIndicator(color: indicatorColor,);
        }
        return Container(
          padding: EdgeInsets.only(bottom: 20),
          alignment: Alignment.bottomCenter,
          height: 1000.0,
          child: body,
        );
      },
    );
  }

  GridView buildMainMenuGridViewBuilder() {
    List<List<dynamic>> pageListExcludingDashBoard = Data.pageList.sublist(1);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1, 
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), 
      itemCount: pageListExcludingDashBoard.length,
      itemBuilder: (context, index) => _buildPageCard(context, pageListExcludingDashBoard[index][0], pageListExcludingDashBoard[index][1]),
    );
  }
 
  GestureDetector _buildPageCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        _pushPage(title, context);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pushPage(String title, BuildContext context) {
    MainMenuPageState.pageToDisplay = _getPageType(title)!;
    if (onPageChange != null) {
      onPageChange!();
    } else {
      throw Exception('onPageChange is null');
    }
  }

  void pushDialogPage(BuildContext context, Widget page, {bool haveDialog = true}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (_, animation, secondaryAnimation) => Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context); 
              },
              child: FadeTransition(
                opacity: animation,
                child: Container(color: Colors.transparent),
              ),
            ),
            FadeTransition(
              opacity: animation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: (haveDialog) ? 
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: page,
                    ),
                  )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: page,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget lostItemBox(LostItem data, BuildContext context, VoidCallback onTap) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colorScheme.secondaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: data.imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  if (data.status == FoundStatus.returned)
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          'Returned',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                data.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "status: ${statusToString(data.status)}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget storeItemBox(StoreItem storeItem, BuildContext context, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: storeItem.imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  if (storeItem.stock == 0)
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          'Sold Out',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    storeItem.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${storeItem.price}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  Text(
                    'Stock: ${storeItem.stock}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttomSheetModalTopline() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
      ],
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 3,
      items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(
          label: " ",
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today_rounded),
        ),
        BottomNavigationBarItem(
          label: " ",
          icon: Icon(Icons.fastfood_outlined),
          activeIcon: Icon(Icons.fastfood_rounded)
        ),
        BottomNavigationBarItem(
          label: " ",
          icon: Icon(Icons.directions_run_outlined),
          activeIcon: Icon(Icons.directions_run_rounded)
        ),
      ]
    );
  }

  Widget getDivider(context) {
    return Divider(
      color: Theme.of(context).brightness == Brightness.light 
        ? Colors.grey.shade300 
        : const Color.fromARGB(255, 41, 39, 39),
      height: 1,
    );
  }
}
