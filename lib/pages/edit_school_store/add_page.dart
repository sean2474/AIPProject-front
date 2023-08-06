import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/data/school_store.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  final VoidCallback showUploadingSnackBar;
  final VoidCallback dismissSnackBar;
  final Function(bool) showUploadingResultSnackBar;

  AddPage({super.key, required this.showUploadingSnackBar, required this.dismissSnackBar, required this.showUploadingResultSnackBar});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late ColorScheme colorScheme;

  final TextEditingController _nameController = TextEditingController(text: " ");
  final TextEditingController _descriptionController = TextEditingController(text: " ");
  final TextEditingController _priceController = TextEditingController(text: " ");
  final TextEditingController _stockController = TextEditingController(text: " ");

  XFile? _image;

  double initial = 0.0;
  double distance = 0.0;

  double screenWidth = 0;
  double screenHeight = 0;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _stockFocusNode = FocusNode();

  bool _isNameError = false;
  bool _isPriceError = false;
  bool _isStockError = false;
  bool _isImageError = false;

  String _currentCategory = "Food";

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_handleNameFocusChange);
    _descriptionFocusNode.addListener(_handleDescriptionFocusChange);
    _priceFocusNode.addListener(_handlePriceFocusChange);
    _stockFocusNode.addListener(_handleStockFocusChange);
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_handleNameFocusChange);
    _nameFocusNode.dispose();
    _descriptionFocusNode.removeListener(_handleDescriptionFocusChange);
    _descriptionFocusNode.dispose();
    _priceFocusNode.removeListener(_handlePriceFocusChange);
    _priceFocusNode.dispose();
    _stockFocusNode.removeListener(_handleStockFocusChange);
    _stockFocusNode.dispose();
    super.dispose();
  }

  void _handleNameFocusChange() {
    _handleFocusChange(_nameController, _nameFocusNode);
  }

  void _handleDescriptionFocusChange() {
    _handleFocusChange(_descriptionController, _descriptionFocusNode);
  }

  void _handlePriceFocusChange() {
    _handleFocusChange(_priceController, _priceFocusNode);
  }

  void _handleStockFocusChange() {
    _handleFocusChange(_stockController, _stockFocusNode);
  }

  void _handleFocusChange(TextEditingController controller, FocusNode node) {
    setState(() {
      if (node.hasFocus) {
        controller.text = controller.text.trim();
      } else {
        controller.text = '${controller.text} ';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
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
        body: Stack(
          children: [
            buildCardHero(),
            SingleChildScrollView(
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
                  buildTitle(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildImageView(),
                      buildTextField(_nameController, _nameFocusNode, "Name", 290, _isNameError),
                    ],
                  ),
                  buildTextField(_priceController, _priceFocusNode, "Price", 350, _isPriceError, isNumber: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCategoryDropdown(),
                      buildTextField(_stockController, _stockFocusNode, "Stock", 225, _isStockError, isNumber: true),
                    ],
                  ),
                  buildDescriptionTextField(),
                  buildSubmitButton(),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Container buildDescriptionTextField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 350,
      height: 300,
      child: TextField(
        controller: _descriptionController,
        focusNode: _descriptionFocusNode,
        maxLines: null,
        expands: true,
        textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          labelText: "Description",
          filled: true,
          contentPadding: const EdgeInsets.all(15.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: colorScheme.secondary,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: colorScheme.secondary,
            )
          ),
        ),
      ),
    );
  }

  Hero buildCardHero() {
    return Hero(
      tag: "add school store container",
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      _isImageError = false;
    });
  }

  Widget buildImageView() {
    double width = 60;
    double height = 60;
    return GestureDetector(
      onTap: pickImage,
      child: _image == null
          ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: (_isImageError) ? Colors.red: colorScheme.secondary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            width: width,
            height: height,
            child: Icon(Icons.camera_alt, size: width * 0.9, color: (_isImageError) ? Colors.red: colorScheme.secondary,),
          )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.secondary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(_image!.path),
                  fit: BoxFit.fill,
                ),
              ),
            ),
    );
  }

  Container buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Hero(
        tag: "add school store title",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add item",
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

  Widget buildTextField(TextEditingController controller, FocusNode focusNode, String labelText, double width, bool isError, {bool isNumber = false}) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          contentPadding: const EdgeInsets.all(15.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: isError ? Colors.red : colorScheme.secondary,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: isError ? Colors.red : colorScheme.secondary,
            )
          ),
        ),
      ),
    );
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          width: 1,
          color: colorScheme.primaryContainer,
        ),
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onPressed: () async {
        setState(() {
          _isNameError = _nameController.text.trim().isEmpty;
          _isPriceError = _priceController.text.trim().isEmpty;
          _isStockError = _stockController.text.trim().isEmpty;
          _isImageError = _image == null;
        });
        if (!_isNameError && !_isPriceError && !_isStockError && !_isImageError) {
          int category = ItemType.na.index;
          if (_currentCategory == "Food") {
            category = ItemType.food.index;
          } else if (_currentCategory == "Drink") {
            category = ItemType.drink.index;
          } else if (_currentCategory == "Goods") {
            category = ItemType.goods.index;
          } else {
            category = ItemType.others.index;
          }
          Map<String, String> itemData = {
            "item_name": _nameController.text,
            "price": _priceController.text.trim(),
            "stock": _stockController.text.trim(), // not in server yet
            "category": category.toString(),
          };
          if (_descriptionController.text.trim().isNotEmpty) {
            itemData["description"] = _descriptionController.text.trim();
          }
          Navigator.pop(context);
          widget.showUploadingSnackBar();
          var result;
          try {
            result = await Data.apiService.postSchoolStoreItem(itemData, File(_image!.path));
          } catch (e) {
            result = {"code": "400"};
          }
          print(result);
          widget.showUploadingResultSnackBar(result["code"] == "200");
          widget.dismissSnackBar();
          if (result["code"] == "200") {
            Data.storeItems.add(StoreItem.fromJson({
              "id": result["id"],
              "item_name": _nameController.text,
              "price": _priceController.text.trim(),
              "stock": _stockController.text.trim(),
              "category": category.toString(),
              "description": _descriptionController.text.trim(),
              "image": result["image"],
            }));
          }
        }
      },
      child: Text("Submit", style: TextStyle(color: colorScheme.primaryContainer),),
    );
  }
  
  Widget buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 1,
          color: colorScheme.secondary,
        ),
      ),
      width: 120,
      height: 55,
      margin: const EdgeInsets.only(left: 5),
      padding: EdgeInsets.all(8),
      child: DropdownButton(
        value: _currentCategory,
        items: [
          "Food",
          "Drink",
          "Goods",
          "Others"
        ].map((value) => DropdownMenuItem(
          value: value,
          child: Text(value),
        )).toList(),
        onChanged: (value) {
          setState(() {
            if (value == "Food") {
              _currentCategory = "Food";
            } else if (value == "Drink") {
              _currentCategory = "Drink";
            } else if (value == "Goods") {
              _currentCategory = "Goods";
            } else {
              _currentCategory = "Others";
            }
          });
        },
        isExpanded: true,
        underline: Container(),
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}