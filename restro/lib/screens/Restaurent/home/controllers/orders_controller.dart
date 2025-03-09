import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/models/delivery_person_model.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:foodly_ui/screens/Restaurent/home/widgets/delivery_persons_list.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  RxList<OrderItemsModel> orderItems = <OrderItemsModel>[].obs;
  RxList<DeliveryPersonModel> deliveryPersons = <DeliveryPersonModel>[].obs;

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  void getOrders() async {
    var result = await db.listDocuments(
      databaseId: dbId,
      collectionId: orderItemsCollection,
      queries: [
        Query.equal('restaurant', restaurant.value!.id),
      ],
    );

    // print(result.documents);

    orderItems = result.documents
        .map((e) => OrderItemsModel.fromJson(e.data))
        .toList()
        .obs;
  }

  Future<void> updateOrderStatus(id, String s) async {
    await db.updateDocument(
      databaseId: dbId,
      collectionId: orderItemsCollection,
      documentId: id,
      data: {
        "status": s,
      },
    );

    getOrders();
  }

  Future<void> assingDeliveryPerson(String $id) async {
    // assign delivery person
    // show bottom sheet with delivery person list

    Get.showOverlay(asyncFunction: () async {
      await getDeliveryPersons();
    });

    Get.bottomSheet(
      DeliveryPersonsList(
        $id: $id,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
  }

  getDeliveryPersons() async {
    var result = await db.listDocuments(
      databaseId: dbId,
      collectionId: deliveryPersonsCollection,
    );

    deliveryPersons = result.documents
        .map((e) => DeliveryPersonModel.fromJson(e.data))
        .toList()
        .obs;
  }
}
