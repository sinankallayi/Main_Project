import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/orders_controller.dart';
import 'package:foodly_ui/screens/orderDetails/components/order_item_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView.builder(
          itemCount: controller.orderItems.length,
          itemBuilder: (context, index) {
            final orderItem = controller.orderItems[index];
            return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: orderItem.status == "cooking"
                        ? null
                        : (context) {
                            controller.updateOrderStatus(
                              orderItem.$id,
                              "cooking",
                            );
                          },
                    label: "Cooking",
                    icon: Icons.kitchen,
                    foregroundColor: orderItem.status == "cooking" || orderItem.status == "delivering"
                        ? Colors.grey
                        : Colors.purple,
                    backgroundColor: Colors.transparent,
                  ),
                  // assign delivery person
                  SlidableAction(
                    onPressed: orderItem.status == "cooking" && orderItem.status != 'delivering'
                        ? (context) {
                            controller.assingDeliveryPerson(orderItem.$id);
                          }
                        : null,
                    label: "Assign Delivery Person",
                    icon: Icons.delivery_dining,
                    foregroundColor: orderItem.status == "cooking"
                        ? Colors.purple
                        : Colors.grey,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
              child: OrderedItemCard(
                numOfItem: orderItem.qty,
                title: orderItem.items.name,
                description:
                    "${DateFormat("dd/MM/yyyy").format(orderItem.orders.createdDate)} | ${orderItem.status} | ${orderItem.deliveryPerson!.name}",
                price: orderItem.items.price * orderItem.qty,
              ),
            );
          },
        ),
      ).paddingSymmetric(horizontal: defaultPadding),
    );
  }
}
