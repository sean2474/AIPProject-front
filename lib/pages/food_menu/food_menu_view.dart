import 'package:flutter/material.dart';
import 'package:front/data/food_menu.dart';
import 'package:front/widgets/assets.dart';

enum MealType { breakfast, lunch, dinner }

class FoodMenuViewPage extends StatefulWidget {
  final FoodMenu foodMenu;
  final int mealType;

  const FoodMenuViewPage({
    Key? key, 
    required this.foodMenu, 
    required this.mealType,
  }) : super(key: key);

  @override
  FoodMenuViewPageState createState() => FoodMenuViewPageState();
}

class FoodMenuViewPageState extends State<FoodMenuViewPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Map<String, List<Food>> menuToShow = {};
    if (widget.mealType == MealType.breakfast.index) {
      menuToShow = widget.foodMenu.breakFast;
    } else if (widget.mealType == MealType.lunch.index) {
      menuToShow = widget.foodMenu.lunch;
    } else if (widget.mealType == MealType.dinner.index) {
      menuToShow = widget.foodMenu.dinner;
    }

    return  Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: menuToShow.keys.map<Widget>((String foodType) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          foodType,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.separated(
                        itemCount: menuToShow[foodType]!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: menuToShow[foodType]!.length == 1 
                              ? BorderRadius.all(Radius.circular(10)) // only item
                              : index == 0 // first item
                                  ? BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                  : index == menuToShow[foodType]!.length - 1 // last item
                                    ? BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                                    : BorderRadius.all(Radius.circular(0)), // other items
                                color: colorScheme.secondaryContainer,
                            ),
                            child: ListTile(
                              title: Text(menuToShow[foodType]![index].name),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(menuToShow[foodType]![index].name),
                                      content: Text(menuToShow[foodType]![index].ingredients),
                                    );
                                  }
                                );
                              },
                            ),
                          );
                        }, 
                        separatorBuilder: (BuildContext context, int index) {
                          return Assets().getDivider(context);
                        },
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                      SizedBox(height: 15),
                    ]
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      )
    );
  }
}