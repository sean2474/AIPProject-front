import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final bool value;
  final Function(bool) onSwitchChange;
  final String text;
  final bool disabled;

  SwitchWidget({super.key, required this.value, required this.onSwitchChange, required this.text, this.disabled = false});

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.transparent,
      title: Text(widget.text),
      trailing: Switch(
        value: _value,
        onChanged: widget.disabled ? null : (value) {
          setState(() {
            _value = value;
          });
          widget.onSwitchChange(value);
        },
      ),
      onTap: widget.disabled ? null : () {
        setState(() {
          _value = !_value;
        });
        widget.onSwitchChange(_value);
      },
    );
  }
}
