// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class AddAdditionalValue extends StatefulWidget {
  // const AddAdditionalValue({super.key});
  final List<String> valuesList;
  // final String searchKey;

  AddAdditionalValue(
    this.valuesList,
    // this.searchKey,
  );

  @override
  State<AddAdditionalValue> createState() => _AddAdditionalValueState();
}

class _AddAdditionalValueState extends State<AddAdditionalValue> {
  Color submitTextColor = Colors.white;
  TextEditingController value = TextEditingController();
  Map<String, String> errorMessage = {};

  void addValue(context) {
    if (value.text.isNotEmpty) {
      errorMessage.remove('value');
      widget.valuesList.add(value.text);
      Navigator.of(context).pop();
    } else {
      errorMessage['value'] = 'This field is required';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.only(
        top: 40,
        right: 10,
        left: 10,
      ),
      decoration: const BoxDecoration(
        color: Color(0xffC1C1C1),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            50,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: value,
                style: const TextStyle(
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  hintText: 'New Value',
                  errorText: errorMessage['value'],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => addValue(context),
              onLongPressDown: (details) {
                setState(() {
                  // backGroundSubmit = Colors.white;
                  submitTextColor = Colors.black;
                });
              },
              onLongPressUp: () {
                // addItem(context);
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Red,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(
                  top: 20,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: submitTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
