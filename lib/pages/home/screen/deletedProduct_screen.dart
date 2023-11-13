// ignore_for_file: unnecessary_this, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skan/constants/colors.dart';
import 'package:skan/model/product_model.dart';
import 'package:skan/pages/home/screen/home_screen.dart';
import 'package:skan/pages/home/widgets/table_data.dart';

import '../../../constants/dialogs.dart';
import '../../../database/products_database.dart';

class DeletedProduct extends StatefulWidget {
  const DeletedProduct({super.key});

  @override
  State<DeletedProduct> createState() => _DeletedProductState();
}

class _DeletedProductState extends State<DeletedProduct> {
  List<Product> items = [];
  bool saveLoading = false;
  TextEditingController skuNumberSearched = TextEditingController();

  @override
  void initState() {
    super.initState();

    refreshProducts();
  }

  Future refreshProducts() async {
    setState(() {
      saveLoading = true;
    });

    //Read the deleted products from the database
    this.items = await ProductsDatabase.instance.readDeletedProducts();

    // If the user search for a proudct then we only show the
    // list of products that contains the value searched
    if (skuNumberSearched.text.isNotEmpty) {
      items.retainWhere(
          (element) => element.barcode.contains(skuNumberSearched.text));
    }
    setState(() {
      saveLoading = false;
    });
  }

  void restoreItem(id) {
    showDialog(
      context: context,
      builder: (context) => Dialogs().restoreValidation(
        context: context,
        onDeletePress: () {
          ProductsDatabase.instance.restore(id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8EDE3),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Red,
        title: const Text(
          'Deleted Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              onChanged: (value) => refreshProducts(),
              controller: skuNumberSearched,
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
                hintStyle: const TextStyle(fontWeight: FontWeight.w500),
                prefixIcon: Icon(Icons.search, color: Colors.black),
              ),
            ),
            TableData(
              items: items,  
            ),
          ],
        ),
      ),
    );
  }
}
