import 'package:ecommerce_app_fluterr_nodejs/models/notification.dart';
import 'package:flutter/material.dart';

class NotificationsBottomSheet extends StatelessWidget {
  final List<Notification_Model> notifications;
  final Function(Notification_Model) onNotificationTap;
  final VoidCallback onMarkAllRead;
  final VoidCallback onDeleteAll;
  final VoidCallback onClearOld;
  final Function(String) onDeleteNotification;

  const NotificationsBottomSheet({
    Key? key,
    required this.notifications,
    required this.onNotificationTap,
    required this.onMarkAllRead,
    required this.onDeleteNotification,
    required this.onDeleteAll,
    required this.onClearOld,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        children: [
          // Header with actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (notifications.isNotEmpty)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'mark_all':
                        onMarkAllRead();
                        break;
                      case 'delete_all':
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete All Notifications'),
                            content: const Text(
                                'Are you sure you want to delete all notifications?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onDeleteAll();
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        break;
                      case 'clear_old':
                        onClearOld();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'mark_all',
                      child: Text('Mark all as read'),
                    ),
                    const PopupMenuItem(
                      value: 'delete_all',
                      child: Text('Delete all'),
                    ),
                    const PopupMenuItem(
                      value: 'clear_old',
                      child: Text('Clear old notifications'),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Notifications list
          Expanded(
            child: notifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Dismissible(
                        key: Key(notification.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) =>
                            onDeleteNotification(notification.id),
                        child: Card(
                          elevation: notification.isRead ? 0 : 2,
                          color: notification.isRead
                              ? Colors.white
                              : Colors.blue[50],
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _getNotificationColor(notification.type)
                                      .withOpacity(0.2),
                              child: Icon(
                                _getNotificationIcon(notification.type),
                                color: _getNotificationColor(notification.type),
                                size: 20,
                              ),
                            ),
                            title: Text(
                              notification.message,
                              style: TextStyle(
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _formatDate(notification.createdAt),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            onTap: () => onNotificationTap(notification),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_product':
        return Icons.new_releases;
      case 'update_product':
        return Icons.update;
      case 'discount':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'new_product':
        return Colors.green;
      case 'update_product':
        return Colors.blue;
      case 'discount':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    }
    if (difference.inDays == 1) {
      return 'Yesterday';
    }
    return '${difference.inDays} days ago';
  }
}
