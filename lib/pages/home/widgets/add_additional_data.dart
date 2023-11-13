// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:skan/constants/dialogs.dart';

import '../../../constants/colors.dart';

class AddAdditionalData extends StatefulWidget {
  // const AddAdditionalData({super.key});
  final Map<String, List<String>> additionalDataList;

  AddAdditionalData(this.additionalDataList);

  @override
  State<AddAdditionalData> createState() => _AddAdditionalDataState();
}

class _AddAdditionalDataState extends State<AddAdditionalData> {
  TextEditingController newData = TextEditingController();
  TextEditingController value = TextEditingController();

  final errorMessage = {};

  void addData(context) {
    if (newData.text.isNotEmpty) {
      errorMessage.remove('title');

      if (widget.additionalDataList.containsKey(newData.text)) {
        showDialog(
          context: context,
          builder: (context) => Dialogs().showFieldExist(context),
        );
      } else {
        widget.additionalDataList[newData.text] =
            value.text.isNotEmpty ? [value.text] : [];
      }
      Navigator.of(context).pop();
    } else {
      errorMessage['title'] = 'This field is required';
    }
    setState(() {});
  }

  Color submitTextColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
                controller: newData,
                style: const TextStyle(
                  fontSize: 22,
                ),
                decoration: InputDecoration(
                  hintText: 'Additional Data',
                  errorText: errorMessage['title'],
                ),
              ),
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(
                top: 20,
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
                  hintText: 'Value',
                ),
              ),
            ),
            GestureDetector(
              onTap: () => addData(context),
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
