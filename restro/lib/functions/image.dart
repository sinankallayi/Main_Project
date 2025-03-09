import 'dart:io';

import 'package:appwrite/appwrite.dart' as ap;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodly_ui/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> pickImage() async {
  // Request appropriate permission based on platform and Android version
  PermissionStatus status;
  if (Platform.isAndroid && await Permission.storage.isDenied) {
    status = await Permission.storage.request();
  } else {
    status = await Permission.photos.request();
  }

  if (status.isGranted) {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    } else {
      Fluttertoast.showToast(msg: 'No image selected');
      return '';
    }
  } else if (status.isPermanentlyDenied) {
    Fluttertoast.showToast(msg: 'Please enable photo access in settings');
    await openAppSettings();
    return '';
  } else {
    Fluttertoast.showToast(msg: 'Permission denied');
    return '';
  }
}

Future<String?> uploadImage(
    {required String imagePath, required String name}) async {
  try {
    final result = await storage.createFile(
      bucketId: itemsBucketId,
      fileId: ap.ID.unique(),
      file: ap.InputFile.fromPath(path: imagePath, filename: '$name.jpg'),
    );
    debugPrint(result.$id);
    return result.$id;
  } on ap.AppwriteException catch (e) {
    debugPrint('Error uploading image: ${e.message}');
    return null;
  }
}

deleteImage(String imageId) async {
  try {
    await storage.deleteFile(fileId: imageId, bucketId: itemsBucketId);
  } on ap.AppwriteException catch (e) {
    debugPrint('Error deleting image: ${e.message}');
  }
}
