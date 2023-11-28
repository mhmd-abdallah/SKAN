// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, use_key_in_widget_constructors, file_names, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:skan/constants/colors.dart';
import 'package:skan/database/products_database.dart';
import 'package:skan/model/product_model.dart';
import 'package:skan/pages/home/widgets/add_additional_data.dart';
import 'package:skan/pages/home/widgets/add_additional_value.dart';
import 'package:skan/pages/home/widgets/additional_data_row.dart';

import '../../../constants/dialogs.dart';
import '../widgets/edit_values_widget.dart';
import '../widgets/inputText.dart';
import 'home_screen.dart';

class AddItem extends StatefulWidget {
  // const AddItem({super.key});

  final String scannedBarcode; // Add this property

  const AddItem({required this.scannedBarcode});

  @override
  State<AddItem> createState() => _AddItemState(scannedBarcode: '');
}

class _AddItemState extends State<AddItem> {
  String requiredFieldMessage = 'This field is required';
  late String scannedBarcode;

  late int id;
  _AddItemState({required this.scannedBarcode});

  TextEditingController barcode = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();

  TextEditingController description = TextEditingController();
  TextEditingController purchasePrice = TextEditingController();
  TextEditingController regularPrice = TextEditingController();
  TextEditingController addData = TextEditingController();
  Map<String, String> errorMessages = {};

  Map<String, List<String>> additionalDataList = {};

  @override
  void initState() {
    super.initState();
    refresh();
    barcode.text = widget.scannedBarcode;
  }

  void refresh() async {
    id = await ProductsDatabase.instance.lastId() + 1;
    ProductsDatabase.instance.addAdditionalData(
      id: id,
      key: 'Description',
      value: description.text,
    );
    ProductsDatabase.instance.addAdditionalData(
      id: id,
      key: 'RegularPrice',
      value: regularPrice.text,
    );
    ProductsDatabase.instance.addAdditionalData(
      id: id,
      key: 'PurchasePrice',
      value: purchasePrice.text,
    );

    setState(() {});
  }

  /*void scanBarCode() async {
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
  }*/
  void scanBarCode() async {
    await FlutterBarcodeScanner.scanBarcode(
      '#000000',
      'Cancel',
      true,
      ScanMode.BARCODE,
    ).then((value) {
      if (value != '-1') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddItem(scannedBarcode: value),
          ),
        );
      }
    });
  }

  void toHomeScreen() {
    if (barcode.text.isNotEmpty ||
        name.text.isNotEmpty ||
        description.text.isNotEmpty ||
        quantity.text.isNotEmpty ||
        purchasePrice.text.isNotEmpty ||
        regularPrice.text.isNotEmpty ||
        additionalDataList.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialogs().existValidation(context, HomeScreen());
          });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  void checkRequiredFields() {
    if (barcode.text.isEmpty)
      errorMessages['Barcode Number'] = requiredFieldMessage;
    else
      errorMessages.remove('Barcode Number');

    if (name.text.isEmpty)
      errorMessages['Name'] = requiredFieldMessage;
    else
      errorMessages.remove('Name');

    if (quantity.text.isEmpty)
      errorMessages['Quantity'] = requiredFieldMessage;
    else
      errorMessages.remove('Quantity');
  }

  void addProduct(context) async {
    //Check the required fields
    if (barcode.text.isNotEmpty &&
        name.text.isNotEmpty &&
        quantity.text.isNotEmpty) {
      // int id = await ProductsDatabase.instance.lastId() + 1;

      int barcodeExit =
          await ProductsDatabase.instance.oldProduct(barcode.text);
//values of items in the home screen
      final Product product = Product(
        id: barcodeExit == -1 ? id : barcodeExit,
        name: name.text,
        barcode: barcode.text,
        quantity: quantity.text ,
        description: description.text,
        purchasePrice: purchasePrice.text,
        regularPrice: regularPrice.text,
        deleted: false,
      );

      if (regularPrice.text.isNotEmpty &&
          purchasePrice.text.isNotEmpty &&
          double.parse(regularPrice.text) >= double.parse(purchasePrice.text)) {
        showDialog(
          context: context,
          builder: (context) => Dialogs().pricesError(context),
        );
      } else {
        // Not Exist
        if (barcodeExit == -1) {
          // additionalDataList['Description'] = [description.text];
          // additionalDataList['RegularPrice'] = [regularPrice.text];
          // additionalDataList['PurchasePrice'] = [purchasePrice.text];

          ProductsDatabase.instance.create(product);

          additionalDataList.forEach((key, value) {
            ProductsDatabase.instance.addAdditionalData(
              id: product.id,
              key: key,
              value: value.join(', '),
            );
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else if (barcodeExit == 0) {
          //Exist in the active product
          showDialog(
            context: context,
            builder: (context) => Dialogs().showProductExist(context),
          );
        } else {
          // Exist with old id
          // Show dialog to go to the deleted product

          showDialog(
            context: context,
            builder: (context) =>
                Dialogs().productExistInTheDeletedSection(context),
          );
        }
      }
    } else {
      checkRequiredFields();
    }
    setState(() {});
  }

  void addAdditionalData() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddAdditionalData(additionalDataList),
        );
      },
    );
    setState(() {});
  }

  void addAdditionalValue(key) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddAdditionalValue(additionalDataList[key]!),
        );
      },
    );
    setState(() {});
  }

  void editValues(key) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditValues(additionalDataList[key]!),
        );
      },
    );
    setState(() {});
  }

  void deleteAdditionalData(key) {
    showDialog(
      context: context,
      builder: (context) => Dialogs().deleteValueValidation(
        context: context,
        onDeletePress: () {
          additionalDataList.remove(key);
          Navigator.of(context).pop();

          setState(() {});
        },
      ),
    );
    setState(() {});
  }
