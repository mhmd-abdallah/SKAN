// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_final_fields, curly_braces_in_flow_control_structures, avoid_print, prefer_const_constructors, avoid_unnecessary_containers, file_names, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:skan/constants/colors.dart';
import 'package:skan/model/product_model.dart';
import 'package:skan/pages/home/screen/detailsScreen.dart';
import 'package:skan/pages/home/widgets/add_additional_data.dart';
import 'package:skan/pages/home/widgets/add_additional_value.dart';
import 'package:skan/pages/home/widgets/additional_data_row.dart';

import '../../../constants/dialogs.dart';
import '../../../database/products_database.dart';
import '../widgets/edit_values_widget.dart';
import '../widgets/inputText.dart';

class EditItem extends StatefulWidget {
  // const AddItem({super.key});
  final Product product;
  final List<Map<String, String>> oldAdditionalData;

  EditItem(
    this.product,
    this.oldAdditionalData,
  );

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  String requiredFieldMessage = 'This field is required';

  TextEditingController barcode = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();

  TextEditingController description = TextEditingController();
  TextEditingController purchasePrice = TextEditingController();
  TextEditingController regularPrice = TextEditingController();
  Map<String, String> _errorMessages = {};

  Map<String, List<String>> newAdditionalData = {};
  Map<String, List<String>> oldAdditionalData = {};
  Map<String, int> updatedData = {};

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    barcode.text = widget.product.barcode;
    name.text = widget.product.name;
    quantity.text = widget.product.quantity;

    description.text = widget.oldAdditionalData
        .firstWhere((element) => element.keys.contains('Description'))
        .values
        .first;
    regularPrice.text = widget.oldAdditionalData
        .firstWhere((element) => element.keys.contains('RegularPrice'))
        .values
        .first;
    purchasePrice.text = widget.oldAdditionalData
        .firstWhere((element) => element.keys.contains('PurchasePrice'))
        .values
        .first;

    widget.oldAdditionalData
        .removeWhere((item) => item.containsKey('Description'));
    widget.oldAdditionalData
        .removeWhere((item) => item.containsKey('RegularPrice'));
    widget.oldAdditionalData
        .removeWhere((item) => item.containsKey('PurchasePrice'));

    widget.oldAdditionalData.forEach((data) =>
        oldAdditionalData[data.keys.first] = [
          ...data.values.first.split(', ')
        ]);
    setState(() {});
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

