import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/transport_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _assistantInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    _assistantInputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final transport = context.watch<TransportProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Campus Transport'),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: colors.primary,
          labelColor: colors.primaryText,
          unselectedLabelColor: colors.mutedText,
          labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.directions_bus_rounded, size: 18), text: 'Routes & Schedules'),
            Tab(icon: Icon(Icons.smart_toy_rounded, size: 18), text: 'Transport Assistant'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          // Tab 1: Routes, Stop Search & Schedules
          _buildRoutesTab(transport, colors),

          // Tab 2: AI Transport Assistant
          _buildAssistantTab(transport, colors),
        ],
      ),
    );
  }

  Widget _buildRoutesTab(TransportProvider transport, AppColorPalette colors) {
    final activeRoute = transport.activeRoute;
    final searchResult = transport.searchResult;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Stop Destination Bar
          AppTextField(
            controller: _searchCtrl,
            label: 'Where do you want to go?',
            hint: 'Search stop (e.g. Library, Hostel, Sports Complex)',
            prefixIcon: Icons.search_rounded,
            onChanged: (val) => transport.searchDestination(val),
          ),

          // Search Recommendation Result Card
          if (searchResult != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.primary.withValues(alpha: 0.5), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.near_me_rounded, color: colors.primary, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Recommended for "${searchResult.searchedStop}"',
                        style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: colors.primaryText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${searchResult.recommendedRoute.routeNumber}: ${searchResult.recommendedRoute.name}',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.secondaryText),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildScheduleBadge('Next Bus: ${searchResult.nextBusTime}', colors),
                      const SizedBox(width: 8),
                      _buildScheduleBadge('Following: ${searchResult.followingBusTime}', colors),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Live tracking disclaimer notice
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.elevatedCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 15, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Live GPS tracking is currently offline. Displaying official scheduled shuttle timings.',
                    style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Route Selector Tabs
          Text('Select Shuttle Route', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: colors.primaryText)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: transport.allRoutes.map((r) {
                final isSelected = r.id == activeRoute.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      r.routeNumber,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : colors.secondaryText,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: colors.primary,
                    backgroundColor: colors.card,
                    side: BorderSide(color: isSelected ? colors.primary : colors.border),
                    onSelected: (_) => transport.selectRoute(r),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Active Route Card
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activeRoute.routeNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: colors.primaryText),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: colors.primary.withValues(alpha: 0.4), width: 0.8),
                      ),
                      child: Text(
                        'Every ${activeRoute.frequencyMinutes} mins',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: colors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activeRoute.name,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: colors.secondaryText),
                ),
                const SizedBox(height: 14),

                // Next Departure Times Strip
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.elevatedCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colors.border, width: 0.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Next Bus', style: GoogleFonts.inter(fontSize: 10.5, color: colors.primary)),
                            Text('8:35 AM', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primaryText)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.elevatedCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colors.border, width: 0.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Following Bus', style: GoogleFonts.inter(fontSize: 10.5, color: colors.mutedText)),
                            Text('9:05 AM', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.secondaryText)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(height: 28),

                // Route Stops Timeline
                Text('STOPS & TIMELINE', style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: colors.primaryText)),
                const SizedBox(height: 14),

                ...List.generate(activeRoute.stops.length, (idx) {
                  final stop = activeRoute.stops[idx];
                  final isFirst = idx == 0;
                  final isLast = idx == activeRoute.stops.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Node & Connector Line
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFirst || isLast ? colors.primary : colors.elevatedCard,
                              border: Border.all(color: isFirst || isLast ? colors.primary : colors.border, width: 2),
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 1.5,
                              height: 32,
                              color: colors.border,
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            stop,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isFirst || isLast ? FontWeight.w700 : FontWeight.w500,
                              color: isFirst || isLast ? colors.primaryText : colors.secondaryText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAssistantTab(TransportProvider transport, AppColorPalette colors) {
    return Column(
      children: [
        // Chat Stream
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transport.chatHistory.length,
            itemBuilder: (context, index) {
              final msg = transport.chatHistory[index];
              return Align(
                alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: msg.isUser ? colors.primary.withValues(alpha: 0.12) : colors.card,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      topLeft: msg.isUser ? const Radius.circular(16) : const Radius.circular(4),
                      topRight: !msg.isUser ? const Radius.circular(16) : const Radius.circular(4),
                    ),
                    border: Border.all(
                      color: msg.isUser ? colors.primary.withValues(alpha: 0.4) : colors.border,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.4,
                      color: colors.primaryText,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Quick Suggestions Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              _buildSuggestionChip('How do I reach the library?', transport, colors),
              const SizedBox(width: 8),
              _buildSuggestionChip('Which bus goes to sports complex?', transport, colors),
              const SizedBox(width: 8),
              _buildSuggestionChip('When should I leave hostel?', transport, colors),
            ],
          ),
        ),

        // Input Field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.card,
            border: Border(top: BorderSide(color: colors.border, width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.elevatedCard,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.border, width: 1),
                  ),
                  child: TextField(
                    controller: _assistantInputCtrl,
                    style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
                    decoration: InputDecoration(
                      hintText: 'Ask transport assistant...',
                      hintStyle: GoogleFonts.inter(color: colors.mutedText, fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        transport.sendAssistantMessage(val);
                        _assistantInputCtrl.clear();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                  boxShadow: [
                    colors.cardShadow,
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_upward_rounded, size: 18, color: Colors.white),
                  onPressed: () {
                    final text = _assistantInputCtrl.text.trim();
                    if (text.isNotEmpty) {
                      transport.sendAssistantMessage(text);
                      _assistantInputCtrl.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleBadge(String text, AppColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.elevatedCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.border, width: 0.8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: colors.primaryText),
      ),
    );
  }

  Widget _buildSuggestionChip(String prompt, TransportProvider transport, AppColorPalette colors) {
    return InkWell(
      onTap: () => transport.sendAssistantMessage(prompt),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colors.elevatedCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Text(
          prompt,
          style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
        ),
      ),
    );
  }
}
