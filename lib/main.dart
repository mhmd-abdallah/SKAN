// ignore_for_file: use_super_parameters, unused_import

import 'package:flutter/material.dart';
import 'package:skan/constants/colors.dart';
import 'package:skan/pages/home/screen/addItem.dart';
import 'package:skan/pages/home/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SKan',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: primary,
            ),
      ),
      home: const HomeScreen(),
    );
  }
}
