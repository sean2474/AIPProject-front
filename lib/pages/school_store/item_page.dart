import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/data/school_store.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemPage extends StatelessWidget {
  final StoreItem itemData;

  const ItemPage({Key? key, required this.itemData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color? textColor = Theme.of(context).brightness == Brightness.light ? Colors.grey.shade800 : null;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
        ),
        title: Text(
          "Item Details",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: textColor,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: itemData.imageUrl,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                if (itemData.stock == 0)
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        'Sold Out',
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        itemTypeToIcon(itemData.itemType),
                        color: textColor,
                      ),
                      Text(
                        itemTypeToString(itemData.itemType),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    itemData.name,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    "\$${itemData.price.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                  Text(
                    itemData.stock == 0 
                      ? "Sold Out"   
                      : itemData.stock == 1
                        ? "${itemData.stock} item left"
                        : "${itemData.stock} items left",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      color: itemData.stock == 0 ? colorScheme.primary : textColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: colorScheme.onSecondary,
                ),
                child: Text(
                  itemData.description,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String itemTypeToString(ItemType itemType) {
    switch (itemType) {
      case ItemType.food:
        return "Food";
      case ItemType.drink:
        return "Drink";
      case ItemType.goods:
        return "Goods";
      case ItemType.others:
        return "Other";
      default:
        return "N/A";
    }
  }

  // TODO: make icon
  IconData itemTypeToIcon(ItemType itemType) {
    switch (itemType) {
      case ItemType.food:
        return Icons.fastfood_rounded;
      case ItemType.drink:
        return Icons.local_drink_rounded;
      case ItemType.goods:
        return Icons.shopping_bag_rounded;
      case ItemType.others:
        return Icons.data_object_rounded;
      default:
        return Icons.do_not_disturb_alt_rounded;
    }
  }
}
