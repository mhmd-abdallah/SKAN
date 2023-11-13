import 'package:flutter/material.dart';

class Dialogs {
  Widget showSuccessDialog(context) => AlertDialog(
        title: const Text('Exported Successfully'),
        content:
            const Text('Please Check the Download Folder, to see your file'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.done,
              color: Colors.black,
            ),
            label: const Text(
              'Okay',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );

  Widget failureExport(context) => AlertDialog(
        title: const Text('Exported Failed'),
        content: const Text('Your data table is empty'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.done,
              color: Colors.black,
            ),
            label: const Text(
              'Okay',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );

  //When adding an old product
  Widget showProductExist(context) => AlertDialog(
        title: const Text('You can\'t Add product'),
        content: const Text(
            'Product Already Exist, check the product or add another SKU product'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.done,
              color: Colors.black,
            ),
            label: const Text(
              'Okay',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );

  //Validation for the delete action
  Widget deleteValidation({
    context,
    required onDeletePress,
  }) =>
      AlertDialog(
        title: const Text('Are you sure you want to delete this item'),
        content: const Text(
            'This item will be deleted immediately. The product will be in the deleted section.'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            ),
            label: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onDeletePress,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );

  //Validation for the restore action
  Widget restoreValidation({
    context,
    required onDeletePress,
  }) =>
      AlertDialog(
        title: const Text('Are you sure you want to restore this item'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            ),
            label: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onDeletePress,
            icon: const Icon(
              Icons.restart_alt,
              color: Colors.red,
            ),
            label: const Text(
              'Restore',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );

  Widget existValidation(context, toScreen) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'Are you sure you want to discard this changes? Your product will be lost'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            ),
            label: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => toScreen,
                ),
              );
            },
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            label: const Text(
              'Discard',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );

  Widget showFieldExist(context) => AlertDialog(
        title: const Text('You can\'t Add this field'),
        content: const Text('Field Already Exist'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.done,
              color: Colors.black,
            ),
            label: const Text(
              'Okay',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );

  Widget deleteValueValidation({
    context,
    required onDeletePress,
  }) =>
      AlertDialog(
        title: const Text('Are you sure you want to delete this value'),
        content: const Text(
            'This value will be deleted immediately. You cannot undo this action.'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            ),
            label: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onDeletePress,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );

  Widget pricesError(context) => AlertDialog(
        title: const Text('The regular price can\'t be less than the purchase price'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.done,
              color: Colors.black,
            ),
            label: const Text(
              'Okay',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );

  Widget productExistInTheDeletedSection(context) => AlertDialog(
        title: const Text('Product exist in the deleted section'),
        content: const Text('Go search your product in the deleted section'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.done,
              color: Colors.black,
            ),
            label: const Text(
              'Okay',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
}
