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

class HostelLeaveScreen extends StatefulWidget {
  const HostelLeaveScreen({super.key});

  @override
  State<HostelLeaveScreen> createState() => _HostelLeaveScreenState();
}

class _HostelLeaveScreenState extends State<HostelLeaveScreen> {
  String _selectedFilter = 'ALL';

  void _openSubmitLeaveSheet(BuildContext context) {
    final colors = AppColors.of(context);
    final reasonController = TextEditingController();
    final emergencyContactController = TextEditingController(text: '+91 98450 12345 (Parent)');
    String selectedType = 'Home Visit';
    DateTime fromDate = DateTime.now().add(const Duration(days: 1));
    DateTime toDate = DateTime.now().add(const Duration(days: 3));
    final formKey = GlobalKey<FormState>();

    final leaveTypes = ['Home Visit', 'Medical Leave', 'Weekend Outing', 'Academic Event', 'Emergency Leave'];

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
                            'Request Hostel Leave / Outing',
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

                      // Leave Type
                      Text(
                        'Leave Category',
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
                          child: DropdownButton<String>(
                            value: selectedType,
                            isExpanded: true,
                            dropdownColor: modalColors.card,
                            items: leaveTypes.map((t) {
                              return DropdownMenuItem(
                                value: t,
                                child: Text(t, style: GoogleFonts.inter(fontSize: 13, color: modalColors.primaryText)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedType = val);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Dates Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From Date',
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: modalColors.primaryText),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: modalContext,
                                      initialDate: fromDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 90)),
                                    );
                                    if (picked != null) {
                                      setModalState(() => fromDate = picked);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: modalColors.elevatedCard,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: modalColors.border),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today_rounded, size: 16, color: modalColors.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${fromDate.day}/${fromDate.month}/${fromDate.year}',
                                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: modalColors.primaryText),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'To Date',
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: modalColors.primaryText),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: modalContext,
                                      initialDate: toDate.isAfter(fromDate) ? toDate : fromDate,
                                      firstDate: fromDate,
                                      lastDate: DateTime.now().add(const Duration(days: 90)),
                                    );
                                    if (picked != null) {
                                      setModalState(() => toDate = picked);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: modalColors.elevatedCard,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: modalColors.border),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.event_available_rounded, size: 16, color: modalColors.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${toDate.day}/${toDate.month}/${toDate.year}',
                                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: modalColors.primaryText),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Emergency Contact
                      AppTextField(
                        controller: emergencyContactController,
                        label: 'Parent / Emergency Contact Number',
                        hint: 'e.g. +91 98765 43210',
                        prefixIcon: Icons.phone_outlined,
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Emergency contact required' : null,
                      ),

                      const SizedBox(height: 14),

                      // Reason
                      AppTextField(
                        controller: reasonController,
                        label: 'Reason for Leave',
                        hint: 'Provide reason and destination address...',
                        prefixIcon: Icons.notes_rounded,
                        maxLines: 2,
                        validator: (val) => (val == null || val.trim().length < 4) ? 'Please enter a valid reason' : null,
                      ),

                      const SizedBox(height: 20),

                      AppButton(
                        text: 'Submit Leave Request',
                        width: double.infinity,
                        icon: Icons.assignment_turned_in_rounded,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<HostelProvider>().submitLeaveRequest(
                                  leaveType: selectedType,
                                  fromDate: fromDate,
                                  toDate: toDate,
                                  reason: reasonController.text.trim(),
                                  emergencyContact: emergencyContactController.text.trim(),
                                );
                            Navigator.of(modalContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Leave request sent for Warden approval!'),
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

  void _showGatepassDialog(BuildContext context, HostelLeaveRequest leave) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Approved Gate Pass',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: colors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.primary, width: 2),
              ),
              child: const Icon(Icons.qr_code_2_rounded, size: 120, color: Colors.black87),
            ),
            const SizedBox(height: 14),
            Text(
              '${leave.leaveType} Gate Pass',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primaryText),
            ),
            const SizedBox(height: 4),
            Text(
              'Valid: ${leave.fromDate.day}/${leave.fromDate.month} – ${leave.toDate.day}/${leave.toDate.month}',
              style: GoogleFonts.inter(fontSize: 12, color: colors.success, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Approved by: ${leave.approvedBy ?? "Chief Warden"}',
              style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Close', style: TextStyle(color: colors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hostelProvider = context.watch<HostelProvider>();
    final allLeaves = hostelProvider.leaveRequests;

    final leaves = allLeaves.where((l) {
      if (_selectedFilter == 'PENDING') return l.status == LeaveStatus.pending;
      if (_selectedFilter == 'APPROVED') return l.status == LeaveStatus.approved;
      if (_selectedFilter == 'REJECTED') return l.status == LeaveStatus.rejected;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Leave & Outing Pass',
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
          'Apply Leave',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () => _openSubmitLeaveSheet(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('ALL', 'All (${allLeaves.length})', colors),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'PENDING',
                      'Pending (${allLeaves.where((l) => l.status == LeaveStatus.pending).length})',
                      colors,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      'APPROVED',
                      'Approved (${allLeaves.where((l) => l.status == LeaveStatus.approved).length})',
                      colors,
                    ),
                  ],
                ),
              ),
            ),

            // Leaves List
            Expanded(
              child: leaves.isEmpty
                  ? Center(
                      child: AppEmptyState(
                        icon: Icons.holiday_village_outlined,
                        title: 'No Leave Requests',
                        description: 'Plan your trips or home visits by applying for a digital gate pass.',
                        actionText: '+ Apply Leave',
                        onAction: () => _openSubmitLeaveSheet(context),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: leaves.length,
                      itemBuilder: (context, index) {
                        final leave = leaves[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildLeaveCard(leave, colors),
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
    final isSelected = _selectedFilter == key;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = key),
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

  Widget _buildLeaveCard(HostelLeaveRequest leave, AppColorPalette colors) {
    Color statusColor;
    switch (leave.status) {
      case LeaveStatus.pending:
        statusColor = colors.warning;
        break;
      case LeaveStatus.approved:
        statusColor = colors.success;
        break;
      case LeaveStatus.rejected:
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
                  leave.leaveType.toUpperCase(),
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
                child: Text(
                  leave.status.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.date_range_rounded, size: 16, color: colors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${leave.fromDate.day}/${leave.fromDate.month}/${leave.fromDate.year}  →  ${leave.toDate.day}/${leave.toDate.month}/${leave.toDate.year}',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            leave.reason,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Emergency Contact: ${leave.emergencyContact}',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: colors.mutedText,
            ),
          ),
          if (leave.status == LeaveStatus.approved) ...[
            const SizedBox(height: 12),
            AppButton(
              text: 'View Gate Pass QR',
              type: AppButtonType.secondary,
              icon: Icons.qr_code_rounded,
              width: double.infinity,
              onPressed: () => _showGatepassDialog(context, leave),
            ),
          ],
        ],
      ),
    );
  }
}
