import 'package:flutter/material.dart';

class ButtonTwoStates extends StatefulWidget {
  const ButtonTwoStates({
    this.isOn = false,
    this.onChange,
  });

  final bool isOn;
  final ValueChanged<bool>? onChange;

  @override
  _ButtonTwoStatesState createState() => _ButtonTwoStatesState();
}

class _ButtonTwoStatesState extends State<ButtonTwoStates> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();

    _isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: _toggleState,
      child: Container(
        width: 80.0,
        height: 56.0,
        color: _isOn ? Colors.red : Colors.green,
      ),
    );

  void _toggleState() {
    _isOn = !_isOn;
    setState(() {});
    widget.onChange?.call(_isOn);
  }
}
