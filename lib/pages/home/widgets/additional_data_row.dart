// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class AdditionalDataRow extends StatefulWidget {
  final String dataTitle;
  final List<String> dataValues;
  final addValue;
  final editValues;
  final deleteData;

  AdditionalDataRow({
    required this.dataTitle,
    required this.dataValues,
    required this.addValue,
    required this.deleteData,
    required this.editValues,
  });

  @override
  State<AdditionalDataRow> createState() => _AdditionalDataRowState();
}

class _AdditionalDataRowState extends State<AdditionalDataRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.deleteData,
            child: Icon(
              Icons.close_sharp,
              size: 30,
              color: Red,
            ),
          ),
          Text(
            widget.dataTitle + ': ',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              widget.dataValues.join(', '),
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          Row(
            children: [
              widget.dataValues.toString() != [].toString()
                  ? Container(
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      child: GestureDetector(
                        onTap: widget.editValues,
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Red,
                        ),
                      ),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.only(
                  left: 5,
                ),
                child: GestureDetector(
                  onTap: widget.addValue,
                  child: Icon(
                    Icons.add_circle,
                    size: 30,
                    color: Red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
