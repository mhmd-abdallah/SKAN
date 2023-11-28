// ignore_for_file: depend_on_referenced_packages, prefer_interpolation_to_compose_strings, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:skan/model/product_model.dart';

class ProductsDatabase {
  static final ProductsDatabase instance = ProductsDatabase._init();

  static Database? _database;

  ProductsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    //if there is no database, create one
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 4, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //Create a table in the database created
    await db.execute('''
      CREATE TABLE $tableProducts(
        ${ProductFields.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${ProductFields.name} TEXT NOT NULL,
        ${ProductFields.barcode} TEXT NOT NULL, 
        ${ProductFields.quantity} REAL,
        ${ProductFields.description} TEXT NOT NULL,
        ${ProductFields.purchasePrice} REAL,
        ${ProductFields.regularPrice} REAL,
        ${ProductFields.deleted} INTEGER NOT NULL
      )
''');
    await db.execute('''
      CREATE TABLE $additionalData(
        ID INTEGER NOT NULL,
        KEY TEXT,
        VALUE TEXT
      )
''');
  }

  // Add a new product to the table
  Future<Product> create(Product product) async {
    final db = await instance.database;

    final json = product.toMap();
    final id = await db.rawInsert(
        'INSERT INTO products VALUES(${json[ProductFields.id]}, "${json[ProductFields.name]}", "${json[ProductFields.barcode]}", "${json[ProductFields.quantity]}","${json[ProductFields.description]}", "${json[ProductFields.purchasePrice]}","${json[ProductFields.regularPrice]}",   ${json[ProductFields.deleted]})');
    return product.copyWith(id: id);
  }

  //Add and additional data to a product id
  Future<void> addAdditionalData({id, key, value}) async {
    final db = await instance.database;

    await db
        .rawInsert('INSERT INTO $additionalData VALUES($id, "$key", "$value")');
  }

  Future<List<Map<String, String>>> readAdditionalData(id) async {
    final db = await instance.database;

    final result = await db.query(
      additionalData,
      columns: ['KEY', 'VALUE'],
      where: 'ID = ?',
      whereArgs: [id],
    );
    return result
        .map((data) => {data['KEY'].toString(): data['VALUE'].toString()})
        .toList();
  }

  // Read all the products from the table (active and deleted products)
  Future<List<Product>> readAllProducts() async {
    final db = await instance.database;

    final result = await db.query(tableProducts);

    return result.map((json) => Product.fromJson(json)).toList();
  }

  // Read the active products from the table
  Future<List<Product>> readActiveProducts() async {
    final db = await instance.database;
    final result = await db.query(
      tableProducts,
      columns: ProductFields.values,
      where: '${ProductFields.deleted} = ?',
      whereArgs: [0],
    );
    return result.map((json) => Product.fromJson(json)).toList();
  }

  // Read the deleted products from the table
  Future<List<Product>> readDeletedProducts() async {
    final db = await instance.database;
    final result = await db.query(
      tableProducts,
      columns: ProductFields.values,
      where: '${ProductFields.deleted} = ?',
      whereArgs: [1],
    );
    return result.map((json) => Product.fromJson(json)).toList();
  }

  //Update a product row
  Future<int> update(Product product) async {
    final db = await instance.database;

    return db.update(
      tableProducts,
      product.toMap(),
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  // Future<int> updateAdditionalData({id, key, value}) async {
  //   final db = await instance.database;

  //   return db.update(
  //     additionalData,
  //     {'ID': id, 'KEY': key, 'VALUE': value},
  //     where: 'ID = ? AND KEY =? ',
  //     whereArgs: [id, key],
  //   );
  // }

  // Future<int> deleteAdditionalData(int id) async {
  // final db = await instance.database;
  //   return db.delete(additionalData, where: 'ID = ?', whereArgs: [id]);
  // }

  Future<int> deleteAdditionalData(int id, String key) async {
    final db = await instance.database;
    int x = await db.delete(
      additionalData,
      where: 'ID = ? AND KEY = ?',
      whereArgs: [id, key],
    );
    print("test: " + x.toString());
    return x;
  }

  Future<int> updateAdditionalData(id, key, val) async {
    final db = await instance.database;
    return db.rawUpdate(
      'UPDATE $additionalData SET VALUE = ? WHERE ID = ? AND KEY = ?',
      [val, id, key],
    );
  }

  //Delete a product
  // Change the deleted column to true
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.rawUpdate('UPDATE products SET deleted = 1 WHERE id = $id');
  }

  //Restore a product
  // Change the deleted column to false
  Future<int> restore(int id) async {
    final db = await instance.database;
    return await db.rawUpdate('UPDATE products SET deleted = 0 WHERE id = $id');
  }

  //Check if the barcode number is already exist or not
  // if the return value is -1 ==> new barcode number
  // return value = 0 ==> already exist in the active product ==> Error message
  // return value = 1 ==> already exist in the deleted section ==> restore it with the same id (old id)
  Future<int> oldProduct(String barcode) async {
    final result = await readAllProducts();
    int id = -1; // Not exist
    result.forEach((product) {
      if (product.barcode == barcode && product.deleted) {
        id = product.id;
      } else if (product.barcode == barcode) {
        id = 0; // Exist
      }
    });
    return id;
  }

  //When editing a product barcode, we need to check if
  //the new product barcode is not repeated
  Future<int> existBarcode(Product product) async {
    final result = await readAllProducts();
    int exist = 0;
    result.forEach((element) {
      if (element.barcode == product.barcode) {
        if (element.id != product.id) {
          exist = 1;
        }
      }
    });
    return exist;
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  //lastId function give me the last id in the sql table
  Future<int> lastId() async {
    final db = await instance.database;
    final result = await db.query(tableProducts);
    return result.isNotEmpty ? Product.fromJson(result.last).id : 0;
  }

  //Delete the database
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');
    databaseFactory.deleteDatabase(path);
  }
}
