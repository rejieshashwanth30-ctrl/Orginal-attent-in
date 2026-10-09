import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'ALL';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final provider = context.watch<NotificationProvider>();

    final notifications = _filter == 'UNREAD'
        ? provider.notifications.where((n) => !n.isRead).toList()
        : _filter == 'READ'
            ? provider.notifications.where((n) => n.isRead).toList()
            : provider.notifications;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllAsRead(),
              child: Text(
                'Mark all read',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primary),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Strip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: ['ALL', 'UNREAD', 'READ'].map((f) {
                  final isSelected = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        f,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : colors.primaryText,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: colors.primary,
                      backgroundColor: colors.card,
                      side: BorderSide(color: isSelected ? colors.primary : colors.border),
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.fetchNotifications(),
                child: provider.isLoading && provider.notifications.isEmpty
                    ? const AppLoading(message: 'Loading notifications...')
                    : provider.error != null && provider.notifications.isEmpty
                        ? AppError(message: provider.error!, onRetry: () => provider.fetchNotifications())
                        : notifications.isEmpty
                            ? const AppEmptyState(
                                icon: Icons.notifications_off_outlined,
                                title: 'No Notifications',
                                description: 'You have no new alerts or assignment reminders.',
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final notif = notifications[index];

                                  Color iconColor = colors.primary;
                                  IconData iconData = Icons.notifications_outlined;

                                  if (notif.type == 'ATTENDANCE') {
                                    iconColor = colors.danger;
                                    iconData = Icons.warning_amber_rounded;
                                  } else if (notif.type == 'ASSIGNMENT') {
                                    iconColor = colors.primary;
                                    iconData = Icons.assignment_outlined;
                                  } else if (notif.type == 'EXAM') {
                                    iconColor = colors.warning;
                                    iconData = Icons.alarm_on_outlined;
                                  } else if (notif.type == 'CAREER') {
                                    iconColor = colors.success;
                                    iconData = Icons.work_outline;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: AppCard(
                                      onTap: () {
                                        if (!notif.isRead) {
                                          provider.markAsRead(notif.id);
                                        }
                                      },
                                      padding: const EdgeInsets.all(14),
                                      border: !notif.isRead
                                          ? BorderSide(color: colors.primary.withValues(alpha: 0.5), width: 1.2)
                                          : null,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: iconColor.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Icon(iconData, color: iconColor, size: 20),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        notif.title,
                                                        style: GoogleFonts.outfit(
                                                          fontSize: 15,
                                                          fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                                                          color: colors.primaryText,
                                                        ),
                                                      ),
                                                    ),
                                                    if (!notif.isRead)
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration: BoxDecoration(
                                                          color: colors.primary,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  notif.message,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: colors.secondaryText,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  DateFormat('MMM d, h:mm a').format(notif.createdAt),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    color: colors.mutedText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close, size: 16),
                                            color: colors.mutedText,
                                            onPressed: () => provider.deleteNotification(notif.id),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
