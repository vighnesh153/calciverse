import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './simple_button.dart';
import '../providers/expression_handler.dart';

class SimpleCalculator extends StatefulWidget {
  final double height;

  SimpleCalculator(this.height);

  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  final content = [
    [
      {'value': ","},
      {
        'value': "sqrt",
        'backgroundColor': const Color.fromRGBO(200, 200, 200, 1)
      },
      {'value': "%", 'backgroundColor': const Color.fromRGBO(200, 200, 200, 1)},
      {
        'value': "AC",
        'backgroundColor': const Color.fromRGBO(200, 200, 200, 1)
      },
    ],
    [
      {'value': "7"},
      {'value': "8"},
      {'value': "9"},
      {'value': "/", 'backgroundColor': const Color.fromRGBO(200, 200, 200, 1)},
    ],
    [
      {'value': "4"},
      {'value': "5"},
      {'value': "6"},
      {'value': "x", 'backgroundColor': const Color.fromRGBO(200, 200, 200, 1)},
    ],
    [
      {'value': "1"},
      {'value': "2"},
      {'value': "3"},
      {'value': "-", 'backgroundColor': const Color.fromRGBO(200, 200, 200, 1)},
    ],
    [
      {'value': "0"},
      {'value': "."},
      {'value': "=", 'special': true},
      {'value': "+", 'backgroundColor': const Color.fromRGBO(200, 200, 200, 1)},
    ],
  ];

  void _onButtonPress(String value) {
    Provider.of<ExpressionHandler>(context, listen: false).processInput(value);
  }

  Widget buildLeftSlideHintBar(
    BuildContext context,
    double leftSliderWidth,
    double leftSliderHeight,
  ) {
    final themeData = Theme.of(context);

    return Container(
      width: leftSliderWidth,
      height: leftSliderHeight,
      color: themeData.primaryColor,
      child: Center(
        child: Icon(
          Icons.chevron_left,
          color: themeData.accentColor,
        ),
      ),
    );
  }

  Widget buildKeypadLayout(
    BuildContext context,
    double keypadWidth,
    double keypadHeight,
  ) {
    final buttonWidth = (keypadWidth - 10) / 4;
    final buttonHeight = keypadHeight / 5.2;

    return Container(
      width: keypadWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: content
            .map(
              (row) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row
                    .map(
                      (Map<String, Object> item) => SimpleButton(
                        height: buttonHeight,
                        width: buttonWidth,
                        content: item['value'],
                        onPressed: _onButtonPress,
                        backgroundColor: item.containsKey('backgroundColor')
                            ? (item['backgroundColor'] as Color)
                            : null,
                        textColor: item.containsKey('textColor')
                            ? (item['textColor'] as Color)
                            : Theme.of(context).primaryColor,
                        specialButton: item.containsKey('special'),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width;

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildLeftSlideHintBar(
            context,
            availableWidth * 0.06,
            widget.height,
          ),
          buildKeypadLayout(
            context,
            availableWidth * 0.92,
            widget.height,
          ),
        ],
      ),
    );
  }
}
