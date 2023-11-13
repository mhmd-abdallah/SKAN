// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:skan/constants/colors.dart';
import 'package:skan/pages/home/screen/deletedProduct_screen.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: AppBar(
        actions: <Widget>[
          Container(
            color: primary,
            padding: const EdgeInsets.only(
              top: 25,
              left: 10,
            ),
            // alignment: Alignment.center,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/logo.png',
                height: 90,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DeletedProduct()));
            },
            child: const Icon(
              Icons.recycling,
              color: Red,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
