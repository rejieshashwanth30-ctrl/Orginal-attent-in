import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hostel_models.dart';
import '../../providers/hostel_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/app_text_field.dart';

class HostelComplaintsScreen extends StatefulWidget {
  const HostelComplaintsScreen({super.key});

  @override
  State<HostelComplaintsScreen> createState() => _HostelComplaintsScreenState();
}

class _HostelComplaintsScreenState extends State<HostelComplaintsScreen> {
  String _selectedStatusFilter = 'ALL';

  void _openSubmitComplaintSheet(BuildContext context) {
    final colors = AppColors.of(context);
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    ComplaintCategory selectedCategory = ComplaintCategory.room;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final modalColors = AppColors.of(modalContext);

            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: modalColors.card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Submit Hostel Complaint',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: modalColors.primaryText,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded, color: modalColors.secondaryText),
                            onPressed: () => Navigator.of(modalContext).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      Text(
                        'Complaint Category',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: modalColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: modalColors.elevatedCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: modalColors.border,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ComplaintCategory>(
                            value: selectedCategory,
                            isExpanded: true,
                            dropdownColor: modalColors.card,
                            items: ComplaintCategory.values.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  cat.displayName,
                                  style: GoogleFonts.inter(fontSize: 13, color: modalColors.primaryText),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => selectedCategory = val);
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Title
                      AppTextField(
                        controller: titleController,
                        label: 'Complaint Summary',
                        hint: 'e.g. Wi-Fi Router Disconnecting / Tap Leakage',
                        prefixIcon: Icons.title_rounded,
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a summary' : null,
                      ),

                      const SizedBox(height: 14),

                      // Description
                      AppTextField(
                        controller: descriptionController,
                        label: 'Detailed Description',
                        hint: 'Describe the issue, location in room, and urgency...',
                        prefixIcon: Icons.description_outlined,
                        maxLines: 3,
                        validator: (val) => (val == null || val.trim().length < 5) ? 'Please provide more details' : null,
                      ),

                      const SizedBox(height: 20),

                      AppButton(
                        text: 'Submit to Hostel Warden',
                        width: double.infinity,
                        icon: Icons.send_rounded,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<HostelProvider>().submitComplaint(
                                  title: titleController.text.trim(),
                                  description: descriptionController.text.trim(),
                                  category: selectedCategory,
                                );
                            Navigator.of(modalContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Complaint submitted successfully to maintenance team!'),
                                backgroundColor: colors.success,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hostelProvider = context.watch<HostelProvider>();
    final allComplaints = hostelProvider.complaints;

    // Filter
    final complaints = allComplaints.where((c) {
      if (_selectedStatusFilter == 'PENDING') return c.status == ComplaintStatus.pending;
      if (_selectedStatusFilter == 'IN_PROGRESS') return c.status == ComplaintStatus.inProgress;
      if (_selectedStatusFilter == 'RESOLVED') return c.status == ComplaintStatus.resolved;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Hostel Complaints',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'New Complaint',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () => _openSubmitComplaintSheet(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('ALL', 'All (${allComplaints.length})', colors),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'PENDING',
                      'Pending (${allComplaints.where((c) => c.status == ComplaintStatus.pending).length})',
                      colors,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'IN_PROGRESS',
                      'In Progress (${allComplaints.where((c) => c.status == ComplaintStatus.inProgress).length})',
                      colors,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'RESOLVED',
                      'Resolved (${allComplaints.where((c) => c.status == ComplaintStatus.resolved).length})',
                      colors,
                    ),
                  ],
                ),
              ),
            ),

            // Complaints List
            Expanded(
              child: complaints.isEmpty
                  ? Center(
                      child: AppEmptyState(
                        icon: Icons.report_off_rounded,
                        title: 'No Complaints Found',
                        description: 'Everything is running smoothly! Tap + New Complaint if you need assistance.',
                        actionText: '+ Raise Issue',
                        onAction: () => _openSubmitComplaintSheet(context),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: complaints.length,
                      itemBuilder: (context, index) {
                        final comp = complaints[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildComplaintCard(comp, colors),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, AppColorPalette colors) {
    final isSelected = _selectedStatusFilter == key;
    return InkWell(
      onTap: () => setState(() => _selectedStatusFilter = key),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary
              : colors.elevatedCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : colors.primaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintCard(HostelComplaint comp, AppColorPalette colors) {
    Color statusColor;
    switch (comp.status) {
      case ComplaintStatus.pending:
        statusColor = colors.warning;
        break;
      case ComplaintStatus.inProgress:
        statusColor = colors.primary;
        break;
      case ComplaintStatus.resolved:
        statusColor = colors.success;
        break;
      case ComplaintStatus.rejected:
        statusColor = colors.danger;
        break;
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  comp.category.displayName.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: colors.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      comp.status.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comp.title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            comp.description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colors.secondaryText,
              height: 1.35,
            ),
          ),
          if (comp.adminRemarks != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.elevatedCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colors.border,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Maintenance Update:',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          comp.adminRemarks!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: colors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Room ${comp.roomNumber}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: colors.mutedText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${comp.createdAt.day}/${comp.createdAt.month}/${comp.createdAt.year}',
                style: GoogleFonts.inter(
                  fontSize: 11,
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
