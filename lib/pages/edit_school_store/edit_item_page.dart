import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/data/school_store.dart';
import 'package:front/pages/school_store/school_store.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditItemPage extends StatefulWidget {
  final StoreItem itemData;
  final int itemIndex;
  final VoidCallback onEdit;
  final VoidCallback showUploadingSnackBar;
  final VoidCallback dismissSnackBar;
  final Function(bool) showUploadingResultSnackBar;
  
  EditItemPage({
    super.key,
    required this.itemData, 
    required this.itemIndex, 
    required this.onEdit, 
    required this.showUploadingSnackBar, 
    required this.dismissSnackBar, 
    required this.showUploadingResultSnackBar
  });

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late ColorScheme colorScheme;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

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

  String _currentCategory = "Food";

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_handleNameFocusChange);
    _descriptionFocusNode.addListener(_handleDescriptionFocusChange);
    _priceFocusNode.addListener(_handlePriceFocusChange);
    _stockFocusNode.addListener(_handleStockFocusChange);

    _nameController = TextEditingController(text: widget.itemData.name);
    _descriptionController = TextEditingController(text: widget.itemData.description);
    _priceController = TextEditingController(text: widget.itemData.price.toString());
    _stockController = TextEditingController(text: widget.itemData.stock.toString());
    _currentCategory = itemTypeToString(widget.itemData.itemType);
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

    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
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
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
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
    });
  }

  Widget buildImageView() {
    double width = 60;
    double height = 60;
    return GestureDetector(
      onTap: pickImage,
      child: _image == null
          ? Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: widget.itemData.imageUrl,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              ),
            )
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
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
      child: Text(
        "Edit Item",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
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
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: isError ? colorScheme.error : Colors.grey,
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: isError ? colorScheme.error : Colors.grey,
            )
          ),
        ),
      ),
    );
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onPressed: () async {
        setState(() {
          _isNameError = _nameController.text.trim().isEmpty;
          _isPriceError = _priceController.text.trim().isEmpty;
          _isStockError = _stockController.text.trim().isEmpty;
        });
        if (!_isNameError && !_isPriceError && !_isStockError) {
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
          File? imageFile = _image != null ? File(_image!.path) : null;
          Navigator.pop(context);
          widget.showUploadingSnackBar();
          var result;
          try {
            result = await Data.apiService.putSchoolStoreItem(widget.itemData.id, itemData, imageFile);
          } catch (e) {
            print(e);
            result = {"status": "fail"};
          }
          print(result);
          widget.showUploadingResultSnackBar(result["status"] == "success");
          widget.dismissSnackBar();
          if (result["status"] == "success") {
            Data.storeItems[widget.itemIndex] = StoreItem.fromJson({
              "ID": result["id"],
              "Product_Name": _nameController.text,
              "Price": double.parse(_priceController.text.trim()),
              "Stock": int.parse(_stockController.text.trim()),
              "Category": category,
              "Description": _descriptionController.text.trim(),
              "Date_Added": "0001-01-01T00:00:00Z",
            });
          }
        }
      },
      child: Text("Submit"),
    );
  }
  
  Widget buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        color: colorScheme.background,
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
          "Others",
          "N/A"
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
            } else if (value == "Others") {
              _currentCategory = "Others";
            } else {
              _currentCategory = "N/A";
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