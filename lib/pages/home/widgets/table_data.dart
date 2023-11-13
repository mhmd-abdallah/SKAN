// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_to_list_in_spreads, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

//import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:skan/constants/colors.dart';
import 'package:skan/pages/home/screen/addItem.dart';
import 'package:skan/pages/home/screen/editItem.dart';
import 'package:skan/pages/home/screen/home_screen.dart';

import '../../../model/product_model.dart';
import '../screen/detailsScreen.dart';
import 'package:skan/database/products_database.dart';

import '../../../constants/dialogs.dart';


// This widget is created to reduce code duplication

class TableData extends StatefulWidget {
  final List<Product> items; // Items to be shown
 
 

  
  final columns = ProductFields.showedTableValues;

  TableData({
    required this.items,

  });

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  
  
  // Style for the columns fields to reduce code duplication
  final columnsStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  // Style for the row data to reduce code duplication
  final rowStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );
late String message;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(
            // To have extra empty space to the floating action button widgets
            bottom: 90,
          ),
          child: DataTable(
            // ignore: deprecated_member_use
            dataRowHeight: 65,

            headingRowColor: MaterialStateProperty.all(Color(0xffF2F2F2)),
            dataRowColor: MaterialStateProperty.all(Color(0xffD8D8D8)),
            dividerThickness: 2,
            border: TableBorder.all(
              color: Colors.grey,
            ),
            //mapping over the columns fields
            /*columns: [
              ...widget.columns.map(
                (column) => DataColumn(
                  label: Text(
                    column,
                    style: columnsStyle,
                  ),
                  numeric: column == 'ID' ? true : false,
                ),
              ),
            ],*/
            columns: [
              DataColumn(
                label: Text(
                  'Buttons',
                  style: columnsStyle,
                ),
              ),
              ...widget.columns.map(
                (column) {
                  if (column == 'ID') {
                    return DataColumn(
                      label: Text(
                        column,
                        style: columnsStyle,
                      ),
                      numeric: true,
                    );
                  } else {
                    return DataColumn(
                      label: Text(
                        column,
                        style: columnsStyle,
                      ),
                    );
                  }
                },
              ),
            ],

            //mapping over the products
            rows: [
              ...widget.items
                  .map(
                    (product) => DataRow(
                      onLongPress: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsScreen(product: product),
                          ),
                        );
                      },
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1, color: Color(0xFFF2F2F2)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffFFFFFF),
                                      Color(0xffFFFFFF)
                                    ],
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                  
                                  },
                                  child: Image.asset(
                                    'assets/icons/trash.png',
                                    color: Color(0xFFFF5858),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1, color: Color(0xFFF2F2F2)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xffFFFFFF),
                                        Color(0xffFFFFFF)
                                      ],
                                    ),
                                  
                                    ),
                                child: InkWell(
                                  onTap: () {
         Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddItem(scannedBarcode: '',),
                  ),
                );
                                  },
                                  child: Image.asset(
                                    'assets/icons/edit.png',
                                    color: Color(0xff4ACD57),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1, color: Color(0xFFF2F2F2)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xffFFFFFF),
                                        Color(0xffFFFFFF)
                                      ],
                                    ),
                                    color: Colors.purpleAccent
                                    //Color(0xff4ACD57),
                                    ),
                                child: InkWell(
                                  onTap: () {
                                    // Your onTap functionality here
                                  },
                                  child: Image.asset(
                                    'assets/icons/icons8-plus-sign-32.png',
                                    color: Color(0xff8391A1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            product.id.toString(),
                            style: rowStyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            product.name,
                            style: rowStyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            product.barcode,
                            style: rowStyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            product.quantity,
                            style: TextStyle(
                              color: Red,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
