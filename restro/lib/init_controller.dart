import 'dart:developer';

import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/entry_point.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/screens/Restaurent/waiting/approval_screen.dart';
import 'package:get/get.dart';

class InitController extends GetxController {
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    localStorage.read('isCustomer') == null
        ? isCustomer = true
        : isCustomer = localStorage.read('isCustomer');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> check() async {
    log('Checking user info');
    try {
      await getUserInfo();

      await Future.delayed(const Duration(seconds: 2));

      if (user != null) {
        if (isCustomer) {
          Get.offAll(() => const EntryPoint());
        } else {
          Get.offAll(() => const ApprovalScreen());
        }
      } else {
        Get.offAll(() => const EntryPoint());
      }
    } catch (e) {
      log('Error checking user info: $e');
      Get.offAll(() => const EntryPoint());
    }
  }
}
