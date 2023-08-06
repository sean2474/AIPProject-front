import 'package:flutter/material.dart';
import 'package:front/widgets/uploading_snackbar.dart';
import 'package:front/widgets/assets.dart';
import 'edit_page.dart';
import 'add_page.dart';
import 'delete_page.dart';

class EditLostAndFoundPage extends StatefulWidget {
  const EditLostAndFoundPage({Key? key}) : super(key: key);

  @override
  EditLostAndFoundPageState createState() => EditLostAndFoundPageState();
}

class EditLostAndFoundPageState extends State<EditLostAndFoundPage>
    with TickerProviderStateMixin {

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
      
  @override
  Widget build(BuildContext context) {
    UploadingSnackbar uploadingSnackbar = UploadingSnackbar(context, _scaffoldMessengerKey, "uploading");
    Assets assets = Assets(currentPage: EditLostAndFoundPage());
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          buildEditCard("Add item", const Icon(Icons.add), "add lost and found", () {
            assets.pushDialogPage(context, AddPage(
                showUploadingSnackBar: uploadingSnackbar.showUploading, 
                dismissSnackBar: uploadingSnackbar.dismiss,
                showUploadingResultSnackBar: uploadingSnackbar.showUploadingResult,
              ), 
              haveDialog: false
            );
          }),
          buildEditCard("Edit item", const Icon(Icons.edit), "edit lost and found", () {
            assets.pushDialogPage(context, EditPage(
            ), haveDialog: false);
          }),
          buildEditCard("Delete item", const Icon(Icons.delete), "delete lost and found", () {
            assets.pushDialogPage(context, DeletePage(
            ), haveDialog: false);
          }),
        ],
      ),
    );
  }

  Widget buildEditCard(String title, Icon icon, String tag, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        children: [
          Hero(
            tag: "$tag container",
            child: Card(
              child: SizedBox(
                height: 70,
                width: double.infinity,
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Hero(
                tag: "$tag title",
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    icon,
                    const SizedBox(width: 20),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}