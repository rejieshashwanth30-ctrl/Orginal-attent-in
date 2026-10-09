import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hostel_models.dart';
import '../../providers/hostel_provider.dart';
import '../../widgets/ai/ai_insight_card.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/section_header.dart';

class HostelManagementScreen extends StatelessWidget {
  const HostelManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hostelProvider = context.watch<HostelProvider>();

    final room = hostelProvider.room;
    final todayMenu = hostelProvider.todayMessMenu;
    final isPresent = hostelProvider.isTodayPresent;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hostel Management',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
              ),
            ),
            Text(
              'Manage your campus residential life',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          children: [
            // AI Hostel Routine & Mess Insight
            const AIInsightCard(
              title: 'AI Hostel & Mess Routine',
              insight:
                  'Today\'s dinner menu is Paneer Butter Masala & Phulka Chapati. Night curfew is active at 10:00 PM. No pending complaints for Room 204.',
              riskLevel: 'ALL CLEAR',
              icon: Icons.apartment_outlined,
            ),
            const SizedBox(height: 14),

            // 1. Room Summary Card
            _buildRoomSummaryCard(context, room, colors),

            const SizedBox(height: 16),

            // 2. Hostel Attendance & Night Curfew Card
            _buildAttendanceCard(context, hostelProvider, isPresent, colors),

            const SizedBox(height: 20),

            // 3. Today's Mess Menu (3 Separate Cards)
            _buildTodayMessSection(context, todayMenu, colors),

            const SizedBox(height: 24),

            // 4. Feature Navigation Grid (6 Cards)
            const SectionHeader(
              title: 'Hostel Modules',
              icon: Icons.grid_view_rounded,
            ),
            const SizedBox(height: 10),
            _buildFeatureGrid(context, hostelProvider, colors),

            const SizedBox(height: 24),

            // 5. Emergency Contacts Section
            const SectionHeader(
              title: 'Hostel Emergency Directory',
              icon: Icons.emergency_outlined,
            ),
            const SizedBox(height: 10),
            _buildEmergencySection(context, hostelProvider.emergencyContacts, colors),

            const SizedBox(height: 24),

            // 6. Recent Active Complaints / Leave Quick Preview
            _buildRecentActivitySection(context, hostelProvider, colors),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // --- 1. Room Summary Card ---
  Widget _buildRoomSummaryCard(BuildContext context, HostelRoom room, AppColorPalette colors) {
    return InkWell(
      onTap: () => context.push('/hostel/room'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border, width: 1),
          boxShadow: [
            colors.cardShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.elevatedCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.border, width: 0.8),
                  ),
                  child: Text(
                    room.roomType,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'View Details',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.secondaryText,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 11, color: colors.secondaryText),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Room ${room.roomNumber}',
              style: GoogleFonts.outfit(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: colors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${room.block} • ${room.floor}',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: colors.secondaryText,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.people_outline_rounded, size: 16, color: colors.secondaryText),
                const SizedBox(width: 6),
                Text(
                  '${room.roommates.length} Roommates Assigned',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.primaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. Attendance Card ---
  Widget _buildAttendanceCard(
    BuildContext context,
    HostelProvider provider,
    bool isPresent,
    AppColorPalette colors,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.elevatedCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border, width: 0.8),
            ),
            child: Icon(
              isPresent ? Icons.how_to_reg_outlined : Icons.person_off_outlined,
              color: colors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Today's Attendance: ",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colors.secondaryText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPresent ? colors.success.withValues(alpha: 0.12) : colors.danger.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isPresent ? colors.success.withValues(alpha: 0.4) : colors.danger.withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        isPresent ? 'PRESENT' : 'ABSENT',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isPresent ? colors.success : colors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Monthly Rate: ${provider.monthlyAttendancePercentage}%  •  Curfew: ${provider.curfewTime}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: colors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => provider.toggleAttendance(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colors.elevatedCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.border, width: 0.8),
              ),
              child: Text(
                'Toggle',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.primaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Today's Mess Section (3 Cards) ---
  Widget _buildTodayMessSection(BuildContext context, MessMenu menu, AppColorPalette colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant_menu_outlined, size: 18, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  "Today's Mess Menu (${menu.dayOfWeek})",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryText,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => context.push('/hostel/mess'),
              child: Text(
                'Full Schedule →',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.secondaryText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Breakfast
            Expanded(
              child: _buildMealMiniCard(
                title: 'Breakfast',
                menuText: menu.breakfast.split('&').first.trim(),
                time: '7:30 - 9:00',
                icon: Icons.free_breakfast_outlined,
                onTap: () => context.push('/hostel/mess'),
                colors: colors,
              ),
            ),
            const SizedBox(width: 8),
            // Lunch
            Expanded(
              child: _buildMealMiniCard(
                title: 'Lunch',
                menuText: menu.lunch.split('+').take(2).join('+').trim(),
                time: '12:30 - 2:00',
                icon: Icons.lunch_dining_outlined,
                onTap: () => context.push('/hostel/mess'),
                colors: colors,
              ),
            ),
            const SizedBox(width: 8),
            // Dinner
            Expanded(
              child: _buildMealMiniCard(
                title: 'Dinner',
                menuText: menu.dinner.split('+').take(2).join('+').trim(),
                time: '7:30 - 9:30',
                icon: Icons.dinner_dining_outlined,
                onTap: () => context.push('/hostel/mess'),
                colors: colors,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMealMiniCard({
    required String title,
    required String menuText,
    required String time,
    required IconData icon,
    required VoidCallback onTap,
    required AppColorPalette colors,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colors.border,
            width: 1,
          ),
          boxShadow: [
            colors.cardShadow,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: colors.primary),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              menuText,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: colors.secondaryText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 9.5,
                color: colors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. Feature Navigation Grid (6 Cards) ---
  Widget _buildFeatureGrid(BuildContext context, HostelProvider provider, AppColorPalette colors) {
    final modules = [
      {
        'title': 'Room & Roommates',
        'desc': 'Block A, Floor 2, 4-Share',
        'icon': Icons.meeting_room_outlined,
        'route': '/hostel/room',
        'badge': null,
      },
      {
        'title': 'Mess & Food',
        'desc': 'Weekly Dining Menu',
        'icon': Icons.restaurant_outlined,
        'route': '/hostel/mess',
        'badge': null,
      },
      {
        'title': 'Complaints System',
        'desc': 'Repairs, Wi-Fi, Cleaning',
        'icon': Icons.build_outlined,
        'route': '/hostel/complaints',
        'badge': provider.pendingComplaintsCount > 0 ? '${provider.pendingComplaintsCount} Active' : null,
      },
      {
        'title': 'Leave & Outing Pass',
        'desc': 'Home Visits & Gatepass',
        'icon': Icons.time_to_leave_outlined,
        'route': '/hostel/leave',
        'badge': provider.pendingLeaveCount > 0 ? '${provider.pendingLeaveCount} Pending' : null,
      },
      {
        'title': 'Hostel Notices',
        'desc': 'Warden Announcements',
        'icon': Icons.campaign_outlined,
        'route': '/hostel/notices',
        'badge': '${provider.notices.length}',
      },
      {
        'title': 'Hostel Fees',
        'desc': 'Ledger & Receipts',
        'icon': Icons.receipt_long_outlined,
        'route': '/hostel/fees',
        'badge': 'PAID',
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 110,
          ),
          itemBuilder: (context, index) {
            final m = modules[index];
            final badge = m['badge'] as String?;

            return InkWell(
              onTap: () => context.push(m['route'] as String),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border, width: 1),
                  boxShadow: [
                    colors.cardShadow,
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: colors.elevatedCard,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(m['icon'] as IconData, size: 18, color: colors.primary),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.elevatedCard,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: colors.border, width: 0.8),
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: colors.primaryText,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['title'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          m['desc'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: colors.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 5. Emergency Section ---
  Widget _buildEmergencySection(
    BuildContext context,
    List<HostelEmergencyContact> contacts,
    AppColorPalette colors,
  ) {
    return Column(
      children: contacts.map((c) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.elevatedCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border, width: 0.8),
                  ),
                  child: Icon(Icons.phone_in_talk_outlined, color: colors.primary, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.role,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryText,
                        ),
                      ),
                      Text(
                        '${c.name} • ${c.availability}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: colors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.call_outlined, color: colors.primary, size: 20),
                  tooltip: 'Call ${c.role}',
                  onPressed: () async {
                    final confirmed = await AppDialog.show(
                      context,
                      title: 'Emergency Call',
                      content: 'Are you sure you want to call ${c.role} (${c.name}) at ${c.phoneNumber}?',
                      confirmText: 'Call Emergency',
                    );
                    if (confirmed == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Initiating emergency connection to ${c.name} (${c.phoneNumber})...')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- 6. Recent Activity Preview ---
  Widget _buildRecentActivitySection(
    BuildContext context,
    HostelProvider provider,
    AppColorPalette colors,
  ) {
    final recentComplaint = provider.complaints.isNotEmpty ? provider.complaints.first : null;
    final recentLeave = provider.leaveRequests.isNotEmpty ? provider.leaveRequests.first : null;

    if (recentComplaint == null && recentLeave == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Recent Status Updates',
          icon: Icons.history_rounded,
        ),
        const SizedBox(height: 10),
        if (recentComplaint != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              onTap: () => context.push('/hostel/complaints'),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.build_circle_outlined, size: 22, color: colors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recentComplaint.title,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Status: ${recentComplaint.status.displayName} • Room ${recentComplaint.roomNumber}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: colors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 20, color: colors.mutedText),
                ],
              ),
            ),
          ),
        if (recentLeave != null)
          AppCard(
            onTap: () => context.push('/hostel/leave'),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(Icons.beach_access_outlined, size: 22, color: colors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${recentLeave.leaveType} (${recentLeave.status.displayName})',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${recentLeave.fromDate.day}/${recentLeave.fromDate.month} → ${recentLeave.toDate.day}/${recentLeave.toDate.month} • ${recentLeave.reason}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: colors.secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 20, color: colors.mutedText),
              ],
            ),
          ),
      ],
    );
  }
}
