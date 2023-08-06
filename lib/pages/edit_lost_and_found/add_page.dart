import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/data/lost_item.dart';
import 'dart:io';
import 'package:intl/intl.dart';
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
  final TextEditingController _locationController = TextEditingController(text: " ");

  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  DateTime? _selectedDate;

  XFile? _image;

  double initial = 0.0;
  double distance = 0.0;

  double screenWidth = 0;
  double screenHeight = 0;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  bool _isNameError = false;
  bool _isTimeError = false;
  bool _isLocationError = false;
  bool _isImageError = false;

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_handleNameFocusChange);
    _descriptionFocusNode.addListener(_handleDescriptionFocusChange);
    _locationFocusNode.addListener(_handleLocationFocusChange);
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_handleNameFocusChange);
    _nameFocusNode.dispose();
    _descriptionFocusNode.removeListener(_handleDescriptionFocusChange);
    _descriptionFocusNode.dispose();
    _locationFocusNode.removeListener(_handleLocationFocusChange);
    _locationFocusNode.dispose();
    super.dispose();
  }

  void _handleNameFocusChange() {
    _handleFocusChange(_nameController, _nameFocusNode);
  }

  void _handleDescriptionFocusChange() {
    _handleFocusChange(_descriptionController, _descriptionFocusNode);
  }

  void _handleLocationFocusChange() {
    _handleFocusChange(_locationController, _locationFocusNode);
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
                  buildTextField(_locationController, _locationFocusNode,"Location", 350, _isLocationError),
                  buildTimePicker(context, 350),
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
      tag: "add lost and found container",
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

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
                color: (_isImageError) ? colorScheme.error: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            width: width,
            height: height,
            child: Icon(Icons.camera_alt, size: width * 0.9, color: (_isImageError) ? colorScheme.error: Colors.grey,),
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
        tag: "add lost and found title",
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

  Widget buildTextField(TextEditingController controller, FocusNode focusNode, String labelText, double width, bool isError) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
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

  Widget buildTimePicker(BuildContext context, double width) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: width,
      child: InkWell(
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null && pickedDate != _selectedDate) {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              _selectedDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            }
          }
        },
        child: IgnorePointer(
          child: TextField(
            decoration: InputDecoration(
              labelText: "Select Date and Time",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  width: 1,
                  color: _isTimeError ? colorScheme.error : Colors.grey,
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  width: 1,
                  color: _isTimeError ? colorScheme.error : Colors.grey,
                )
              ),
            ),
            controller: (_selectedDate != null) 
                ? TextEditingController(text: DateFormat('yyyy-MM-dd - kk:mm').format(_selectedDate!))
                : TextEditingController(text: "\n"),
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
          _isTimeError = _selectedDate == null;
          _isLocationError = _locationController.text.trim().isEmpty;
          _isImageError = _image == null;
        });
        if (!_isNameError && !_isLocationError && !_isTimeError && _image != null) {
          Map<String, String> itemData = {
            "item_name": _nameController.text,
            "location_found": _locationController.text,
            "date_found": _selectedDate!.toString(),
            "status": "2",
          };
          if (_descriptionController.text.trim().isNotEmpty) {
            itemData["description"] = _descriptionController.text.trim();
          }
          Navigator.pop(context);
          widget.showUploadingSnackBar();
          var result;
          try {
            result = await Data.apiService.postLostAndFound(itemData, File(_image!.path));
          } catch (e) {
            result = {"status": "error"};
          }
          widget.showUploadingResultSnackBar(result["status"] == "success");
          widget.dismissSnackBar();
          if (result["status"] == "success") {
            Data.lostAndFounds.add(LostItem.fromJson({
              "id": result["id"],
              "item_name": _nameController.text,
              "description": _descriptionController.text,
              "image_url": "/data/lost-and-found/image/${result["id"]}",
              "location_found": _locationController.text,
              "date_found": _selectedDate!.toString(),
              "status": 2,
              "submitter_id": Data.user?.id,
            }));
          }
        }
      },
      child: Text("Submit"),
    );
  }
}