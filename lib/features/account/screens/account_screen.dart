import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/services/account_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/below_appBar.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/notifications_bottom_sheet.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/orders.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/top_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/product_details/screens/product_details_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/product_details/services/product_details_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/notification.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<Notification_Model> notifications = [];
  int unreadCount = 0;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    notifications = await accountServices.fetchNotifications(context);
    setState(() {
      unreadCount = notifications.where((n) => !n.isRead).length;
    });
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => NotificationsBottomSheet(
        notifications: notifications,
        onNotificationTap: _handleNotificationTap,
        onMarkAllRead: _handleMarkAllRead,
        onDeleteNotification: _handleDeleteNotification,
        onDeleteAll: _handleDeleteAll,
        onClearOld: _handleClearOld,
      ),
    );
  }

  Future<void> _handleNotificationTap(Notification_Model notification) async {
    if (!notification.isRead) {
      await accountServices.markNotificationAsRead(
        context,
        notification.id,
      );
    }

    if (!context.mounted) return;

    switch (notification.type) {
      case 'new_product':
      case 'update_product':
      case 'discount':
        final productDetailsServices = ProductDetailsServices();
        final product = await productDetailsServices.fetchProductById(
          context: context,
          productId: notification.productId,
        );

        if (!context.mounted) return;
        Navigator.pushNamed(
          context,
          ProductDetailsScreen.routeName,
          arguments: product,
        );
        break;
    }

    fetchNotifications();
  }

  Future<void> _handleMarkAllRead() async {
    await accountServices.markAllNotificationsAsRead(context);
    fetchNotifications();
  }

  Future<void> _handleDeleteNotification(String id) async {
    await accountServices.deleteNotification(context, id);
    fetchNotifications();
  }

  Future<void> _handleDeleteAll() async {
    await accountServices.deleteAllNotifications(context);
    fetchNotifications();
  }

  Future<void> _handleClearOld() async {
    // You can add a dialog to let user choose number of days
    const days = 30;
    await accountServices.clearOldNotifications(context, days);
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: InkWell(
                  onTap: () => _showNotifications(context),
                  child: badges.Badge(
                    badgeContent: Text(unreadCount.toString()),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: const Column(
        children: [
          BelowAppBar(),
          SizedBox(height: 15),
          TopButton(),
          SizedBox(height: 20),
          Expanded(child: Orders()),
        ],
      ),
    );
  }
}
