// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:skan/database/products_database.dart';
import 'package:skan/model/product_model.dart';
import 'package:skan/pages/home/screen/editItem.dart';
import 'package:skan/pages/home/screen/home_screen.dart';

import '../../../constants/colors.dart';
import '../../../constants/dialogs.dart';

class DetailsScreen extends StatefulWidget {
  // const DetailsScreen({super.key});
  final Product product;

  DetailsScreen({
    required this.product,
  });
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic> productMap = {};
  List<Map<String, String>> additionalData = [];

  bool deleted = false;

  TextStyle rowFieldStyle = TextStyle(
    fontSize: 25,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );
  TextStyle rowValueStyle = TextStyle(
    fontSize: 25,
    color: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    productMap = widget.product.toMap();
    additionalData =
        await ProductsDatabase.instance.readAdditionalData(widget.product.id);
    productMap.remove('Deleted');
    deleted = widget.product.deleted;
    setState(() {});
  }

  void deleteItem(id) {
    showDialog(
      context: context,
      builder: (context) => Dialogs().deleteValidation(
        context: context,
        onDeletePress: () {
          ProductsDatabase.instance.delete(id);
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
          // refreshProducts();
        },
      ),
    );
    setState(() {});
    // Navigator.of(context).pop();
  }

  void restoreItem(id) {
    showDialog(
      context: context,
      builder: (context) => Dialogs().restoreValidation(
        context: context,
        onDeletePress: () {
          ProductsDatabase.instance.restore(id);
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8EDE3),
      appBar: AppBar(
        // backgroundColor: Colors.green[300],
        backgroundColor: Red,
        title: Text(
          widget.product.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditItem(widget.product, additionalData),
                  ),
                );
              },
              child: Icon(
                Icons.edit,
                size: 30,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                deleted == false
                    ? deleteItem(widget.product.id)
                    : restoreItem(widget.product.id);
              },
              child: deleted == false
                  ? Icon(
                      Icons.delete,
                      size: 30,
                    )
                  : Icon(
                      Icons.restore,
                      size: 30,
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 7, left: 7),
          padding: EdgeInsets.fromLTRB(15, 13, 15, 13),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'Field',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Value',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: [
              ...productMap.entries.map(
                (entry) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        entry.key,
                        style: rowFieldStyle,
                      ),
                    ),
                    DataCell(
                      Text(
                        entry.value.toString(),
                        style: rowValueStyle,
                      ),
                    ),
                  ],
                ),
              ),
              ...additionalData.map(
                (data) => DataRow(cells: [
                  DataCell(
                    Text(
                      data.keys.first,
                      style: rowFieldStyle,
                    ),
                  ),
                   data.values.first.isEmpty
                      ? 
                      DataCell(Text(
                          '1',
                            
                          style: rowValueStyle,
                        ))
                      :
                      // additional data
                      DataCell(
                          Text(
                            data.values.first,
                            style: rowValueStyle,
                          ),
                        ),
                
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
