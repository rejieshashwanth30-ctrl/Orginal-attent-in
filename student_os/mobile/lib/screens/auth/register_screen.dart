import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _collegeController = TextEditingController(text: 'National Institute of Technology');
  final _rollNumberController = TextEditingController();

  String _selectedDepartment = 'CSE';
  int _selectedYear = 3;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _collegeController.dispose();
    _rollNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      email: _emailController.text,
      password: _passwordController.text,
      fullName: _fullNameController.text,
      college: _collegeController.text,
      department: _selectedDepartment,
      year: _selectedYear,
      rollNumber: _rollNumberController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome to ATTENT-IN! Account created.')),
        );
        context.go('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Registration failed.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width * 0.24).clamp(76.0, 110.0),
                      height: (MediaQuery.of(context).size.width * 0.24).clamp(76.0, 110.0),
                      child: Image.asset(
                        AppConstants.appLogo,
                        fit: BoxFit.contain,
                        semanticLabel: 'ATTENT-IN Logo',
                      ),
                    ),
                  ),
                ),
                Text(
                  'Join ATTENT-IN',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set up your student profile and workspace',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: colors.secondaryText,
                  ),
                ),
                const SizedBox(height: 20),

                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _fullNameController,
                        label: 'Full Name',
                        hint: 'e.g. Aarav Sharma',
                        prefixIcon: Icons.person_outline,
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Full name is required' : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _emailController,
                        label: 'College Email',
                        hint: 'student@college.edu',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Email is required';
                          if (!val.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: '••••••••',
                              prefixIcon: Icons.lock_outline,
                              isPassword: true,
                              validator: (val) => (val == null || val.length < 6) ? 'Min 6 chars' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm',
                              hint: '••••••••',
                              prefixIcon: Icons.lock_outline,
                              isPassword: true,
                              validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // College & Department Card
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: _collegeController,
                        label: 'Institution / College',
                        hint: 'National Institute of Technology',
                        prefixIcon: Icons.school_outlined,
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'College is required' : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          // Department Dropdown
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Department',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: colors.elevatedCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: colors.border),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedDepartment,
                                      isExpanded: true,
                                      dropdownColor: colors.card,
                                      items: AppConstants.departments.map((d) {
                                        return DropdownMenuItem(value: d, child: Text(d, style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText)));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedDepartment = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Year Dropdown
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Year',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: colors.elevatedCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: colors.border),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: _selectedYear,
                                      isExpanded: true,
                                      dropdownColor: colors.card,
                                      items: AppConstants.years.map((y) {
                                        return DropdownMenuItem(value: y, child: Text('Year $y', style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText)));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedYear = val);
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
                      AppTextField(
                        controller: _rollNumberController,
                        label: 'Roll / Registration Number',
                        hint: 'e.g. 21BCSE088',
                        prefixIcon: Icons.badge_outlined,
                        validator: (val) => (val == null || val.trim().isEmpty) ? 'Roll number is required' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: 'Create Account & Launch OS',
                  width: double.infinity,
                  isLoading: auth.isLoading,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
