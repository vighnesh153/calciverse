import 'package:flutter/material.dart';

import './combinatorics_screen.dart';

class MultinomialCoefficientsScreen extends StatefulWidget {
  static const routeName =
      CombinatoricsScreen.routeName + '/multinomial-coefficients';

  @override
  _MultinomialCoefficientsScreenState createState() =>
      _MultinomialCoefficientsScreenState();
}

class _MultinomialCoefficientsScreenState
    extends State<MultinomialCoefficientsScreen> {
  var nTextEditingController = TextEditingController();
  var rTextEditingController = TextEditingController();
  BigInt result;

  bool areInputsValid() {
    if (nTextEditingController.text.isEmpty ||
        int.tryParse(nTextEditingController.text) == null) {
      return false;
    }

    if (rTextEditingController.text.isEmpty) {
      return false;
    }

    final split = rTextEditingController.text.split(',');
    var isValid = true;
    final n = int.parse(nTextEditingController.text);
    split.forEach((item) {
      final parsed = int.tryParse(item);
      if (parsed == null || parsed > n || parsed < 0) {
        isValid = false;
      }
    });
    return isValid;
  }

  void showErrorSnackBar(BuildContext ctx,
      {String message = 'Invalid values!'}) {
    Scaffold.of(ctx).hideCurrentSnackBar();
    Scaffold.of(ctx).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  BigInt multinomialCoefficients(int n, List<int> list) {
    var res = BigInt.from(1);
    for (int i = 1; i <= n; i++) {
      res *= BigInt.from(i);
    }

    list.forEach((r) {
      for (int j = 1; j <= r; j++) {
        res = BigInt.from(res / BigInt.from(j));
      }
    });

    return res;
  }

  void calculate(BuildContext ctx) {
    if (areInputsValid() == false) {
      showErrorSnackBar(ctx);
      return;
    }

    final n = int.parse(nTextEditingController.text);

    final split = rTextEditingController.text.split(',');
    final list = <int>[];
    split.forEach((item) {
      list.add(int.parse(item));
    });

    // To close the keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      try {
        result = multinomialCoefficients(n, list);
      } catch (error) {
        result = BigInt.from(-1);
      }
    });
  }

  void clearFields() {
    setState(() {
      nTextEditingController.text = "";
      rTextEditingController.text = "";
      result = null;
    });
  }

  Text styledText(String data) {
    return Text(
      data,
      style: TextStyle(fontSize: 20),
    );
  }

  Widget getInputBox(TextEditingController textEditingController) {
    final themeData = Theme.of(context);

    return Container(
      width: 150,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: themeData.primaryColor),
      ),
      child: TextField(
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        controller: textEditingController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  Widget getOutputBox() {
    final themeData = Theme.of(context);
    final output = result == null
        ? ''
        : (result == BigInt.from(-1)
            ? 'Currently not supporting huge numbers!'
            : result.toString());

    return SingleChildScrollView(
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: themeData.primaryColor)),
        child: Text(output,
            style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
      ),
    );
  }

  Row getInputRow(String data, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        styledText(data),
        styledText('='),
        getInputBox(controller),
      ],
    );
  }

  Widget getOutputRow(String data) {
    return Container(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          styledText(data),
          styledText('='),
          getOutputBox(),
        ],
      ),
    );
  }

  Widget getBody() {
    final themeData = Theme.of(context);

    return Builder(
      builder: (ctx) => Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Input',
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              getInputRow(
                                  '        N  ', nTextEditingController),
                              getInputRow('List<R>', rTextEditingController),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: const Text(
                            'comma separated +ve integers',
                            textAlign: TextAlign.end,
                            softWrap: true,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MaterialButton(
                              height: 35,
                              minWidth: 70,
                              elevation: 5,
                              child: Text(
                                'CLEAR',
                                style: TextStyle(color: themeData.accentColor),
                              ),
                              onPressed: clearFields,
                              color: themeData.primaryColor,
                            ),
                            MaterialButton(
                              height: 35,
                              minWidth: 70,
                              elevation: 5,
                              child: Icon(
                                Icons.check,
                                size: 22,
                                color: themeData.accentColor,
                              ),
                              onPressed: () => calculate(ctx),
                              color: themeData.primaryColor,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                width: 300,
                height: 230,
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 300,
                  height: 150,
                  child: Column(
                    children: <Widget>[
                      const Text('Output', style: TextStyle(fontSize: 25)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: getOutputRow('Answer'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Multinomial Coefficients'),
        ),
        body: SingleChildScrollView(child: getBody()),
      ),
    );
  }
}
