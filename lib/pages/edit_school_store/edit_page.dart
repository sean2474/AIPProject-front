import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'edit_item_page.dart';
import 'package:front/widgets/uploading_snackbar.dart';

class EditPage extends StatefulWidget {
  EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late ColorScheme colorScheme;
  bool isAddPageHidden = false;

  double initial = 0.0;
  double distance = 0.0;

  double screenWidth = 0;
  double screenHeight = 0;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    Assets assets = Assets(currentPage: EditPage());
    UploadingSnackbar uploadingSnackbar = UploadingSnackbar(context, _scaffoldMessengerKey, "uploading");

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: GestureDetector(
        onVerticalDragStart: (DragStartDetails details) {
          initial = details.globalPosition.dy;
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          distance = details.globalPosition.dy - initial;
          if (distance > 0.0) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: !isAddPageHidden 
            ? Stack(
              children: [
                buildCardHero(),
                Column(
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
                    buildTitle(context),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 70),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 2.5, 
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: Data.storeItems.length,
                    itemBuilder: (context, index) {
                      Data.sortLostAndFoundBy("status");
                      return assets.storeItemBox(Data.storeItems[index], context, () {
                        showModalBottomSheet(
                          context: context, 
                          isScrollControlled: true, // makes the height of the sheet dynamic
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                          ),
                          builder: (BuildContext context) {
                            return EditItemPage(
                              itemData: Data.storeItems[index], 
                              itemIndex: index,
                              onEdit: () {
                                setState(() {});
                              },
                              showUploadingSnackBar: uploadingSnackbar.showUploading,
                              dismissSnackBar: uploadingSnackbar.dismiss,
                              showUploadingResultSnackBar: uploadingSnackbar.showUploadingResult,
                            );
                          },
                        );
                      });
                    },
                  ),
                ),
              ],
            )
            : SizedBox(),
        ),
      ),
    );
  }

  Hero buildCardHero() {
    return Hero(
      tag: "edit school store container",
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Container buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Hero(
        tag: "edit school store title",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Edit item",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}