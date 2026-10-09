import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hostel_models.dart';
import '../../providers/hostel_provider.dart';
import '../../widgets/app_card.dart';

class HostelNoticesScreen extends StatelessWidget {
  const HostelNoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hostelProvider = context.watch<HostelProvider>();
    final notices = hostelProvider.notices;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Hostel Notices',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: notices.length,
          itemBuilder: (context, index) {
            final notice = notices[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildNoticeCard(notice, colors),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoticeCard(HostelNotice notice, AppColorPalette colors) {
    Color badgeColor;
    IconData icon;
    switch (notice.category) {
      case 'INSPECTION':
        badgeColor = colors.danger;
        icon = Icons.search_rounded;
        break;
      case 'MESS':
        badgeColor = colors.warning;
        icon = Icons.restaurant_rounded;
        break;
      case 'MAINTENANCE':
        badgeColor = colors.primary;
        icon = Icons.build_rounded;
        break;
      case 'EVENT':
        badgeColor = colors.secondary;
        icon = Icons.celebration_rounded;
        break;
      default:
        badgeColor = colors.primary;
        icon = Icons.campaign_rounded;
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: badgeColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    notice.category,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: badgeColor,
                    ),
                  ),
                ],
              ),
              if (notice.isPinned)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.push_pin_rounded, size: 11, color: colors.warning),
                      const SizedBox(width: 4),
                      Text(
                        'PINNED',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: colors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notice.title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            notice.content,
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.45,
              color: colors.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Issued by Chief Warden Office',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: colors.mutedText,
                ),
              ),
              Text(
                '${notice.date.day}/${notice.date.month}/${notice.date.year}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.mutedText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
