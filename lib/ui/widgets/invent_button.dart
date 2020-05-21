import 'package:flutter/material.dart';

class InventoryButton extends StatelessWidget {
  final String text;
  final Function function;

  InventoryButton(this.text, this.function);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14)),
          ),
      ),
      onPressed: function,
    );
  }

}
