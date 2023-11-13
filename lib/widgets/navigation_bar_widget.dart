// ignore_for_file: prefer_const_constructors, use_super_parameters, unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:skan/pages/home/screen/LogIn.dart';
import 'package:skan/pages/home/screen/addItem.dart';
import 'package:skan/pages/home/screen/home_screen.dart';

class NavigationBarWidget extends StatelessWidget {
  final Function addItem;
  final Function exportFile;
 
  final Function scanAndNavigateToAddItem;

  const NavigationBarWidget({
    Key? key,
    required this.addItem,
    required this.exportFile,
    
    required this.scanAndNavigateToAddItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              addItem();
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(180),
              color: const Color(0xffffffff),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/icons/plus-sign.png',
                  height: 24,
                  width: 24,
                  color: Color(0xff8391A1),
                ),
              ),
            ),
          ),
          label: 'add',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              scanAndNavigateToAddItem();
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(180),
              color: const Color(0xffffffff),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(
                  'assets/icons/scan.png',
                  height: 24,
                  width: 24,
                  color: Color(0xff8391A1),
                ),
              ),
            ),
          ),
          label: 'scan',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              exportFile();
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(180),
              color: const Color(0xffffffff),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Icon(Icons.file_open,
                size: 40,
                  color: Color(0xff8391A1),
                ),
                
              ),
            ),
          ),
          label: 'export',
        ),
      ],
    );
  }
}
