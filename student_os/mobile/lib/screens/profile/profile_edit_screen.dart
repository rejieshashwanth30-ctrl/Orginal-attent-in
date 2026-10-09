import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _collegeController;
  late TextEditingController _rollController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _gpaController;
  late String _department;
  late int _year;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AuthProvider>().user?.profile;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _collegeController = TextEditingController(text: profile?.college ?? '');
    _rollController = TextEditingController(text: profile?.rollNumber ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _gpaController = TextEditingController(text: profile?.gpa.toString() ?? '8.7');
    _department = profile?.department ?? 'CSE';
    _year = profile?.year ?? 3;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _collegeController.dispose();
    _rollController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final auth = context.read<AuthProvider>();
    final ok = await auth.updateProfile({
      'fullName': _nameController.text.trim(),
      'college': _collegeController.text.trim(),
      'rollNumber': _rollController.text.trim(),
      'phone': _phoneController.text.trim(),
      'bio': _bioController.text.trim(),
      'department': _department,
      'year': _year,
      'gpa': double.tryParse(_gpaController.text.trim()) ?? 8.7,
    });

    setState(() => _isSaving = false);

    if (mounted) {
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Aarav Sharma',
                        prefixIcon: Icons.person_outline,
                        validator: (val) => val == null || val.trim().isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hint: '+91 98765 43210',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _bioController,
                        label: 'Personal Bio',
                        hint: 'Passionate about ML systems & mobile software design.',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _collegeController,
                        label: 'Institution / College',
                        hint: 'National Institute of Technology',
                        prefixIcon: Icons.school_outlined,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Department', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceSecondary : AppColors.lightSurfaceSecondary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: AppConstants.departments.contains(_department) ? _department : AppConstants.departments.first,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                      items: AppConstants.departments.map((d) {
                                        return DropdownMenuItem(value: d, child: Text(d, style: GoogleFonts.inter(fontSize: 12)));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _department = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Year', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceSecondary : AppColors.lightSurfaceSecondary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: _year,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                      items: AppConstants.years.map((y) {
                                        return DropdownMenuItem(value: y, child: Text('Yr $y', style: GoogleFonts.inter(fontSize: 12)));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _year = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _rollController,
                              label: 'Roll Number',
                              hint: '21BCSE088',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _gpaController,
                              label: 'Cumulative GPA',
                              hint: '8.7',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: 'Save Changes',
                  width: double.infinity,
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
