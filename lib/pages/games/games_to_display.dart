import 'package:flutter/material.dart';
import 'package:front/widgets/assets.dart';
import 'package:numberpicker/numberpicker.dart';

class GamesToDisplayPage extends StatefulWidget {
  final int gamesToDisplay;
  final String text;
  final Function(int) onChange;
  final int minValue;
  final int maxValue;
  GamesToDisplayPage({super.key, required this.gamesToDisplay, required this.text, required this.onChange, this.maxValue = 5, this.minValue = 0});

  @override
  GamesToDisplayPageState createState() => GamesToDisplayPageState();
}

class GamesToDisplayPageState extends State<GamesToDisplayPage> {
  late ColorScheme colorScheme;
  int _gamesToDisplay = 3;

  @override
  void initState() {
    super.initState();
    _gamesToDisplay = widget.gamesToDisplay;
  }
  
  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets().buttomSheetModalTopline(),
              Text(
                widget.text,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
              ),
            ],
          ),
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorScheme.background,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _gamesToDisplay = _gamesToDisplay > widget.minValue ? _gamesToDisplay - 1 : 0;
                        widget.onChange(_gamesToDisplay);
                      });
                    }, 
                    icon: Icon(Icons.remove_rounded, size: 30,),
                  ),
                ),
                SizedBox(width: 10.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorScheme.background,
                  ),
                  child: NumberPicker(
                    value: _gamesToDisplay,
                    minValue: widget.minValue,
                    maxValue: widget.maxValue,
                    axis: Axis.horizontal,
                    step: 1,
                    itemHeight: 50,
                    itemWidth: 70,
                    onChanged: (value) => setState(() {
                      _gamesToDisplay = value;
                      widget.onChange(value);
                    }),
                    selectedTextStyle: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 10.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorScheme.background,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _gamesToDisplay = _gamesToDisplay < widget.maxValue ? _gamesToDisplay + 1 : widget.maxValue;
                        widget.onChange(_gamesToDisplay);
                      });
                    }, 
                    icon: Icon(Icons.add_rounded, size: 30,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
