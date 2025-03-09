import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:foodly_ui/models/order_model.dart';
import 'package:foodly_ui/screens/orderDetails/components/order_item_card.dart';
import 'package:foodly_ui/screens/orderDetails/order_timeline/timeline_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Orders extends GetView<OrdersController> {
  const Orders({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(OrdersController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          // date
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              DateFormat('dd/MM/yyyy').format(controller.item!.createdDate),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // order id
                Text("Order ID: ${controller.item!.$id}"),
                const SizedBox(height: defaultPadding),
                ...List.generate(
                  controller.items.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 2),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const TimelineScreen(),
                          arguments: controller.items[index],
                        );
                      },
                      child: OrderedItemCard(
                        title: controller.items[index].items.name,
                        description:
                            "${controller.items[index].status} - click to view timeline",
                        numOfItem: controller.items[index].qty,
                        price: controller.items[index].items.price *
                            controller.items[index].qty,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class OrdersController extends GetxController {
  OrderModel? item;
  RxList<OrderItemsModel> items = <OrderItemsModel>[].obs;

  @override
  void onInit() {
    item = Get.arguments;
    getItems(item!.$id);
    super.onInit();
  }

  Future<void> getItems(String $id) async {
    try {
      var data = await db.listDocuments(
        databaseId: dbId,
        collectionId: orderItemsCollection,
        // queries: [Query.equal("\$id", item!.$id)],
      );
      for (var element in data.documents) {
        items.add(OrderItemsModel.fromJson(element.data));
      }
    } on AppwriteException catch (e) {
      debugPrint(e.message);
      debugPrint(e.response);
    }
  }
}
