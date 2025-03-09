import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:restro_admin/app/data/constants.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  client = Client().setProject('restro');

  runApp(
    GetMaterialApp(
      title: "Duo Dine Admin",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
