import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/services/account_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/notifications_bottom_sheet.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/orders.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/top_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/product_details/screens/product_details_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/product_details/services/product_details_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/notification.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), // Tăng chiều cao một chút
        child: AppBar(
          elevation: 0, // Bỏ shadow
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Column(
            //mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 7),
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Hello, ',
                      ),
                      TextSpan(
                        text: user.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ]),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () => _showNotifications(context),
                child: badges.Badge(
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.redAccent,
                    padding: EdgeInsets.all(6),
                  ),
                  badgeContent: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 28,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: const Column(
        children: [
          //BelowAppBar(),
          SizedBox(height: 15),
          TopButton(),
          SizedBox(height: 20),
          Expanded(child: Orders()),
        ],
      ),
    );
  }
}
