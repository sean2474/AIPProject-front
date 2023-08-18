import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/data/shared_preference/save_preference.dart';
import 'package:front/widgets/assets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'setting_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  static void showSetting(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return SettingModal();
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Assets assets = Assets(currentPage: HomePage());
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      header: assets.refreshHeader(indicatorColor: Colors.grey,),
      onRefresh: () => Future.delayed(const Duration(milliseconds: 500), () async {
        setState(() {});
        _refreshController.refreshCompleted();
      }),
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                margin: EdgeInsets.only(top: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: "${Data.apiService.baseUrl}/data/daily-schedule/image/2023-07-28",
                    errorWidget: (context, url, error) => Container(
                      child: Image(
                        image: AssetImage('assets/icons/imageNotFound.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2.3,
                margin: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.onBackground, width: 1)
                ),
                child: Column( 
                  children: [
                     // check sent to GET: /auth/testToken with UID in header["uid"]
                    TextButton(
                      onPressed: () async => Data.apiService.checkUIDAuth(), 
                      child: Text("Check UID")
                    ),
                    TextButton(
                      onPressed: () async => Save.all(),
                      child: Text("save settings")
                    ),
                    TextButton(
                      onPressed: () async => Save.reset(),
                      child: Text("reset")
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}