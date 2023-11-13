// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/dialogs.dart';

class EditValues extends StatefulWidget {
  // const EditValues({super.key});
  final List<String> values;
  // final keySearched;

  EditValues(
    this.values,
    // this.keySearched,
  );

  @override
  State<EditValues> createState() => _EditValuesState();
}

class _EditValuesState extends State<EditValues> {
  void deleteValue(context, value) {
    showDialog(
      context: context,
      builder: (context) => Dialogs().deleteValueValidation(
        context: context,
        onDeletePress: () {
          widget.values.remove(value);
          Navigator.of(context).pop();
          if (widget.values.isEmpty) {
            Navigator.of(context).pop();
          }
          setState(() {});
        },
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      padding: EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
        bottom: 40,
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
        padding: EdgeInsets.only(
          left: 20,
          top: 10,
        ),
        child: Column(
          children: [
            ...widget.values.map(
              (value) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => deleteValue(context, value),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
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