/*
void addbarcode(context) async {
  if (barcode.text.isNotEmpty) {
    // Check if a product with the same barcode already exists
    int barcodeExit = await ProductsDatabase.instance.oldProduct(barcode.text);

    if (barcodeExit == -1) {
      // Barcode doesn't exist, create a new product
      final Product product = Product(
        id: id,
        name: name.text,
        barcode: barcode.text,
        quantity: quantity.text,
        deleted: false,
      );

      ProductsDatabase.instance.create(product);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddItem(),
        ),
      );
    } else {
      // Barcode already exists
      showDialog(
        context: context,
        builder: (context) => Dialogs().showProductExist(context),
      );
    }
  } else {
    // Barcode field is empty
    checkRequiredFields();
  }
  setState(() {});
}
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8EDE3),
      appBar: AppBar(
        // backgroundColor: Colors.green[300],
        backgroundColor: Red,
        title: const Text('Add a New Product'),
        leading: GestureDetector(
          onTap: toHomeScreen,
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: inputText(
                              placeholder: 'Barcode Number',
                              controller: barcode,
                              numeric: true,
                              errorMessages: errorMessages,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: scanBarCode,
                              child: Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, // Make it a circle
                                  border: Border.all(
                                    color: Color(0xff8391a1), // Border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 50,
                                  color: Color(0xff8391a1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      inputText(
                        placeholder: 'Name',
                        controller: name,
                        errorMessages: errorMessages,
                      ),
                      inputText(
                        placeholder: 'Description (if any)',
                        controller: description,
                        errorMessages: errorMessages,
                      ),
                      inputText(
                        placeholder: 'Quantity',
                        controller: quantity,
                        numeric: true,
                        errorMessages: errorMessages,
                      ),
                      inputText(
                        placeholder: 'Regular Price',
                        controller: regularPrice,
                        numeric: true,
                        errorMessages: errorMessages,
                      ),
                      inputText(
                        placeholder: 'Purchase Price',
                        controller: purchasePrice,
                        numeric: true,
                        errorMessages: errorMessages,
                      ),
                      GestureDetector(
                        onTap: addAdditionalData,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          padding: EdgeInsets.all(10),
                          color: Color.fromARGB(255, 44, 42, 42),
                          child: Text(
                            'Add Additional Data',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      ...additionalDataList.entries.map(
                        (entry) => AdditionalDataRow(
                          dataTitle: entry.key,
                          dataValues: entry.value,
                          addValue: () => addAdditionalValue(entry.key),
                          deleteData: () => deleteAdditionalData(entry.key),
                          editValues: () => editValues(entry.key),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => addProduct(context),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Red,
                            ),
                            height: 50,
                            margin: EdgeInsets.only(
                              top: 20,
                              right: 20,
                            ),
                            padding: EdgeInsets.all(10),
                            // color: Color.fromARGB(255, 64, 143, 67),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.grey,
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset(
                        'assets/icons/LogoSkan.jpg',
                      ).image,
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
