import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/models/cart_model.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_controller.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var args;

  RxBool isProcessing = false.obs;
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxBool isCvvFocused = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void updateCardDetails(CreditCardModel data) {
    cardNumber.value = data.cardNumber;
    expiryDate.value = data.expiryDate;
    cardHolderName.value = data.cardHolderName;
    cvvCode.value = data.cvvCode;
    isCvvFocused.value = data.isCvvFocused;
  }

  Future<void> simulatePayment() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar('Error', 'Please enter valid card details',
          backgroundColor: Colors.red);
      return;
    }

    isProcessing.value = true;

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Random success/failure
    final success = DateTime.now().second % 2 == 0;
    isProcessing.value = false;

    if (success) {
      await createOrder(args['items'], args['price']);
    }

    Get.snackbar(
      success ? 'Success' : 'Failed',
      success ? 'Payment Successful, Order Place!' : 'Payment Failed!',
      backgroundColor: success ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  }
}

createOrder(List<CartModel> arg, price) async {
  await account.get();
  List<String> restaurant = [];
  for (var element in arg) {
    restaurant.add(element.item.restaurant.id);
  }
  var id = ID.unique();
  try {
    await db.createDocument(
      databaseId: dbId,
      collectionId: ordersCollection,
      documentId: id,
      data: {
        // "qty" : "100"
        'users': user!.$id,
        'restaurant': restaurant,
        'total_price': double.parse(price.toStringAsFixed(2)),
        'status': 'pending',
      },
    );
  } on AppwriteException catch (e) {
    debugPrint(e.code.toString() + e.message.toString());
  }

  for (var element in arg) {
    try {
      await db.deleteDocument(
        databaseId: dbId,
        collectionId: cartCollection,
        documentId: element.$id,
      );
    } on AppwriteException catch (e) {
      debugPrint(e.code.toString() + e.message.toString());
    }
  }

  for (var element in arg) {
    try {
      await db.createDocument(
        databaseId: dbId,
        collectionId: orderItemsCollection,
        documentId: ID.unique(),
        data: {
          'orders': id,
          'items': element.item.$id,
          'qty': element.quantity,
        },
      );
    } on AppwriteException catch (e) {
      debugPrint(e.code.toString() + e.message.toString());
    }
  }

  Get.put(OrderDetailsController()).getCartItems();

  Get.back();
}
