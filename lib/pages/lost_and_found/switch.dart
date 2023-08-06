import 'package:flutter/material.dart';

class SettingModal extends StatefulWidget {
  final bool showReturnedItem;
  final Function(bool) onSwitchChange;

  SettingModal({super.key, required this.showReturnedItem, required this.onSwitchChange});

  @override
  _SettingModalState createState() => _SettingModalState();
}

class _SettingModalState extends State<SettingModal> {
  bool _showReturnedItem = false;

  @override
  void initState() {
    super.initState();
    _showReturnedItem = widget.showReturnedItem;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.transparent,
      title: const Text("Show returned items"),
      trailing: Switch(
        value: _showReturnedItem,
        onChanged: (value) {
          setState(() {
            _showReturnedItem = value;
          });
          widget.onSwitchChange(value);
        },
      ),
      onTap: () {
        setState(() {
          _showReturnedItem = !_showReturnedItem;
        });
        widget.onSwitchChange(_showReturnedItem);
      },
    );
  }
}
