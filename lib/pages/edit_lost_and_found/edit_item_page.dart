import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/data/lost_item.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class EditItemPage extends StatefulWidget {
  final LostItem itemData;
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
  late final TextEditingController _locationController;

  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  DateTime? _selectedDate;

  XFile? _image;

  double initial = 0.0;
  double distance = 0.0;

  double screenWidth = 0;
  double screenHeight = 0;

  String? _currentStatus;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  bool _isNameError = false;
  bool _isLocationError = false;

  @override
  void initState() {
    super.initState();

    _nameFocusNode.addListener(_handleNameFocusChange);
    _descriptionFocusNode.addListener(_handleDescriptionFocusChange);
    _locationFocusNode.addListener(_handleLocationFocusChange);

    _nameController = TextEditingController(text: widget.itemData.name);
    _descriptionController = TextEditingController(text: "${widget.itemData.description} ");
    _locationController = TextEditingController(text: widget.itemData.locationFound);
    _selectedDate = DateTime.tryParse(widget.itemData.dateFound);

    if (widget.itemData.status == FoundStatus.lost) {
      _currentStatus = "Lost";
    } else if (widget.itemData.status == FoundStatus.returned) {
      _currentStatus = "Returned";
    } else {
      _currentStatus = "N/A";
    }
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_handleNameFocusChange);
    _nameFocusNode.dispose();
    _descriptionFocusNode.removeListener(_handleDescriptionFocusChange);
    _descriptionFocusNode.dispose();
    _locationFocusNode.removeListener(_handleLocationFocusChange);
    _locationFocusNode.dispose();

    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
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
            SizedBox(height: 10),
            buildTitle(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImageView(),
                buildTextField(_nameController, _nameFocusNode, "Name", 290, _isNameError),
              ],
            ),
            buildTextField(_locationController, _locationFocusNode,"Location", 350, _isLocationError),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildStatusDropdown(),
                buildTimePicker(context, 225),
              ]
            ),
            buildDescriptionTextField(),
            buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget buildStatusDropdown() {
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
        value: _currentStatus,
        items: [
          "Lost",
          "Returned",
          "N/A",
        ].map((value) => DropdownMenuItem(
          value: value,
          child: Text(value),
        )).toList(),
        onChanged: (value) {
          setState(() {
            if (value == "Returned") {
              _currentStatus = "Returned";
            } else if (value == "Lost") {
              _currentStatus = "Lost";
            } else {
              _currentStatus = "N/A";
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

  Container buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

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
                borderRadius: BorderRadius.circular(10),
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
            // ignore: use_build_context_synchronously
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
          _isLocationError = _locationController.text.trim().isEmpty;
        });

        int status = FoundStatus.na.index;
        if (_currentStatus == "Lost") {
          status = FoundStatus.lost.index;
        } else if (_currentStatus == "Returned") {
          status = FoundStatus.returned.index;
        } 
        if (!_isNameError && !_isLocationError) {
          Map<String, String> itemData = {
            "id": "${widget.itemData.id}",
            "item_name": _nameController.text,
            "location_found": _locationController.text,
            "date_found": _selectedDate!.toString(),
            "status": "$status",
          };
          if (_descriptionController.text.trim().isNotEmpty) {
            itemData["description"] = _descriptionController.text.trim();
          }
          Navigator.pop(context);
          widget.showUploadingSnackBar();
          File? imageFile = _image != null ? File(_image!.path) : null;
          var result;
          try {
            result = await Data.apiService.putLostAndFound(widget.itemData.id, itemData, imageFile);
          } catch (e) {
            debugPrint(e.toString());
          }
          widget.showUploadingResultSnackBar(result != null && result["status"] == "success");
          widget.dismissSnackBar();
          if (result != null && result["status"] == "success") {
            Data.lostAndFounds[widget.itemIndex] = LostItem.fromJson({
              "id": result["id"],
              "item_name": _nameController.text,
              "description": _descriptionController.text,
              "image_url": "/data/lost-and-found/image/${result["id"]}",
              "location_found": _locationController.text,
              "date_found": _selectedDate!.toString(),
              "status": status,
              "submitter_id": Data.user?.id,
            });
          }
          widget.onEdit();
        }
      },
      child: Text("Submit"),
    );
  }
}