// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget inputText({placeholder, controller, numeric, errorMessages}) =>
    Container(
      // color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          right: 10,
          // left: 10,
        ),
        child: TextField(
          controller: controller,
          keyboardType: numeric == true ? TextInputType.number : null,
          inputFormatters: numeric == true
              ? [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[1-9][0-9]*\.?[0-9]*')),
                ]
              : null,
          decoration: InputDecoration(
            hintText: placeholder,
            errorText:
                errorMessages != null ? errorMessages[placeholder] : null,
            errorStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffDADADA),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffDADADA),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            hintStyle: const TextStyle(color: Color(0xff8391a1)),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
