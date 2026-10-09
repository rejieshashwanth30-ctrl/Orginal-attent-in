import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/club_models.dart';
import '../../providers/club_provider.dart';
import '../../widgets/ai/ai_insight_card.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openClubDetails(BuildContext context, CampusClub club) {
    final colors = AppColors.of(context);
    AppBottomSheet.show(
      context,
      title: club.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.elevatedCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                    Text(club.category.displayName, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: colors.primaryText)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Members', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                    Text('${club.memberCount} Students', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: colors.primaryText)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('About Club', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: colors.primaryText)),
          const SizedBox(height: 4),
          Text(club.description, style: GoogleFonts.inter(fontSize: 13, height: 1.45, color: colors.secondaryText)),
          const SizedBox(height: 14),
          Text('Faculty Coordinator', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
          Text(club.facultyCoordinator, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primaryText)),
          const SizedBox(height: 8),
          Text('Student Lead', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
          Text(club.studentCoordinator, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primaryText)),
          const SizedBox(height: 16),
          if (club.tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: club.tags.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.elevatedCard,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.border, width: 0.8),
                  ),
                  child: Text('#$t', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.primaryText)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          AppButton(
            text: club.isJoined ? 'Leave Club' : 'Join Club (Become a Member)',
            type: club.isJoined ? AppButtonType.secondary : AppButtonType.primary,
            width: double.infinity,
            onPressed: () {
              Navigator.pop(context);
              context.read<ClubProvider>().toggleJoinClub(club.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final clubProvider = context.watch<ClubProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clubs & Campus Life',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
              ),
            ),
            Text(
              'Technical societies, events & creative communities',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colors.primary,
          labelColor: colors.primaryText,
          unselectedLabelColor: colors.mutedText,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Clubs & Societies (${clubProvider.clubs.length})'),
            Tab(text: 'Campus Events (${clubProvider.allUpcomingEvents.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Clubs Tab
          _buildClubsTab(context, clubProvider, colors),

          // 2. Events Tab
          _buildEventsTab(context, clubProvider, colors),
        ],
      ),
    );
  }

  Widget _buildClubsTab(BuildContext context, ClubProvider provider, AppColorPalette colors) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // AI Club Recommendation Card
        const AIInsightCard(
          title: 'AI Club Recommender',
          insight:
              'Based on your interest in Machine Learning, PyTorch and your active attendance in Lab 4, you are recommended to join NeuroNet (AI/ML Club) & CodeX for competitive programming contests.',
          riskLevel: 'MATCH 96%',
          icon: Icons.psychology_outlined,
        ),
        const SizedBox(height: 16),

        // Category Filter Chips
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildFilterChip('All Clubs', null, provider, colors),
              _buildFilterChip('Coding & AI', ClubCategory.coding, provider, colors),
              _buildFilterChip('Robotics & IoT', ClubCategory.robotics, provider, colors),
              _buildFilterChip('Startups & E-Cell', ClubCategory.entrepreneurship, provider, colors),
              _buildFilterChip('Cultural & Music', ClubCategory.cultural, provider, colors),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Club Cards
        ...provider.filteredClubs.map((club) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              onTap: () => _openClubDetails(context, club),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.elevatedCard,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: colors.border, width: 0.8),
                              ),
                              child: Icon(Icons.groups_outlined, color: colors.primary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    club.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: colors.primaryText,
                                    ),
                                  ),
                                  Text(
                                    '${club.memberCount} Members • ${club.category.displayName}',
                                    style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => provider.toggleJoinClub(club.id),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: club.isJoined
                                ? colors.elevatedCard
                                : colors.primary,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: club.isJoined ? colors.border : colors.primary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            club.isJoined ? 'Member ✓' : '+ Join',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: club.isJoined ? colors.secondaryText : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    club.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 12, height: 1.4, color: colors.secondaryText),
                  ),
                  if (club.upcomingEvents.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.elevatedCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.border, width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event_available_outlined, size: 14, color: colors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Next: ${club.upcomingEvents.first.title}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.primaryText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFilterChip(String label, ClubCategory? cat, ClubProvider provider, AppColorPalette colors) {
    final isSel = provider.selectedCategory == cat;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isSel ? Colors.white : colors.secondaryText)),
        selected: isSel,
        selectedColor: colors.primary,
        backgroundColor: colors.card,
        side: BorderSide(color: isSel ? colors.primary : colors.border),
        onSelected: (_) => provider.setSelectedCategory(cat),
      ),
    );
  }

  Widget _buildEventsTab(BuildContext context, ClubProvider provider, AppColorPalette colors) {
    final events = provider.allUpcomingEvents;

    if (events.isEmpty) {
      return const AppEmptyState(
        icon: Icons.event_busy_outlined,
        title: 'No Upcoming Events',
        description: 'Check back soon for hackathons, workshops, and concerts.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final ev = events[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.elevatedCard,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: colors.border, width: 0.8),
                      ),
                      child: Text(
                        ev.clubName.toUpperCase(),
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: colors.primaryText),
                      ),
                    ),
                    Text(
                      '${ev.date.day}/${ev.date.month}/${ev.date.year}',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: colors.mutedText),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ev.title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ev.description,
                  style: GoogleFonts.inter(fontSize: 12, height: 1.4, color: colors.secondaryText),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.schedule_outlined, size: 14, color: colors.mutedText),
                    const SizedBox(width: 4),
                    Text(ev.time, style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
                    const SizedBox(width: 14),
                    Icon(Icons.place_outlined, size: 14, color: colors.mutedText),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ev.venue,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${ev.registeredCount} / ${ev.maxSeats} Registered',
                      style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                    ),
                    ElevatedButton(
                      onPressed: () => provider.toggleRegisterEvent(ev.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ev.isRegistered ? colors.card : colors.primary,
                        foregroundColor: ev.isRegistered ? colors.secondaryText : Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: ev.isRegistered ? BorderSide(color: colors.border) : BorderSide.none,
                        ),
                      ),
                      child: Text(
                        ev.isRegistered ? 'Registered ✓' : 'Register Now',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
