// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final Function addItem;
  final Function exportFile;
  const FloatingActionButtonWidget({
    Key? key,
    required this.addItem,
    required this.exportFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            addItem();
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(180),
            color: const Color(0xffDFD3C3),
            child: const SizedBox(
              height: 70,
              width: 70,
              child: Icon(
                Icons.playlist_add,
                color: Colors.black,
                size: 32,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            exportFile();
            // ProductsDatabase.instance.deleteDatabase();
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(180),
            color: const Color(0xffDFD3C3),
            child: const SizedBox(
              height: 70,
              width: 70,
              child: Icon(
                Icons.file_open,
                color: Colors.black,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
