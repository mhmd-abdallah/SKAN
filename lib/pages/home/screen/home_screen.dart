// ignore_for_file: use_super_parameters, unnecessary_this, prefer_const_constructors, prefer_typing_uninitialized_variables, unused_import, use_build_context_synchronously

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skan/constants/colors.dart';
import 'package:skan/constants/dialogs.dart';
import 'package:skan/database/products_database.dart';
import 'package:skan/model/product_model.dart';
import 'package:skan/pages/home/screen/LogIn.dart';
import 'package:skan/pages/home/screen/addItem.dart';
import 'package:skan/pages/home/screen/deletedProduct_screen.dart';
import 'package:skan/pages/home/widgets/table_data.dart';

import '../../../widgets/floating_action_button_widget.dart';
import '../../../widgets/navigation_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> items = []; // list of the product items
  TextEditingController barcodeSearched = TextEditingController();
  TextEditingController barcode = TextEditingController();

  var lastId;

  bool exportLoading = false;
  bool saveLoading = false;

  get primary => null;

  @override
  void initState() {
    super.initState();

    //get the data from the database
    refreshProducts();
  }

  Future refreshProducts() async {
    setState(() {
      saveLoading = true;
    });

    //React the active products
    this.items = await ProductsDatabase.instance.readActiveProducts();

    // If the user search for a proudct then we only show the
    // list of products that contains the value searched
    if (barcodeSearched.text.isNotEmpty) {
      items.retainWhere(
          (element) => element.barcode.contains(barcodeSearched.text));
    }

    setState(() {
      saveLoading = false;
    });
  }

  void addItem(context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AddItem(
                  scannedBarcode: ' ',
                )));
    // await showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   isScrollControlled: true,
    //   builder: (context) {
    //     return Padding(
    //       padding:
    //           EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    //       child: AddItemWidget(),
    //     );
    //   },
    // );
    //Refresh products because there is a new product added
    // refreshProducts();
  }

  Future checkPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Permission.storage.request();
    }
    if (status.isGranted) {
      exportExcel();
    }
  }

  void scanBarCode() async {
    await FlutterBarcodeScanner.scanBarcode(
      '#000000',
      'Cancel',
      true,
      ScanMode.BARCODE,
    ).then((value) {
      if (value == '-1') {
        if (barcode.text.isEmpty) {
          barcode.text = '';
        }
      } else {
        barcode.text = value;
      }
    });
  }

  void exportExcel() async {
    if (items.isEmpty) {
      //No data
      showDialog(
          context: context,
          builder: (context) {
            return Dialogs().failureExport(context);
          });
    } else {
      setState(() {
        exportLoading = true;
      });
      //The excel file should be save by the current date and time
      String datetime = DateTime.now().toString().replaceAll(':', '-');

      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Supermarket'];

      excel.delete('Sheet1');
      sheet = excel['Supermarket'];

      List<String> dataList = ProductFields.showedTableValues;
      sheet.insertRowIterables(
        dataList,
        0,
        startingColumn: 0,
        overwriteMergedCells: true,
      );
      for (var i = 0; i < items.length; i++) {
        sheet.insertRowIterables(
          [items[i].id, items[i].name, items[i].barcode, items[i].quantity],
          i + 1,
          startingColumn: 0,
          overwriteMergedCells: true,
        );
      }
      var fileBytes = excel.save();
      File("/storage/emulated/0/Download/$datetime.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      setState(() {
        exportLoading = false;
      });

      showDialog(
          context: context,
          builder: (context) {
            return Dialogs().showSuccessDialog(context);
          });
    }
  }

  void deleteItem(id) {
    showDialog(
      context: context,
      builder: (context) => Dialogs().deleteValidation(
        context: context,
        onDeletePress: () {
          ProductsDatabase.instance.delete(id);
          Navigator.of(context).pop();
          refreshProducts();
        },
      ),
    );
  }

  void editItem(product) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // child: EditItemWidget(
          //   product: product,
          // ),
        );
      },
    );
    refreshProducts();
  }

  void scanAndNavigateToAddItem() async {
    String scannedBarcode = await FlutterBarcodeScanner.scanBarcode(
      '#000000',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    if (scannedBarcode != '-1') {
      // If a barcode is successfully scanned, navigate to the AddItem screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddItem(scannedBarcode: scannedBarcode),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8EDE3),
      appBar: AppBar(
        backgroundColor: Color(0xffDFD3C3),
        toolbarHeight: 100,
        title: const Text(
          'Home',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 100,
        leading: Container(
          color: Color(0x0fffffff),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: Image.asset(
              "assets/icons/back-arrow.png",
              width: 60,
              height: 60,
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                // The deleted products screen
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DeletedProduct()));
              },
              child: Icon(
                Icons.recycling,
                color: Red,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    /*  floatingActionButton: FloatingActionButtonWidget(
        addItem: () => addItem(context),
        exportFile: () => checkPermission(),
      ),*/
      bottomNavigationBar: NavigationBarWidget(
        addItem: () => addItem(context),
        exportFile: () => checkPermission(),
        scanAndNavigateToAddItem: () => scanAndNavigateToAddItem(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) => refreshProducts(),
              controller: barcodeSearched,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search for Barcode Number',
                prefixIcon: Icon(Icons.search, color: Colors.black),
              ),
            ),
            TableData(
              items: this.items, 

              // deleteItem: deleteItem,
              // editItem: editItem,
            ),
          ],
        ),
      ),
    );
  }
}