  void toHomeScreen() {
    if (barcode.text.isNotEmpty ||
        name.text.isNotEmpty ||
        description.text.isNotEmpty ||
        quantity.text.isNotEmpty ||
        purchasePrice.text.isNotEmpty ||
        regularPrice.text.isNotEmpty ||
        newAdditionalData.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialogs().existValidation(
              context,
              DetailsScreen(product: widget.product),
            );
          });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(product: widget.product),
        ),
      );
    }
  }

  void checkRequiredFields() {
    if (barcode.text.isEmpty)
      _errorMessages['Barcode Number'] = requiredFieldMessage;
    else
      _errorMessages.remove('Barcode Number');

    if (name.text.isEmpty)
      _errorMessages['Name'] = requiredFieldMessage;
    else
      _errorMessages.remove('Name');

    if (quantity.text.isEmpty)
      _errorMessages['Quantity'] = requiredFieldMessage;
    else
      _errorMessages.remove('Quantity');
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
          child: AddAdditionalData(newAdditionalData),
        );
      },
    );
    setState(() {});
  }

  void addAdditionalValue(additionalData, key, updated) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddAdditionalValue(additionalData[key]!),
        );
      },
    );
    if (updated) updatedData[key] = 1;
    setState(() {});
  }

  void editValues(additionalData, key, updated) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditValues(additionalData[key]!),
        );
      },
    );
    if (updated) updatedData[key] = 1;
    setState(() {});
  }

  void _updateOldAdditionalData() {
    print(updatedData);
    updatedData.forEach((key, value) {
      if (value == -1) {
        ProductsDatabase.instance.deleteAdditionalData(widget.product.id, key);
      } else {
        ProductsDatabase.instance.updateAdditionalData(
          widget.product.id,
          key,
          oldAdditionalData[key]!.join(', '),
        );
      }
    });
    oldAdditionalData['Description'] = [description.text];
    oldAdditionalData['RegularPrice'] = [regularPrice.text];
    oldAdditionalData['PurchasePrice'] = [purchasePrice.text];

    ProductsDatabase.instance.updateAdditionalData(
      widget.product.id,
      'Description',
      oldAdditionalData['Description']!.join(', '),
    );
    ProductsDatabase.instance.updateAdditionalData(
      widget.product.id,
      'RegularPrice',
      oldAdditionalData['RegularPrice']!.join(', '),
    );
    ProductsDatabase.instance.updateAdditionalData(
      widget.product.id,
      'PurchasePrice',
      oldAdditionalData['PurchasePrice']!.join(', '),
    );
  }

  void editItem(context) async {
    //Check the required fields
    if (barcode.text.isNotEmpty &&
        name.text.isNotEmpty &&
        quantity.text.isNotEmpty) {
      final Product product = Product(
        id: widget.product.id,
        name: name.text,
        barcode: barcode.text,
        quantity: quantity.text,
        deleted: false,
      );

      int barcodeExit = await ProductsDatabase.instance.existBarcode(product);

      if (barcodeExit != 0) {
        showDialog(
          context: context,
          builder: (context) => Dialogs().showProductExist(context),
        );
      } else {
        if (regularPrice.text.isNotEmpty &&
            purchasePrice.text.isNotEmpty &&
            double.parse(regularPrice.text) >=
                double.parse(purchasePrice.text)) {
          showDialog(
            context: context,
            builder: (context) => Dialogs().pricesError(context),
          );
        } else {
          ProductsDatabase.instance.update(product);

          _updateOldAdditionalData();

          newAdditionalData.forEach((key, value) {
            ProductsDatabase.instance.addAdditionalData(
              id: product.id,
              key: key,
              value: value.join(', '),
            );
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(product: product),
            ),
          );
        }
      }
    } else {
      checkRequiredFields();
    }
    setState(() {});
  }

  void deleteAdditionalData(additionalData, key, updated) {
    showDialog(
      context: context,
      builder: (context) => Dialogs().deleteValueValidation(
        context: context,
        onDeletePress: () {
          additionalData.remove(key);
          if (updated) {
            updatedData[key] = -1;
          }

          Navigator.of(context).pop();

          setState(() {});
        },
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8EDE3),
      appBar: AppBar(
        // backgroundColor: Colors.green[300],
        backgroundColor: Red,
        title: const Text('Edit Product'),
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
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: scanBarCode,
                               child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 50,
                                  color: Color(0xff8391a1),
                                ),
                            ),
                          ),
                        ],
                      ),
                      inputText(
                        placeholder: 'Name',
                        controller: name,
                      ),
                      inputText(
                        placeholder: 'Description (if any)',
                        controller: description,
                      ),
                      inputText(
                        placeholder: 'Quantity',
                        controller: quantity,
                        numeric: true,
                      ),
                      inputText(
                        placeholder: 'Regular Price',
                        controller: regularPrice,
                        numeric: true,
                      ),
                      inputText(
                        placeholder: 'Purchase Price',
                        controller: purchasePrice,
                        numeric: true,
                      ),
                      ...oldAdditionalData.entries.map(
                        (entry) => AdditionalDataRow(
                          dataTitle: entry.key,
                          dataValues: entry.value,
                          addValue: () => addAdditionalValue(
                            oldAdditionalData,
                            entry.key,
                            true,
                          ),
                          deleteData: () => deleteAdditionalData(
                            oldAdditionalData,
                            entry.key,
                            true,
                          ),
                          editValues: () => editValues(
                            oldAdditionalData,
                            entry.key,
                            true,
                          ),
                        ),
                      ),
                      ...newAdditionalData.entries.map(
                        (entry) => AdditionalDataRow(
                          dataTitle: entry.key,
                          dataValues: entry.value,
                          addValue: () => addAdditionalValue(
                            newAdditionalData,
                            entry.key,
                            false,
                          ),
                          deleteData: () => deleteAdditionalData(
                            newAdditionalData,
                            entry.key,
                            false,
                          ),
                          editValues: () => editValues(
                            newAdditionalData,
                            entry.key,
                            false,
                          ),
                        ),
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => editItem(context),
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
                              'Save',
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
                        'assets/images/noimage.png',
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
